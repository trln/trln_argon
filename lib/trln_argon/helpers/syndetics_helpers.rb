module TrlnArgon
  module SyndeticsHelpers
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

    # rubocop:disable MethodLength
    # rubocop:disable Metrics/AbcSize
    def enhanced_data(doc, options = { client: 'trlnet' })
      isbns = doc.fetch('isbn_number_a', [])
      isbns[0] = "#{isbns[0]}/XML.XML"
      oclc = doc.fetch('oclc_number', '')
      data = nil
      unless isbns.empty? && oclc == ''
        q = { isbn: isbns, oclc: oclc, client: options[:client] }.to_query.gsub(/%5B%5D/, '')
        begin
          doc_xml = Faraday.get(enhanced_data_url(q)).body
          data = TrlnArgon::SyndeticsData.new(Nokogiri::XML(doc_xml))
        rescue StandardError => e
          logger.warn("unable to fetch syndetics data for #{doc['id']} -- #{q}: #{e}")
        end
        yield data if block_given? && !data.nil?
      end
      data
    end
  end
end
