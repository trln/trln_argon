module TrlnArgon
  module SyndeticsHelpers
    IMG_OPTIONS = { client: 'trlnet', size: :small }.freeze

    # available image sizes and their codes
    SIZES = Hash.new('SC.GIF').update(small: 'SC.GIF',
                                      medium: 'MC.GIF',
                                      large: 'LC.JPG').freeze

    # @param doc [SolrDocument] the current document being rendered
    # @param options [Hash<Symbol, Object>] customization options
    # @option options :client [String] client parameter for syndetics request
    # @option options :size [String, Symbol] image size (:small, :medium, :large)
    # @yield [String] a prospective URL for the specified cover image
    def cover_image(doc, options = { client: 'trlnet', size: :small })
      options = {}.update(IMG_OPTIONS).update(options)
      params = get_params(doc, options[:client], SIZES[options[:size].to_sym])
      yield build_syndetics_query(params) if params
    end

    def build_syndetics_query(params)
      URI::HTTPS.build(host: 'syndetics.com',
                       path: '/index.php',
                       query: params.to_query.gsub(/%5B%5D/, ''))
    end

    # rubocop:disable MethodLength
    def get_params(doc, client = 'trlnet', format_spec = 'XML.XML')
      params = {
        isbn: doc.fetch('isbn_number_a', []).dup,
        oclc: doc.fetch('oclc_number', []).dup
        # placeholder for UPC and EAN when they are added
      }
      %i[isbn oclc upc ean].each do |k|
        if params.fetch(k, []).empty?
          params.delete(k)
        else
          params[k][0] = "#{params[k][0]}/#{format_spec}"
          break
        end
      end
      params.empty? ? false : params.update(client: client)
    end

    # fetches enhanced data (SyndeticsData object) and yields it to a block,
    # if it's available.
    def enhanced_data(doc, client = 'trlnet')
      params = get_params(doc, client, 'XML.XML')
      return nil unless params
      begin
        doc_xml = Faraday.get(build_syndetics_query(params)).body
        data = TrlnArgon::SyndeticsData.new(Nokogiri::XML(doc_xml))
      rescue StandardError => e
        logger.warn("unable to fetch syndetics data for #{doc['id']} -- #{params}: #{e}")
      end
      yield data if block_given? && !data.nil?
      data
    end
  end
end
