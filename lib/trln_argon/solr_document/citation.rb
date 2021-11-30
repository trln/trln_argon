# module TrlnArgon
#   module SolrDocument
#     module Citation
#       def citable?
#         oclc_number.present? && citations.present?
#       end

#       def citations
#         @all_citations ||= begin
#           citation_hash = {}
#           desired_formats.each do |format|
#             citation = world_cat_api_response(format).html_safe
#             if citation != 'info:srw/diagnostic/1/65Record does not exist'
#               citation_hash[format] = citation
#             end
#           end
#           citation_hash
#         end
#       end

#       private

#       def world_cat_api_response(format)
#         url = world_cat_uri(format)

#         Net::HTTP.start(url.host, url.port) do |http|
#           request = Net::HTTP::Get.new url
#           response = http.request request
#           response.body
#         end
#       rescue SocketError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
#              Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
#         Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
#         '{}'
#       end

#       def desired_formats
#         TrlnArgon::Engine.configuration.citation_formats.split(', ')
#       end

#       def world_cat_uri(format)
#         URI([base_url, oclc_number, '?cformat=', format, '&wskey=', api_key].join)
#       end

#       def base_url
#         TrlnArgon::Engine.configuration.worldcat_cite_base_url
#       end

#       def api_key
#         TrlnArgon::Engine.configuration.worldcat_cite_api_key
#       end
#     end
#   end
# end
