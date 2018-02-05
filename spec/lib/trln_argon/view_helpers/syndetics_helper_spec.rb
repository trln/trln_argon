require 'cgi'
require 'uri'

describe TrlnArgon::ViewHelpers::SyndeticsHelper, type: :helper do
  include described_class

  describe '#cover_image' do
    context 'when we link to a Syndetics cover image with various options' do
      let(:oclc) do
        '123098080985'
      end

      let(:isbn) do
        '123456789012X'
      end

      let(:document) do
        SolrDocument.new(
          id: 'TRLN12345',
          isbn_number_a: ['123456789012X']
        )
      end

      let(:oclc_document) do
        SolrDocument.new(
          id: 'TRLN12345',
          isbn_number_a: ['123456789012X'],
          oclc_number: '123098080985'
        )
      end

      let(:url_template) do
        'http://www.syndetics.com/index.aspc?isbn=%s/%s&client=trlnet'
      end

      it 'generates a link to a small cover image with defaults' do
        expected = URI(format(url_template, isbn, 'SC.GIF'))
        actual = cover_image(document) { |x| URI(x) }
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end

      it 'generates a link to a small cover image with custom options' do
        expected = URI(format(url_template.gsub(/trlnet/, 'ncstateu'), isbn, 'SC.GIF'))
        actual = cover_image(document, size: 'small', client: 'ncstateu') do |x|
          URI(x)
        end
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end

      it 'generates a link to a medium cover image with an OCLC number' do
        expected = URI(format(url_template + '&oclc=' + oclc, isbn, 'MC.GIF'))
        actual = cover_image(oclc_document, size: :medium) { |x| URI(x) }
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end
    end
  end
end
