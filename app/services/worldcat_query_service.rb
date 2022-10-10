# frozen_string_literal: true

# rubocop has waaay too many false positives, and this is a
# tricky class to refactor

# rubocop:disable all
# Service for querying worldcat based on Blacklight search
class WorldcatQueryService
  extend TrlnArgon::HTTPFetch
  attr_reader :id, :query_params

  DEFAULTS = {
    params: {
      maximumRecords: '1',
      wskey: ENV['WORLDCAT_API_KEY'],
      servicelevel: 'full'
    }
  }.freeze

  QUERY_MAP = {
    author: 'au',
    isbn: 'bn',
    issn: 'in',
    isbn_issn: 'bn', # need to combine with issn'(bn or in)' #needs testing
    all_fields: 'kw',
    oclc: 'no',
    publisher: 'pb',
    subject: 'su',
    title: 'ti',
    q: 'kw'
    # year: 'yr' # too complicated to support year range now
  }.freeze

  LINK_MAP = {
    author: 'au',
    isbn: 'bn',
    issn: 'n2',
    isbn_issn: 'bn', # same as above
    all_fields: 'kw',
    oclc: 'no',
    publisher: 'pb',
    subject: 'su',
    title: 'ti',
    q: 'kw'
    # year: 'yr' # same as above
  }.freeze

  def self.available?
    ENV['WORLDCAT_URL'].present?
  end

  def initialize(search_session)
    if search_session.is_a?(Hash)
      @id = search_session.fetch(:id, nil)
      @query_params = search_session.fetch(:query_params, nil)
      @count = search_session.fetch(:count, nil)
      @query_url = search_session.fetch(:query_url, nil)
    else
      @id = search_session.id
      @query_params = search_session.query_params
    end
  end

  def query_url
    @query_url ||= search_worldcat_path
  end

  def to_h
    { id: @id, query_params: @query_params, count: @count, query_url: @query_url }
  end

  def worldcat_base_url
    ENV['WORLDCAT_URL']
  end

  def search_worldcat_path
    query = build_string('link')
    return worldcat_base_url if query.nil? || query.empty?

    u = URI(worldcat_base_url)
    u.path = '/search'
    u.query = 'queryString=' + query
    u.to_s
    #worldcat_base_url + 'search?queryString=' + query
  end

  def map_field(type = 'query', field = 'q', exact = true)
    field_type = type.upcase + '_MAP'
    return '' if self.class.const_get(field_type)[:"#{field}"].nil?

    if type == 'query'
      modifier = exact ? ' = ' : ' all '
      prepend = type == 'query' ? 'srw.' : ''
      placeholder = '"%s"'
    else
      modifier = exact ? '=' : ':'
      prepend = ''
      placeholder = '%s'
    end
    prepend + self.class.const_get(field_type)[:"#{field}"] + modifier + placeholder
  end

  private

  def strip_params(params)
    return '' if params.nil?

    params.reject! { |_k, v| v.nil? || v.empty? || !v.instance_of?(String) }
    params.each_with_object({}) { |(k, v), h| h[k] = tokenize(v); }
  end

  def tokenize(query)
    query&.scan(/("[^"]+"|[^\s"][\w\s]+[^\s"])/)&.flatten
  end


  def build_string(type = 'query')
    params = strip_params(@query_params)
    return '' if params.nil? || params.empty?

    joiner = @query_params[:op] || 'AND'
    fields = []
    params.each do |k, v|
      next if v.empty?

      if v.respond_to?('each')
        v.each do |sub|
          fields << if /^"[^"]+"$/.match?(sub)
                      map_field(type, k, true) % sub[1..-2]
                    else
                      map_field(type, k, false) % sub
                    end
        end
      else
        fields << map_field(type, k, false) % v # don't think this gets called
      end
    end
    fields.reject(&:empty?).join(" #{joiner} ") unless fields.nil? || fields.empty?
    # TODO: does not handle + or - modifiers nor manual AND OR NOT in query fields in search
  end
end
#  rubocop:enable all
