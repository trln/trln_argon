module TrlnArgon
  module HathitrustControllerBehavior
    extend ActiveSupport::Concern

    included do
      def show
        render json: hathi_links_grouped_by_oclc_number
      end

      private

      def hathi_links_grouped_by_oclc_number
        hathitrust_response_hash.map do |key, value|
          full_text_url = hathitrust_fulltext_url(value)
          next unless hathitrust_fulltext_item?(value)
          [key.delete(':'), render_hathitrust_partial_to_string(full_text_url)]
        end.compact.to_h.to_json
      end

      def render_hathitrust_partial_to_string(full_text_url)
        render_to_string('hathitrust/show',
                         locals: { hathitrust_argon_url_hash:
                                     hathitrust_argon_url_hash(full_text_url) },
                         layout: false).gsub(/<!--.*?-->/m, '')
      end

      def hathitrust_argon_url_hash(full_text_url)
        { href: full_text_url,
          type: 'fulltext',
          text: I18n.t('trln_argon.links.hathitrust') }
      end

      def hathitrust_fulltext_url(value)
        value.fetch('records', {}).map { |_k, v| v.fetch('recordURL', '') }.first
      end

      def hathitrust_fulltext_item?(value)
        value.fetch('items', [])
             .select { |i| i.fetch('usRightsString') == 'Full view' }
             .any?
      end

      def hathitrust_response_hash
        @hathitrust_response_hash ||= JSON.parse(hathitrust_api_response)
      end

      def hathitrust_api_response
        response = Net::HTTP.start(hathitrust_uri.host,
                                   hathitrust_uri.port,
                                   open_timeout: 10,
                                   read_timeout: 10,
                                   use_ssl: hathitrust_uri.scheme == 'https') do |http|
                                     request = Net::HTTP::Get.new hathitrust_uri
                                     http.request request
                                   end
        response.body
      rescue SocketError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
        '{}'
      end

      def hathitrust_uri
        @hathitrust_uri ||= URI(hathitrust_uri_path)
      end

      def hathitrust_uri_path
        [hathitrust_base_uri,
         'api',
         'volumes',
         'brief',
         'json',
         URI.encode_www_form_component(munge_oclc_number_params)].join('/')
      end

      def munge_oclc_number_params
        params[:oclc_numbers].split('|')
                             .delete_if { |entry| entry.match(/\D/) }
                             .map { |num| "oclc:#{num}" }
                             .join('|')
      end

      def hathitrust_base_uri
        'https://catalog.hathitrust.org'
      end
    end
  end
end
