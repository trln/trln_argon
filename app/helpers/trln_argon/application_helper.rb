module TrlnArgon
  module ApplicationHelper
    SIZES = Hash.new('SC.GIF').update(small: 'SC.GIF',
                                      medium: 'MC.GIF',
                                      large: 'LC.GIF').freeze
    def cover_image(doc, options = { client: 'trlnet', size: 'small' })
      isbn = doc.fetch('isbn_number_a', ['']).first
      oclc = doc.fetch('oclc_number', '')
      q = { isbn: "#{isbn}/#{SIZES[options[:size]]}",
            oclc: oclc,
            client: options[:client] }.to_query
      URI::HTTP.build(host: 'www.syndetics.com',
                      path: '/index.aspx',
                      query: q).to_s
    end
  end
end
