module TrlnArgon
  module SolrDocument
    module SyndeticsData
      IMG_OPTIONS = { client: 'trlnet', size: :small }.freeze

      # available image sizes and their codes
      SIZES = Hash.new('SC.GIF').update(small: 'SC.GIF',
                                        medium: 'MC.GIF',
                                        large: 'LC.JPG').freeze

      def syndetics_data
        @syndetics_data ||= enhanced_data
      end

      def syndetics_or_marc_summary
        @syndetics_or_marc_summary ||=
          (syndetics_data && syndetics_data.summary? && syndetics_data.summary) ||
          marc_summary
      end

      def syndetics_or_marc_toc
        @syndetics_or_marc_toc ||=
          (syndetics_data && syndetics_data.toc? && syndetics_data.toc) ||
          marc_toc
      end

      def syndetics_or_marc_sample_chapter
        @syndetics_or_marc_sample_chapter ||=
          (syndetics_data && syndetics_data.samplechapter? && syndetics_data.samplechapter) || nil
      end

      # @param doc [SolrDocument] the current document being rendered
      # @param options [Hash<Symbol, Object>] customization options
      # @option options :client [String] client parameter for syndetics request
      # @option options :size [String, Symbol] image size (:small, :medium, :large)
      # @yield [String] a prospective URL for the specified cover image
      def cover_image(options = { client: 'trlnet', size: :small })
        options = {}.update(IMG_OPTIONS).update(options)
        params = get_params(options[:client], SIZES[options[:size].to_sym])
        # build_syndetics_query(params) if params
        yield build_syndetics_query(params) if params
      end

      private

      # fetches enhanced data (SyndeticsData object) and yields it to a block,
      # if it's available.
      # rubocop:disable MethodLength
      def enhanced_data(client = 'trlnet')
        params = get_params(client, 'XML.XML')
        return nil unless params
        begin
          doc_xml = Faraday.get(build_syndetics_query(params)).body
          data = TrlnArgon::SyndeticsData.new(Nokogiri::XML(doc_xml))
        rescue StandardError => e
          Rails.logger.warn('unable to fetch syndetics data for '\
                            "#{fetch('id', 'unknown document')} "\
                            "-- #{params}: #{e}")
        end
        yield data if block_given? && !data.nil?
        data
      end

      def build_syndetics_query(params)
        URI::HTTPS.build(host: 'syndetics.com',
                         path: '/index.php',
                         query: params.to_query.gsub(/%5B%5D/, ''))
      end

      def get_params(client = 'trlnet', format_spec = 'XML.XML')
        params = {
          isbn: [fetch(TrlnArgon::Fields::ISBN_NUMBER, []).first],
          oclc: fetch(TrlnArgon::Fields::OCLC_NUMBER, []).dup,
          upc: [upc.first].compact
          # placeholder for EAN when added
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
    end
  end
end
