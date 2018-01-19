describe TrlnArgonHelper do
  describe '#institution_code_to_short_name' do
    context 'when code has a translation' do
      let(:options) { { value: %w[unc duke ncsu] } }

      it 'uses the translated value' do
        expect(helper.institution_code_to_short_name(options)).to eq('UNC, Duke, and NCSU')
      end
    end

    context 'when code does not have a translation' do
      let(:options) { { value: ['pie'] } }

      it 'uses the default value' do
        expect(helper.institution_code_to_short_name(options)).to eq('pie')
      end
    end
  end

  describe '#auto_link_values' do
    context 'when it has a single link' do
      let(:options) { { value: ['https://library.duke.edu'] } }

      it 'returns a single linked value' do
        expect(helper.auto_link_values(options)).to eq('<a href="https://library.duke.edu">' \
                                                       'https://library.duke.edu</a>')
      end
    end

    context 'when it has more than one link' do
      let(:options) { { value: ['https://library.duke.edu', 'https://www.lib.ncsu.edu'] } }

      it 'returns a single linked value' do
        expect(helper.auto_link_values(options)).to eq('<a href="https://library.duke.edu">' \
                                                       'https://library.duke.edu</a> and ' \
                                                       '<a href="https://www.lib.ncsu.edu">' \
                                                       'https://www.lib.ncsu.edu</a>')
      end
    end

    context 'when it has a link and then something that is not a link' do
      let(:options) { { value: ['https://library.duke.edu', 'Soup'] } }

      it 'returns a linked value and a non-linked value' do
        expect(helper.auto_link_values(options)).to eq('<a href="https://library.duke.edu">' \
                                                       'https://library.duke.edu</a> and Soup')
      end
    end
  end

  describe '#entry_name' do
    context 'when count is 1' do
      it 'does not pluralize the entry name' do
        expect(helper.entry_name(1)).to eq('result')
      end
    end

    context 'when count is more than 1' do
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
    context 'when the scope is BookmarksController' do
      before { allow(helper).to receive(:controller_name).and_return('bookmarks') }

      it 'uses the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('bookmarked')
      end
    end

    context 'when local filter is applied', verify_stubs: false do
      before do
        allow(helper).to receive(:controller_name).and_return('catalog')
        allow(helper).to receive(:local_filter_applied?).and_return(true)
      end

      it 'uses the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('UNC')
      end
    end

    context 'when local filter is not applied', verify_stubs: false do
      before do
        allow(helper).to receive(:controller_name).and_return('catalog')
        allow(helper).to receive(:local_filter_applied?).and_return(false)
      end

      it 'uses the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('TRLN')
      end
    end
  end

  describe '#location_filter_display' do
    context 'when all codes are mappable' do
      let(:hierarchy_value) { 'duke:dukedivy:dukedivyrees' }

      it 'translates the coded hierarchy to a human readable string' do
        expect(helper.location_filter_display(hierarchy_value)).to(
          eq('Duke, Divinity, Reserves')
        )
      end
    end

    context 'when some codes are not mappable' do
      let(:hierarchy_value) { 'duke:blah:foo' }

      it 'has codes in place of unmappable values' do
        expect(helper.location_filter_display(hierarchy_value)).to(
          eq('Duke, duke.facet.blah, duke.facet.foo')
        )
      end
    end
  end

  describe '#link_to_subject_segments' do
    let(:options) do
      { value:    ['Technology -- History -- Science',
                   'Galilei, Galileo, 1564-1642'] }
    end
    let(:context) { CatalogController.new }

    it 'generates links to a search for each segment' do
      allow(context).to receive(:local_filter_applied?).and_return(false)
      allow(context).to receive(:search_action_url).and_return('/catalog?begins_with=something')
      expect(context.helpers.link_to_subject_segments(options)).to(
        eq(['<a title="Technology" href="/catalog?begins_with=something">Technology</a>'\
            '<a title="Technology -- History" href="/catalog?begins_with=something">'\
            '<span class="sr-only">Technology</span> -- History</a>'\
            '<a title="Technology -- History -- Science" href="/catalog?begins_with=something">'\
            '<span class="sr-only">Technology -- History</span> -- Science</a>',
            '<a title="Galilei, Galileo, 1564-1642" href="/catalog?begins_with=something">'\
            'Galilei, Galileo, 1564-1642</a>'])
      )
    end
  end

  describe '#link_to_primary_url' do
    context 'url data includes text' do
      let(:url_hash) do
        { href: 'http://www.law.duke.edu/journals/lcp/',
          type: 'fulltext',
          text: 'Law and contemporary problems, v. 63, no. 1-2' }
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_primary_url(url_hash)).to(
          eq('<a class="link-type-fulltext" '\
             'href="http://www.law.duke.edu/journals/lcp/">'\
             'Law and contemporary problems, v. 63, no. 1-2</a>')
        )
      end
    end

    context 'url data does not include text' do
      let(:url_hash) do
        { href: 'http://www.law.duke.edu/journals/lcp/',
          type: 'fulltext',
          text: '' }
      end

      it 'creates a link using the default translation' do
        expect(helper.link_to_primary_url(url_hash)).to(
          eq('<a class="link-type-fulltext" '\
             'href="http://www.law.duke.edu/journals/lcp/">'\
             'Online Access</a>')
        )
      end
    end
  end

  describe '#link_to_secondary_urls' do
    let(:options) do
      { value: [{ href: 'http://www.law.duke.edu/journals/lcp/',
                  type: 'other',
                  text: 'Law and contemporary problems, v. 63, no. 1-2' },
                { href: 'http://www.law.duke.edu/journals/lcp/',
                  type: 'other',
                  text: '' }] }
    end

    it 'creates links to secondary urls' do
      expect(helper.link_to_secondary_urls(options)).to(
        eq('<a href="http://www.law.duke.edu/journals/lcp/">'\
           'Law and contemporary problems, v. 63, no. 1-2</a><br />'\
           '<a href="http://www.law.duke.edu/journals/lcp/">'\
           'http://www.law.duke.edu/journals/lcp/</a>')
      )
    end
  end

  describe '#imprint_main' do
    let(:document) do
      SolrDocument.new(
        id: 'UNCb1225829',
        imprint_main_a: ['{"type":"imprint",'\
                         '"label":"Fall/Winter 2002-",'\
                         '"value":"Savannah, GA : Dept. of Languages, Literature & Philosophy, '\
                         'Armstrong Atlantic State University"}'],
        imprint_multiple_a: ['{"type":"imprint",'\
                             '"value":"Raleigh, N.C. : Published by the editors in cooperation with '\
                             'the School of Liberal Arts at North Carolina State of the '\
                             'University of North Carolina, [1964-"}',
                             '{"type":"imprint",'\
                             '"label":"Spring 1978-winter 1995","value":"Charlotte, N.C. : English Dept., UNCC"}',
                             '{"type":"imprint","label":"Summer 1996-winter 1999",'\
                             '"value":"Charlotte, N.C. : Advancment Studies, CPCC"}',
                             '{"type":"imprint",'\
                             '"label":"Summer 2000-summer 2001",'\
                             '"value":"Charlotte, N.C. : English Dept., CPCC"}',
                             '{"type":"imprint",'\
                             '"label":"Fall/Winter 2002-",'\
                             '"value":"Savannah, GA : Dept. of Languages, Literature & Philosophy, '\
                             'Armstrong Atlantic State University"}']
      )
    end

    it 'generates an imprint_main for display' do
      expect(helper.imprint_main(document: document)).to(
        eq('<span class="imprint-label">Fall/Winter 2002-</span>: Savannah, GA : Dept. of Languages, '\
           'Literature & Philosophy, Armstrong Atlantic State University')
      )
    end

    it 'generates an imprint_multiple for display in other details' do
      expect(helper.imprint_multiple(document: document)).to(
        eq('Raleigh, N.C. : Published by the editors in cooperation with the School of Liberal Arts at '\
          'North Carolina State of the University of North Carolina, [1964-<br />'\
          '<span class="imprint-label">Spring 1978-winter 1995</span>: Charlotte, N.C. : English Dept., '\
          'UNCC<br /><span class="imprint-label">Summer 1996-winter 1999</span>'\
          ': Charlotte, N.C. : Advancment Studies, CPCC<br /><span class="imprint-label">'\
          'Summer 2000-summer 2001</span>: Charlotte, N.C. : English Dept., CPCC<br />'\
          '<span class="imprint-label">Fall/Winter 2002-</span>: Savannah, GA : Dept. of Languages, '\
          'Literature & Philosophy, Armstrong Atlantic State University')
      )
    end
  end

  describe '#add_icon_to_action_label' do
    let(:tool_with_label) do
      Blacklight::Configuration::ToolConfig.new(
        icon: 'glyphicon-download-alt',
        if: :render_ris_action?,
        modal: false,
        path: :ris_path
      )
    end
    let(:tool_without_label) do
      Blacklight::Configuration::ToolConfig.new(
        if: :render_ris_action?,
        modal: false,
        path: :ris_path
      )
    end

    before { allow(helper).to receive(:document_action_label).and_return('<li>Action Label</li>') }

    context 'the configuration provides an icon' do
      it 'adds an icon to the document action label' do
        expect(helper.add_icon_to_action_label(tool_with_label)).to eq(
          '<i class="glyphicon glyphicon-download-alt" aria-hidden="true"></i> <li>Action Label</li>'
        )
      end
    end
    context 'the configuration does not provide an icon' do
      it 'does not add an icon to the document action label' do
        expect(helper.add_icon_to_action_label(tool_without_label)).to eq('<li>Action Label</li>')
      end
    end
  end
end
