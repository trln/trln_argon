describe TrlnArgonHelper, type: :helper do
  ########################
  # TrlnArgonHelper
  ########################

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
      expect(helper.consortium_long_name).to eq('Triangle Research Libraries')
    end
  end

  describe '#location_filter_display' do
    context 'when all codes are mappable' do
      let(:hierarchy_value) { 'duke:dukedivy:dukedivyrees' }

      it 'translates the coded hierarchy to a human readable string' do
        expect(helper.location_filter_display(hierarchy_value)).to(
          eq('Duke > Divinity > Reserves')
        )
      end
    end

    context 'when some codes are not mappable' do
      let(:hierarchy_value) { 'duke:blah:foo' }

      it 'has codes in place of unmappable values' do
        expect(helper.location_filter_display(hierarchy_value)).to(
          eq('Duke > duke.facet.blah > duke.facet.foo')
        )
      end
    end
  end

  describe '#call_number_filter_display' do
    let(:hierarchy_value) do
      'L - Education|'\
      'LB5 - LB3640 Theory and practice of education|'\
      'LB2300 - LB2430 Higher education|'\
      'LB2326.4 - LB2330 Institutions of higher education'
    end

    it 'translates the hierarchy delimiter into a string for display' do
      expect(helper.call_number_filter_display(hierarchy_value)).to(
        eq('L - Education > '\
      'LB5 - LB3640 Theory and practice of education > '\
      'LB2300 - LB2430 Higher education > '\
      'LB2326.4 - LB2330 Institutions of higher education')
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

  # ########################
  # # AdvancedSearchHelper
  # ########################

  describe 'advanced_search_page_class' do
    it 'returns the advanced search page HTML class attribute values' do
      expect(helper.advanced_search_page_class).to(
        eq('advanced-search-form col-sm-12')
      )
    end

    it 'returns the advanced search form HTML class attribute values' do
      expect(helper.advanced_search_form_class).to(
        eq('col-md-8')
      )
    end

    it 'returns the advanced search help HTML class attribute values' do
      expect(helper.advanced_search_help_class).to(
        eq('col-md-4')
      )
    end
  end

  ########################
  # ItemsSectionHelper
  ########################

  describe '#items_spacer_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.items_spacer_class).to(
        eq('items-spacer col-md-12')
      )
    end
  end

  describe '#items_wrapper_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.items_wrapper_class).to(
        eq('items-wrapper items-section-index col-md-12')
      )
    end
  end

  describe '#item_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.item_class).to(
        eq('item col-md-12')
      )
    end
  end

  describe '#availability_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.availability_class).to(
        eq('available col-md-5')
      )
    end
  end

  describe '#location_header_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.location_header_class).to(
        eq('location-header col-md-12')
      )
    end
  end

  describe '#institution_location_header_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.institution_location_header_class).to(
        eq('institution location-header col-md-12')
      )
    end
  end

  describe '#location_narrow_group_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.location_narrow_group_class).to(
        eq('location-narrow-group col-md-12')
      )
    end
  end

  describe '#holdings_summary_wrapper_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.holdings_summary_wrapper_class).to(
        eq('col-sm-12 summary-wrapper')
      )
    end
  end

  describe '#holdings_note_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.holdings_note_class).to(
        eq('holding-note col-md-12')
      )
    end
  end

  describe '#url_note_wrapper_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.url_note_wrapper_class).to(
        eq('url-note-wrapper')
      )
    end
  end

  describe '#item_availability_display' do
    context 'item is available' do
      let(:item) { { 'status' => 'Available' } }

      it 'returns the HTML class attribute values' do
        expect(helper.item_availability_display(item)).to(
          eq('item-available')
        )
      end
    end

    context 'item is NOT available' do
      let(:item) { { 'status' => 'Checked Out' } }

      it 'returns the HTML class attribute values' do
        expect(helper.item_availability_display(item)).to(
          eq('item-not-available')
        )
      end
    end

    context 'item is NOT available' do
      let(:item) { { 'status' => 'Library Use Only' } }

      it 'returns the HTML class attribute values' do
        expect(helper.item_availability_display(item)).to(
          eq('item-library-only')
        )
      end
    end

    context 'item is who knows what' do
      let(:item) { { 'status' => 'Locked up somewhere safe' } }

      it 'returns the HTML class attribute values' do
        expect(helper.item_availability_display(item)).to(
          eq('item-availability-misc')
        )
      end
    end
  end

  describe '#binary_availability_span_class' do
    context 'record has at least one item available' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345',
          available_a: 'Available'
        )
      end

      it 'returns the HTML class attribute values' do
        expect(helper.binary_availability_span_class(document: document)).to(
          eq('item-available')
        )
      end
    end

    context 'record does not have any items available' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345'
        )
      end

      it 'returns the HTML class attribute values' do
        expect(helper.binary_availability_span_class(document: document)).to(
          eq('item-not-available')
        )
      end
    end
  end

  describe '#call_number_wrapper_class' do
    context 'show action' do
      it 'returns the HTML class attribute values' do
        expect(helper.call_number_wrapper_class(action: 'show')).to(
          eq('col-md-5 col-sm-12 call-number-wrapper')
        )
      end
    end

    context 'other action' do
      it 'returns the HTML class attribute values' do
        expect(helper.call_number_wrapper_class).to(
          eq('col-md-5 col-sm-12 call-number-wrapper')
        )
      end
    end
  end

  describe '#status_wrapper_class' do
    context 'show action' do
      it 'returns the HTML class attribute values' do
        expect(helper.status_wrapper_class(action: 'show')).to(
          eq('col-md-7 col-sm-12')
        )
      end
    end
    context 'other action' do
      it 'returns the HTML class attribute values' do
        expect(helper.status_wrapper_class).to(
          eq('col-md-7 col-sm-12')
        )
      end
    end
  end

  describe '#item_note_wrapper_class' do
    context 'show action and long items' do
      it 'returns the HTML class attribute values' do
        expect(helper.item_note_wrapper_class(action: 'show', item_length: 130)).to(
          eq('col-md-12')
        )
      end
    end
    context 'show action short item' do
      it 'returns the HTML class attribute values' do
        expect(helper.item_note_wrapper_class(action: 'show', item_length: 110)).to(
          eq('col-md-12')
        )
      end
    end
    context 'all other cases' do
      it 'returns the HTML class attribute values' do
        expect(helper.item_note_wrapper_class).to(
          eq('col-md-12')
        )
      end
    end
  end

  describe '#display_holdings_well?' do
    context 'missing everything you might want to display' do
      let(:document) do
        SolrDocument.new(id: 'DUKE12345')
      end

      it 'returns false' do
        expect(helper.display_holdings_well?(document: document)).to be false
      end
    end

    context 'has holdings' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345',
          holdings_a: ['{"loc_b":"LSC","loc_n":"PSK","call_no":"972.91064 V141C"}'],
          items_a: ['{"loc_b":"LSC","loc_n":"PSK","cn_scheme":"1","call_no":"972.91064 V141C",'\
                    '"copy_no":"c.1","type":"BOOK","item_id":"D90460098-","status":"Available"}']
        )
      end

      it 'returns false' do
        expect(helper.display_holdings_well?(document: document)).to be true
      end
    end

    context 'no items but has a holdings id' do
      let(:document) do
        SolrDocument.new(
          YAML.safe_load(file_fixture('documents/UNCb3922162.yml').read)
        )
      end

      it 'returns true' do
        expect(helper.display_holdings_well?(document: document)).to be true
      end
    end
  end

  describe '#online_only_items?' do
    context 'location codes are online' do
      let(:holdings) do
        YAML.safe_load(file_fixture('holdings/online_only_holdings.yml').read)
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns true' do
        expect(online_only_items?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be true
        )
      end
    end

    context 'location codes are physical' do
      let(:holdings) do
        YAML.safe_load(file_fixture('holdings/items_with_holdings_no_summary.yml').read)
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns false' do
        expect(online_only_items?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be false
        )
      end
    end
  end

  describe '#no_items_no_holdings?' do
    context 'location has no items and no holdings' do
      let(:holdings) do
        YAML.safe_load(file_fixture('holdings/no_items_no_holdings.yml').read)
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns true' do
        expect(no_items_no_holdings?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be true
        )
      end
    end

    context 'location has items' do
      let(:holdings) do
        YAML.safe_load(file_fixture('holdings/items_with_holdings_no_summary.yml').read)
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns false' do
        expect(no_items_no_holdings?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be false
        )
      end
    end
  end

  describe 'no_items_holdings_no_summary?' do
    context 'location has no items and holdings without summaries' do
      let(:holdings) do
        YAML.safe_load(file_fixture('holdings/no_items_with_holdings_no_summary.yml').read)
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns true' do
        expect(no_items_holdings_no_summary?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be true
        )
      end
    end

    context 'location has no items but has holdings with summaries' do
      let(:holdings) do
        YAML.safe_load(file_fixture('holdings/no_items_with_holdings_has_summary.yml').read)
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns false' do
        expect(no_items_holdings_no_summary?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be false
        )
      end
    end

    context 'location has no items but has holdings with holdings_id' do
      let(:holdings) do
        YAML.safe_load(file_fixture('holdings/no_items_with_holdings_has_holdings_id.yml').read)
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns false' do
        expect(no_items_holdings_no_summary?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be false
        )
      end
    end
  end

  describe '#display_items?' do
    context 'only online holdings keys' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345',
          holdings_a: ['{"loc_b":"DUKIR","loc_n":"PSK","call_no":"972.91064 V141C"}'],
          items_a: ['{"loc_b":"DUKIR","loc_n":"PSK","cn_scheme":"1","call_no":"972.91064 V141C",'\
                    '"copy_no":"c.1","type":"BOOK","item_id":"D90460098-","status":"Available"}']
        )
      end

      it 'returns false' do
        expect(helper.display_items?(document: document)).to be false
      end
    end

    context 'more than just online holdings keys' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE12345',
          holdings_a: ['{"loc_b":"LSC","loc_n":"PSK","call_no":"972.91064 V141C"}'],
          items_a: ['{"loc_b":"LSC","loc_n":"PSK","cn_scheme":"1","call_no":"972.91064 V141C",'\
                    '"copy_no":"c.1","type":"BOOK","item_id":"D90460098-","status":"Available"}']
        )
      end

      it 'returns true' do
        expect(helper.display_items?(document: document)).to be true
      end
    end

    context 'document has no items but has holdings with holdings_id' do
      let(:document) do
        SolrDocument.new(
          YAML.safe_load(file_fixture('documents/UNCb3922162.yml').read)
        )
      end

      it 'returns true' do
        expect(helper.display_items?(document: document)).to be true
      end
    end
  end

  describe '#suppress_item?' do
    context 'no item data' do
      let(:item_data) { {} }
      let(:loc_b) { 'PERK' }

      it 'returns true' do
        expect(helper.suppress_item?(item_data: item_data, loc_b: loc_b)).to be true
      end
    end

    context 'online location' do
      let(:item_data) { { 'items' => ['an item'] } }
      let(:loc_b) { 'DUKIR' }

      it 'returns true' do
        expect(helper.suppress_item?(item_data: item_data, loc_b: loc_b)).to be true
      end
    end

    context 'no items but has holdings_id' do
      let(:item_data) { { 'items' => [], 'holdings' => [{ 'holdings_id' => '123456789' }] } }
      let(:loc_b) { 'dddr' }

      it 'returns false' do
        expect(helper.suppress_item?(item_data: item_data, loc_b: loc_b)).to be false
      end
    end

    context 'displayable item' do
      let(:item_data) { { 'items' => ['an item'] } }
      let(:loc_b) { 'PERK' }

      it 'returns false' do
        expect(helper.suppress_item?(item_data: item_data, loc_b: loc_b)).to be false
      end
    end
  end

  describe '#display_holdings_summaries?' do
    context 'holdings have summaries' do
      let(:options) do
        { 'holdings' => [{ 'summary' => '1659 to 1805' }] }
      end

      it 'returns true' do
        expect(helper.display_holdings_summaries?(options)).to be true
      end
    end

    context 'holdings have notes' do
      let(:options) do
        { 'holdings' => [{ 'notes' => ['Shelved with other things.'] }] }
      end

      it 'returns true' do
        expect(helper.display_holdings_summaries?(options)).to be true
      end
    end

    context 'holdings have holdings_id' do
      let(:options) do
        { 'holdings' => [{ 'holdings_id' => '123456789' }] }
      end

      it 'returns true' do
        expect(helper.display_holdings_summaries?(options)).to be true
      end
    end

    context 'holdings do not have summaries or notes' do
      let(:options) do
        { 'holdings' => [{ 'call_no' => 'AAA111 .B3 1999' }] }
      end

      it 'returns false' do
        expect(helper.display_holdings_summaries?(options)).to be false
      end
    end
  end

  describe '#display_holdings_summary?' do
    context 'holding has a summary' do
      let(:options) do
        { 'summary' => '1659 to 1805' }
      end

      it 'returns true' do
        expect(helper.display_holdings_summary?(options)).to be true
      end
    end

    context 'holding has notes' do
      let(:options) do
        { 'notes' => ['Shelved with bees.'] }
      end

      it 'returns true' do
        expect(helper.display_holdings_summary?(options)).to be true
      end
    end

    context 'holding has holdings_id' do
      let(:options) do
        { 'holdings_id' => '123456' }
      end

      it 'returns true' do
        expect(helper.display_holdings_summary?(options)).to be true
      end
    end

    context 'holding does not have summary or notes' do
      let(:options) do
        { 'call_no' => 'AAA111 .B3 1999' }
      end

      it 'returns true' do
        expect(helper.display_holdings_summary?(options)).to be false
      end
    end
  end

  describe 'add_spacer_above_items_section?' do
    context 'record has items and links' do
      let(:document) do
        SolrDocument.new(YAML.safe_load(file_fixture('documents/DUKE004093564.yml').read))
      end

      it 'returns true' do
        expect(add_spacer_above_items_section?(document: document)).to be true
      end
    end

    context 'record has items but no links' do
      let(:document) do
        SolrDocument.new(YAML.safe_load(file_fixture('documents/UNCb1852218.yml').read))
      end

      it 'returns false' do
        expect(add_spacer_above_items_section?(document: document)).to be false
      end
    end

    context 'record has links but no items' do
      let(:document) do
        SolrDocument.new(YAML.safe_load(file_fixture('documents/DUKE006162724.yml').read))
      end

      it 'returns false' do
        expect(add_spacer_above_items_section?(document: document)).to be false
      end
    end
  end

  ########################
  # LinkHelper
  ########################

  describe '#link_to_secondary_urls' do
    let(:options) do
      { value: [{ href: 'http://www.law.duke.edu/journals/lcp/',
                  type: 'other',
                  text: 'Law and contemporary problems, v. 63, no. 1-2' },
                { href: 'http://www.law.duke.edu/journals/lcp/',
                  type: 'other',
                  text: '' },
                { href: 'http://link.to.toc.or.something.',
                  type: 'related',
                  note: 'Table of contents.' }] }
    end

    it 'creates links to secondary urls' do
      expect(helper.link_to_secondary_urls(options)).to(
        eq('<a href="http://www.law.duke.edu/journals/lcp/">'\
           'Law and contemporary problems, v. 63, no. 1-2</a><br />'\
           '<a href="http://www.law.duke.edu/journals/lcp/">'\
           'http://www.law.duke.edu/journals/lcp/</a><br />'\
           '<a href="http://link.to.toc.or.something.">Table of contents.</a>')
      )
    end
  end

  describe '#link_to_fulltext_url' do
    context 'url data includes text' do
      let(:url_hash) do
        { href: 'http://www.law.duke.edu/journals/lcp/',
          type: 'fulltext',
          text: 'Law and contemporary problems, v. 63, no. 1-2' }
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_fulltext_url(url_hash)).to(
          eq('<a class="link-type-fulltext link-restricted-unc" '\
             'target="_blank" '\
             'href="http://www.law.duke.edu/journals/lcp/">'\
             '<i class="fa fa-external-link" aria-hidden="true"></i>'\
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
        expect(helper.link_to_fulltext_url(url_hash)).to(
          eq('<a class="link-type-fulltext link-restricted-unc" '\
             'target="_blank" '\
             'href="http://www.law.duke.edu/journals/lcp/">'\
             '<i class="fa fa-external-link" aria-hidden="true"></i>'\
             'Online Access</a>')
        )
      end
    end
  end

  describe '#link_to_expanded_fulltext_url' do
    let(:inst) { 'unc' }

    context 'url data includes text' do
      let(:url_hash) do
        { href: 'http://www.law.duke.edu/journals/lcp/',
          type: 'fulltext',
          text: 'Law and contemporary problems, v. 63, no. 1-2' }
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_expanded_fulltext_url(url_hash, inst)).to(
          eq('<a class="link-type-fulltext link-restricted-unc" '\
             'target="_blank" '\
             'href="http://www.law.duke.edu/journals/lcp/">'\
             '<i class="fa fa-external-link" aria-hidden="true"></i>'\
             'Online Access (UNC Only)</a>')
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
        expect(helper.link_to_expanded_fulltext_url(url_hash, inst)).to(
          eq('<a class="link-type-fulltext link-restricted-unc" '\
             'target="_blank" '\
             'href="http://www.law.duke.edu/journals/lcp/">'\
             '<i class="fa fa-external-link" aria-hidden="true"></i>'\
             'Online Access (UNC Only)</a>')
        )
      end
    end
  end

  describe '#link_to_finding_aid' do
    context 'url data includes text' do
      let(:url_hash) do
        { href: 'https://library.duke.edu/rubenstein/findingaids/ualacyc/',
          type: 'findingaid',
          text: 'Collection Guide for Collection' }
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_finding_aid(url_hash)).to(
          eq('<a class="link-type-findingaid" '\
             'target="_blank" '\
             'href="https://library.duke.edu/rubenstein/findingaids/ualacyc/">'\
             '<i class="fa fa-archive" aria-hidden="true"></i>'\
             'Collection Guide for Collection</a>')
        )
      end
    end

    context 'url data does not include text' do
      let(:url_hash) do
        { href: 'https://library.duke.edu/rubenstein/findingaids/ualacyc/',
          type: 'findingaid',
          text: '' }
      end

      it 'creates a link using the default translation' do
        expect(helper.link_to_finding_aid(url_hash)).to(
          eq('<a class="link-type-findingaid" '\
             'target="_blank" '\
             'href="https://library.duke.edu/rubenstein/findingaids/ualacyc/">'\
             '<i class="fa fa-archive" aria-hidden="true"></i>'\
             'Finding Aid</a>')
        )
      end
    end
  end

  describe '#link_to_open_access' do
    context 'url data includes text' do
      let(:url_hash) do
        { href: 'https://hdl.handle.net/2027/coo1.ark/13960/t23b7806k',
          type: 'fulltext',
          text: '"Come ye apart", daily exercises in prayer and devotion' }
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_open_access(url_hash)).to(
          eq('<a class="link-type-fulltext link-open-access" '\
             'target="_blank" '\
             'href="https://hdl.handle.net/2027/coo1.ark/13960/t23b7806k">'\
             '<i class="fa fa-external-link" aria-hidden="true"></i>'\
             '&quot;Come ye apart&quot;, daily exercises in prayer and devotion</a>')
        )
      end
    end

    context 'url data does not include text' do
      let(:url_hash) do
        { href: 'https://hdl.handle.net/2027/coo1.ark/13960/t23b7806k',
          type: 'fulltext',
          text: '' }
      end

      it 'creates a link using the default translation' do
        expect(helper.link_to_open_access(url_hash)).to(
          eq('<a class="link-type-fulltext link-open-access" '\
             'target="_blank" '\
             'href="https://hdl.handle.net/2027/coo1.ark/13960/t23b7806k">'\
             '<i class="fa fa-external-link" aria-hidden="true"></i>'\
             'Open Access</a>')
        )
      end
    end
  end

  describe '#expanded_link_to_open_access' do
    let(:url_hash) do
      { href: 'https://an/open/access/link', type: 'fulltext' }
    end

    it 'creates a link using the default translation' do
      expect(helper.expanded_link_to_open_access(url_hash)).to(
        eq('<a class="link-type-fulltext link-open-access" '\
          'target="_blank" href="https://an/open/access/link">'\
          '<i class="fa fa-external-link" aria-hidden="true"></i>'\
          'Open Access</a>')
      )
    end
  end

  ########################
  # NamesHelper
  ########################

  describe '#names_display' do
    let(:context) { CatalogController.new }

    let(:options) do
      { value: [{ name: 'Nabokov, Vladimir Vladimirovich, 1899-1977', rel: 'author' },
                { name: 'Appel, Alfred', rel: '' }] }
    end

    before do
      allow(context).to receive(:search_action_url).and_return('/catalog?search=something')
    end

    it 'creates a display value with links from the supplied names data' do
      expect(context.helpers.names_display(options)).to eq(
        '<li><a href="/catalog?search=something">Nabokov, Vladimir Vladimirovich, 1899-1977</a>, author</li>'\
        '<li><a href="/catalog?search=something">Appel, Alfred</a></li>'
      )
    end
  end

  ########################
  # ShowViewHelper
  ########################

  describe '#show_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_class).to(
        eq('col-md-12 show-document')
      )
    end
  end

  describe '#show_main_content_heading_partials_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_main_content_heading_partials_class).to(
        eq('col-md-12')
      )
    end
  end

  describe '#show_main_content_partials_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_main_content_partials_class).to(
        eq('col-md-10')
      )
    end
  end

  describe '#show_tools_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_tools_class).to(
        eq('col-md-12')
      )
    end
  end

  describe '#show_sub_header_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_sub_header_class).to be_nil
    end
  end

  describe '#show_thumbnail_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_thumbnail_class).to(
        eq('blacklight thumbnail')
      )
    end
  end

  describe '#show_other_details_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_other_details_class).to(
        eq('full-record-section')
      )
    end
  end

  describe '#show_authors_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_authors_class).to(
        eq('full-record-section')
      )
    end
  end

  describe '#show_items_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_items_class).to(
        eq('full-record-section')
      )
    end
  end

  describe '#show_enhanced_data_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_enhanced_data_class).to(be_nil)
    end
  end

  describe '#show_enhanced_data_summary_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_enhanced_data_summary_class).to(
        eq('full-record-section')
      )
    end
  end

  describe '#show_enhanced_data_toc_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_enhanced_data_toc_class).to(
        eq('full-record-section')
      )
    end
  end

  describe '#show_enhanced_data_sample_chapter_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_enhanced_data_sample_chapter_class).to(
        eq('full-record-section')
      )
    end
  end

  describe '#show_included_works_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_included_works_class).to(
        eq('full-record-section')
      )
    end
  end

  describe '#show_subjects_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_subjects_class).to(
        eq('full-record-section')
      )
    end
  end

  describe '#show_related_works_class' do
    it 'returns the HTML class attribute values' do
      expect(helper.show_related_works_class).to(
        eq('full-record-section')
      )
    end
  end

  ########################
  # SubjectsHelper
  ########################

  describe '#link_to_subject_segments' do
    let(:options) do
      { value:    ['Technology -- History -- Science',
                   'Galilei, Galileo, 1564-1642'] }
    end
    let(:context) { CatalogController.new }

    it 'generates links to a search for each segment' do
      allow(context).to receive(:search_action_url).and_return('/catalog?search_field=subject&q=something')
      expect(context.helpers.link_to_subject_segments(options)).to(
        eq(['<a class="progressive-link" href="/catalog?search_field=subject&amp;q=something">Technology</a>'\
            '<a class="progressive-link" href="/catalog?search_field=subject&amp;q=something">'\
            '<span class="sr-only">Technology</span> -- History</a>'\
            '<a class="progressive-link" '\
            'href="/catalog?search_field=subject&amp;q=something">'\
            '<span class="sr-only">Technology -- History</span> -- Science</a>',
            '<a class="progressive-link" href="/catalog?search_field=subject&amp;q=something">'\
            'Galilei, Galileo, 1564-1642</a>'])
      )
    end
  end

  ########################
  # WorkEntryHelper
  ########################

  describe '#work_entry_display' do
    let(:context) { CatalogController.new }

    let(:options) do
      { value: [{ label: '',
                  author: 'Author',
                  title: %w['One Two Three Four],
                  title_variation: '',
                  details: '',
                  isbn: [],
                  issn: '',
                  title_linking:
                    [{ params:
                       { author: 'Author', title: 'One' },
                       display_segments: %w[Author One] },
                     { params:
                       { author: 'Author',
                         title: 'One Two' },
                       display_segments:
                         %w[Author One Two] },
                     { params:
                       { author: 'Author',
                         title: 'One Two Three' },
                       display_segments:
                         %w[Author One Two Three] },
                     { params:
                       { author: 'Author',
                         title: 'One Two Three Four' },
                       display_segments:
                         %w[Author One Two Three Four] }] }] }
    end

    before do
      allow(context).to receive(:search_action_url).and_return('/catalog?search=something')
    end

    # rubocop:disable ExampleLength
    it 'creates a display value with links from the supplied work entry data' do
      expect(context.helpers.work_entry_display(options)).to eq(
        '<dd>'\
        '<span class="progressive-link-wrapper">'\
        '<a class="progressive-link" href="/catalog?search=something">Author</a>'\
        '<a class="progressive-link" href="/catalog?search=something">'\
        '<span class="sr-only">Author One</span> One'\
        '</a>'\
        '<a class="progressive-link" '\
        'href="/catalog?search=something">'\
        '<span class="sr-only">Author One Two</span> Two'\
        '</a>'\
        '<a class="progressive-link" '\
        'href="/catalog?search=something">'\
        '<span class="sr-only">Author One Two Three</span> Three'\
        '</a>'\
        '<a class="progressive-link" '\
        'href="/catalog?search=something">'\
        '<span class="sr-only">Author One Two Three Four</span> Four'\
        '</a>'\
        '</span>'\
        '</dd>'
      )
    end

    it 'creates a display value with links from the supplied work entry data that are formatted as an unordered list' do
      expect(context.helpers.included_works_display(options)).to eq(
        '<li>'\
        '<span class="progressive-link-wrapper">'\
        '<a class="progressive-link" href="/catalog?search=something">Author</a>'\
        '<a class="progressive-link" href="/catalog?search=something">'\
        '<span class="sr-only">Author One</span> One'\
        '</a>'\
        '<a class="progressive-link" '\
        'href="/catalog?search=something">'\
        '<span class="sr-only">Author One Two</span> Two'\
        '</a>'\
        '<a class="progressive-link" '\
        'href="/catalog?search=something">'\
        '<span class="sr-only">Author One Two Three</span> Three'\
        '</a>'\
        '<a class="progressive-link" '\
        'href="/catalog?search=something">'\
        '<span class="sr-only">Author One Two Three Four</span> Four'\
        '</a>'\
        '</span>'\
        '</li>'
      )
    end
  end
end
