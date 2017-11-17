module TrlnArgon
  # Shared helpers for TRLN Argon based applicatilns
  # Methods can be overridden in the local application
  # in app/helpers/trln_argon_helper.rb
  module TrlnArgonHelperBehavior
    # initial default options for #cover_image
    IMG_OPTIONS = { client: 'trlnet', size: :small }.freeze

    # available image sizes and their codes
    SIZES = Hash.new('SC.GIF').update(small: 'SC.GIF',
                                      medium: 'MC.GIF',
                                      large: 'LC.JPG').freeze

    # Generate a link to a cover image
    # @param doc [SolrDocument] the current document being rendered
    # @param options [Hash<Symbol, Object>] customization options
    # @option options :client [String] client parameter for syndetics request
    # @option options :size [String, Symbol] image size (:small, :medium, :large)
    def cover_image(doc, options = { client: 'trlnet', size: :small })
      options = {}.update(IMG_OPTIONS).update(options)
      isbn = doc.fetch('isbn_number_a', ['']).first
      oclc = doc.fetch('oclc_number', '')
      q = { isbn: "#{isbn}/#{SIZES[options[:size].to_sym]}",
            oclc: oclc,
            client: options[:client] }.to_query
      URI::HTTPS.build(host: 'syndetics.com',
                       path: '/index.php',
                       query: q).to_s
    end

    def enhanced_data_url(query)
      URI::HTTPS.build(host: 'syndetics.com',
                       path: '/index.php',
                       query: query).to_s
    end

    def enhanced_data(doc, options = { client: 'trlnet' })
      isbns = doc.fetch('isbn_number_a', [])
      isbns[0] = "#{isbns[0]}/XML.XML"
      oclc = doc.fetch('oclc_number', '')
      # to_query puts [] at the end of params, which syndetics doesn't want
      q = { isbn: isbns, oclc: oclc, client: options[:client] }.to_query.gsub(/%5B%5D/, '')
      data = nil
      begin
        doc_xml = Faraday.get(enhanced_data_url(q)).body
        data = TrlnArgon::SyndeticsData.new(Nokogiri::XML(doc_xml))
      rescue StandardError => e
        logger.warn("unable to fetch syndetics data for #{q}: #{e}")
      end
      yield data if block_given? && !data.nil?
      data
    end

    def institution_code_to_short_name(options = {})
      options[:value].map do |val|
        t("trln_argon.institution.#{val}.short_name", default: val)
      end.to_sentence
    end

    def auto_link_values(options = {})
      options[:value].map { |value| auto_link(value) }.to_sentence.html_safe
    end

    def entry_name(count)
      entry = t('blacklight.entry_name.default')
      count.to_int == 1 ? entry : entry.pluralize
    end

    def institution_short_name
      t("trln_argon.institution.#{TrlnArgon::Engine.configuration.local_institution_code}.short_name")
    end

    def institution_long_name
      t("trln_argon.institution.#{TrlnArgon::Engine.configuration.local_institution_code}.long_name")
    end

    def consortium_short_name
      t('trln_argon.consortium.short_name')
    end

    def consortium_long_name
      t('trln_argon.consortium.long_name')
    end

    def filter_scope_name
      if controller_name == 'bookmarks'
        t('trln_argon.scope_name.bookmarks')
      else
        local_filter_applied? ? institution_short_name : consortium_short_name
      end
    end

    def url_href_with_url_text_link(options = {})
      text = online_access_link_text(options[:value], options[:document][TrlnArgon::Fields::URL_TEXT])
      hrefs_and_text = options[:value].zip(text)
      hrefs_and_text.map do |href_text_pair|
        link_to href_text_pair.last, href_text_pair.first
      end.join('; ').html_safe
    end

    def map_argon_code(inst, context, value)
      TrlnArgon::LookupManager.instance.map([inst, context, value].join('.'))
    end

    private

    def online_access_link_text(url_hrefs, url_text)
      if url_text && url_text.count == url_hrefs.count
        url_text
      else
        [t('trln_argon.online_access')] * url_hrefs.count
      end
    end
  end
end
