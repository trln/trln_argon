module TrlnArgon
  module InternetArchiveControllerBehavior
    extend ActiveSupport::Concern

    # rubocop:disable BlockLength
    included do
      def show
        render json: ia_ids_grouped_by_class.to_json
      end

      private

      def ia_ids_grouped_by_class
        sanitize_internet_archive_id_params.split('||')
                                           .map { |ia_id_groups| ia_id_groups.split('|') }
                                           .map { |ia_ids| key_ia_id_pairs(ia_ids) }
                                           .compact
                                           .to_h
      end

      def key_ia_id_pairs(ia_ids)
        valid_ids = select_valid_ia_ids(ia_ids)
        return if valid_ids.empty?
        full_text_url = internet_archive_link(valid_ids)
        ["internet-archive-id-#{ia_ids.first}", render_ia_partial_to_string(full_text_url)]
      end

      def render_ia_partial_to_string(full_text_url)
        render_to_string(
          'internet_archive/show',
          locals: {
            internet_archive_argon_url_hash: ia_argon_url_hash(full_text_url)
          },
          layout: false
        ).gsub(/<!--.*?-->/m, '')
      end

      def ia_argon_url_hash(full_text_url)
        { href: full_text_url.html_safe,
          type: 'fulltext',
          text: I18n.t('trln_argon.links.internet_archive') }
      end

      def internet_archive_link(ia_ids)
        Addressable::Template.new('https://archive.org/search.php?query={IAQuery}&sort=publicdate')
                             .expand('IAQuery' => ia_query_param(ia_ids))
                             .to_s
      end

      def ia_query_param(ia_ids)
        "identifier:(#{ia_ids.join(' OR ')})"
      end

      def select_valid_ia_ids(ia_ids)
        ia_ids.select { |ia_id| validated_ia_ids.include?(ia_id) }
      end

      def ia_api_request_uri
        URI('https://archive.org/advancedsearch.php?'\
            "q=identifier:(#{list_of_all_supplied_ia_ids.join(' OR ')})"\
            '&fl[]=identifier&rows=250&output=json')
      end

      def ia_api_response
        response = Net::HTTP.start(ia_api_request_uri.host, ia_api_request_uri.port,
                                   open_timeout: 10,
                                   read_timeout: 10,
                                   use_ssl: ia_api_request_uri.scheme == 'https') do |http|
                                     request = Net::HTTP::Get.new ia_api_request_uri
                                     http.request request
                                   end
        response.body
      rescue SocketError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
        '{}'
      end

      def validated_ia_ids
        @validated_ia_ids ||=
          JSON.parse(ia_api_response)
              .fetch('response', {})
              .fetch('docs', [])
              .map { |e| e['identifier'] }
      end

      # Simple list of supplied IA IDs to use to check for valid ones
      def list_of_all_supplied_ia_ids
        sanitize_internet_archive_id_params.split('||')
                                           .map { |ia_id_groups| ia_id_groups.split('|') }
                                           .flatten
      end

      def sanitize_internet_archive_id_params
        @sanitize_internet_archive_id_params ||=
          params[:internet_archive_ids].split('||')
                                       .map { |ia_id_groups| ia_id_groups.gsub(/(?![\|_])[\p{S}[[:punct:]]]/, '') }
                                       .join('||')
      end
    end
  end
end
