# frozen_string_literal: true

require 'net/http'

# encapsulates common HTTP operations
module TrlnArgon::HTTPFetch
  def do_get(url)
    uri = URI(url)
    use_ssl = uri.scheme == 'https'
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: use_ssl) do |http|
      http.request(Net::HTTP::Get.new(uri))
    end
  rescue StandardError => e
    Rails.logger.error("Unable to fetch content from #{uri}: #{e}")
    raise e
  end

  def post_form(url, params)
    uri = URI(url)
    use_ssl = uri.scheme == 'https'
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(params)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: use_ssl) do |http|
      http.request(req)
    end
  end
end
