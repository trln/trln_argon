require 'cgi'
require 'uri'

describe TrlnArgonHelper do
  describe '#institution_code_to_short_name' do
    context 'code has a translation' do
      let(:options) { { value: %w[unc duke ncsu] } }

      it 'uses the translated value' do
        expect(helper.institution_code_to_short_name(options)).to eq('UNC, Duke, and NCSU')
      end
    end

    context 'code does not have a translation' do
      let(:options) { { value: ['pie'] } }

      it 'uses the default value' do
        expect(helper.institution_code_to_short_name(options)).to eq('pie')
      end
    end
  end

  describe '#auto_link_values' do
    context 'has a single link' do
      let(:options) { { value: ['https://library.duke.edu'] } }

      it 'returns a single linked value' do
        expect(helper.auto_link_values(options)).to eq('<a href="https://library.duke.edu">' \
                                                       'https://library.duke.edu</a>')
      end
    end

    context 'has more than one link' do
      let(:options) { { value: ['https://library.duke.edu', 'https://www.lib.ncsu.edu'] } }

      it 'returns a single linked value' do
        expect(helper.auto_link_values(options)).to eq('<a href="https://library.duke.edu">' \
                                                       'https://library.duke.edu</a> and ' \
                                                       '<a href="https://www.lib.ncsu.edu">' \
                                                       'https://www.lib.ncsu.edu</a>')
      end
    end

    context 'has a link and then something that is not a link' do
      let(:options) { { value: ['https://library.duke.edu', 'Soup'] } }

      it 'returns a linked value and a non-linked value' do
        expect(helper.auto_link_values(options)).to eq('<a href="https://library.duke.edu">' \
                                                       'https://library.duke.edu</a> and Soup')
      end
    end
  end

  describe '#entry_name' do
    context 'count is 1' do
      it 'does not pluralize the entry name' do
        expect(helper.entry_name(1)).to eq('result')
      end
    end

    context 'count is more than 1' do
      it 'pluralizes the entry name' do
        expect(helper.entry_name(2)).to eq('results')
      end
    end
  end

  describe '#institution_short_name' do
    it 'uses the configured and translated name' do
      expect(helper.institution_short_name).to eq('UNC')
    end
  end

  describe '#institution_long_name' do
    it 'uses the configured and translated name' do
      expect(helper.institution_long_name).to eq('UNC Libraries')
    end
  end

  describe '#consortium_short_name' do
    it 'uses the translated name' do
      expect(helper.consortium_short_name).to eq('TRLN')
    end
  end

  describe '#consortium_long_name' do
    it 'uses the translated name' do
      expect(helper.consortium_long_name).to eq('TRLN Libraries')
    end
  end

  describe '#filter_scope_name' do
    context 'scope is BookmarksController' do
      before { allow(helper).to receive(:controller_name).and_return('bookmarks') }

      it 'uses the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('bookmarked')
      end
    end

    context 'local filter is applied', verify_stubs: false do
      before do
        allow(helper).to receive(:controller_name).and_return('catalog')
        allow(helper).to receive(:local_filter_applied?).and_return(true)
      end

      it 'uses the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('UNC')
      end
    end

    context 'local filter is not applied', verify_stubs: false do
      before do
        allow(helper).to receive(:controller_name).and_return('catalog')
        allow(helper).to receive(:local_filter_applied?).and_return(false)
      end

      it 'uses the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('TRLN')
      end
    end
  end

  describe '#url_href_with_url_text_link' do
    context 'single link without text' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345'
        )
      end
      let(:options) do
        { value:    ['http://www.firstlink.edu'],
          document: document }
      end

      it 'generates a link using the default text' do
        expect(helper.url_href_with_url_text_link(options)).to(
          eq('<a href="http://www.firstlink.edu">Online Access</a>')
        )
      end
    end

    context 'single link with text' do
      let(:document) do
        SolrDocument.new(
          id:         'DUKE12345',
          url_text_a: ['First Link']
        )
      end
      let(:options) do
        { value:    ['http://www.firstlink.edu'],
          document: document }
      end

      it 'generates a link using the supplied text value' do
        expect(helper.url_href_with_url_text_link(options)).to(
          eq('<a href="http://www.firstlink.edu">First Link</a>')
        )
      end
    end

    context 'multiple links each without a text value' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345'
        )
      end
      let(:options) do
        { value:    ['http://www.firstlink.edu',
                     'http://www.secondlink.edu',
                     'http://www.thirdlink.edu'],
          document: document }
      end

      it 'generates all the links using the default text value' do
        expect(helper.url_href_with_url_text_link(options)).to(
          eq('<a href="http://www.firstlink.edu">Online Access</a>; '\
             '<a href="http://www.secondlink.edu">Online Access</a>; '\
             '<a href="http://www.thirdlink.edu">Online Access</a>')
        )
      end
    end

    context 'multiple links each with a text value' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345',
          url_text_a: ['First Link',
                       'Second Link',
                       'Third Link']
        )
      end
      let(:options) do
        { value:    ['http://www.firstlink.edu',
                     'http://www.secondlink.edu',
                     'http://www.thirdlink.edu'],
          document: document }
      end

      it 'generates each link with its own text value' do
        expect(helper.url_href_with_url_text_link(options)).to(
          eq('<a href="http://www.firstlink.edu">First Link</a>; '\
             '<a href="http://www.secondlink.edu">Second Link</a>; '\
             '<a href="http://www.thirdlink.edu">Third Link</a>')
        )
      end
    end

    context 'multiple links with a different number of text values' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345',
          url_text_a: ['A Link',
                       'Another Link']
        )
      end
      let(:options) do
        { value:    ['http://www.firstlink.edu',
                     'http://www.secondlink.edu',
                     'http://www.thirdlink.edu'],
          document: document }
      end

      it 'generates all the links using the default text value' do
        expect(helper.url_href_with_url_text_link(options)).to(
          eq('<a href="http://www.firstlink.edu">Online Access</a>; '\
             '<a href="http://www.secondlink.edu">Online Access</a>; '\
             '<a href="http://www.thirdlink.edu">Online Access</a>')
        )
      end
    end
  end

  describe '#cover_image' do
    context 'link to a Syndetics cover image with various options' do
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
        'http://www.syndetics.com/index.aspc?isbn=%s/%s&oclc=&client=trlnet'
      end

      it 'generates a link to a small cover image with defaults' do
        expected = URI(format(url_template, isbn, 'SC.GIF'))
        actual = URI(cover_image(document))
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end

      it 'generates a link to a small cover image with custom options' do
        expected = URI(format(url_template.gsub(/trlnet/, 'ncstateu'), isbn, 'SC.GIF'))
        actual = URI(cover_image(document, size: 'small', client: 'ncstateu'))
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end

      it 'generates a link to a medium cover image with an OCLC number' do
        expected = URI(format(url_template.gsub(/(oclc=)/, '\\1' + oclc), isbn, 'MC.GIF'))
        actual = URI(cover_image(oclc_document, size: :medium))
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end
    end
  end
end
