describe TrlnArgon::SolrDocument do
  class SolrDocumentTestClass
    include Blacklight::Solr::Document
    include TrlnArgon::SolrDocument
  end

  ########################
  # SolrDocument
  ########################

  describe 'availability' do
    context 'when availability is set on the document' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'NCSU12345',
          available_a: 'Available'
        )
      end

      it 'returns the correct availability status' do
        expect(solr_document.availability).to eq 'Available'
      end
    end

    context 'when availability is not set on the document' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'NCSU12345'
        )
      end

      it 'returns the correct availability status' do
        expect(solr_document.availability).to eq 'Not Available'
      end
    end
  end

  describe 'isbn_with_qualifying_info' do
    let(:isbn_document) do
      SolrDocumentTestClass.new(
        id: 'UNCb6060605',
        isbn_number_a: %w[9780891125303 0891125302 9780891125310 0891125310],
        isbn_qualifying_info_a: ['(cloth)', '(cloth)', '(pbk.)', '(pbk.)']
      )
    end

    it 'combines isbn and qualifying info field arrays into a single array of joined values' do
      expect(isbn_document.isbn_with_qualifying_info).to eq(
        ['9780891125303 (cloth)', '0891125302 (cloth)', '9780891125310 (pbk.)', '0891125310 (pbk.)']
      )
    end
  end

  describe 'names' do
    let(:names_document) do
      SolrDocumentTestClass.new(
        id: 'DUKE000007907',
        names_a: ['{"name":"Nabokov, Vladimir Vladimirovich, 1899-1977", "rel":"author"}',
                  '{"name":"Appel, Alfred"}']
      )
    end

    it 'deserializes the names string' do
      expect(names_document.names).to eq(
        [{ name: 'Nabokov, Vladimir Vladimirovich, 1899-1977', rel: 'author' },
         { name: 'Appel, Alfred', rel: '' }]
      )
    end
  end

  describe '#record_association' do
    context 'it is a local record' do
      let(:local_document) do
        SolrDocumentTestClass.new(
          id: 'UNC002981535',
          owner_a: ['unc'],
          institution_a: ['unc']
        )
      end

      it 'returns the association code for the record' do
        expect(local_document.record_association).to eq('unc')
      end
    end

    context 'it is a shared record' do
      let(:local_document) do
        SolrDocumentTestClass.new(
          id: 'UNC002981535',
          owner_a: ['unc'],
          institution_a: %w[unc duke nccu ncsu']
        )
      end

      it 'returns the association code for the record' do
        expect(local_document.record_association).to eq('trln')
      end
    end
  end

  describe '#record_owner' do
    let(:owned_document) do
      SolrDocumentTestClass.new(
        id: 'UNC002981535',
        owner_a: ['unc']
      )
    end

    it 'returns the code for the owner of the record' do
      expect(owned_document.record_owner).to eq('unc')
    end
  end

  describe '#title_and_responsibility' do
    let(:solr_document) do
      SolrDocumentTestClass.new(
        id: 'UNC002981535',
        title_main: 'Basic child psychiatry',
        statement_of_responsibility_a: ['Philip Barker.']
      )
    end

    it 'returns a title with the statement of responsibility' do
      expect(solr_document.title_and_responsibility).to eq('Basic child psychiatry / Philip Barker.')
    end
  end

  describe 'issn' do
    context 'when there is a single ISSN' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE12345',
          issn_linking_a: ['1111-2222']
        )
      end

      it 'returns the ISSN' do
        expect(solr_document.issn).to eq(['1111-2222'])
      end
    end

    context 'when there are multiple ISSNs and some duplicates' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE12345',
          issn_linking_a: ['1111-2222'],
          issn_primary_a: ['3333-4444', '1111-2222']
        )
      end

      it 'returns the ISSNs without duplicates' do
        expect(solr_document.issn).to eq(['3333-4444', '1111-2222'])
      end
    end

    context 'when there are no ISSNs' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE12345'
        )
      end

      it 'returns an empty array' do
        expect(solr_document.issn).to eq([])
      end
    end
  end

  describe 'get the UPC' do
    context 'when there is a single value' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE12345',
          upc_a: ['UPC: 123456789098']
        )
      end

      it 'returns the UPC' do
        expect(solr_document.upc).to eq(['123456789098'])
      end
    end

    context 'when there are multiple values' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE12345',
          upc_a: ['UPC: 123456789098', 'UPC: 987654321012']
        )
      end

      it 'returns the all UPCs' do
        expect(solr_document.upc).to eq(%w[123456789098 987654321012])
      end
    end
  end

  context 'when there are no values' do
    let(:solr_document) do
      SolrDocumentTestClass.new(
        id: 'DUKE12345'
      )
    end

    it 'returns empty array' do
      expect(solr_document.upc).to eq([])
    end
  end

  describe '#edition' do
    let(:edition_doc) do
      SolrDocumentTestClass.new(
        id: 'UNC002981535',
        edition_a: ['︠I︡Ubileĭnoe izd.', 'Юбилейное изд.']
      )
    end

    it 'returns the imprint with vernacular for display' do
      expect(edition_doc.edition).to eq('Юбилейное изд. / ︠I︡Ubileĭnoe izd.')
    end
  end

  describe '#genre_headings' do
    let(:headings_doc) do
      SolrDocumentTestClass.new(
        id: 'UNC002981535',
        genre_headings_a: ['Something'],
        genre_headings_vern: ['دمنتري فلمس']
      )
    end

    it 'returns the genre_headings with vernacular for display' do
      expect(headings_doc.genre_headings).to eq(['Something', 'دمنتري فلمس'])
    end
  end

  describe '#subject_headings' do
    let(:headings_doc) do
      SolrDocumentTestClass.new(
        id: 'UNC002981535',
        subject_headings_a: ['Something'],
        subject_headings_vern: ['دمنتري فلمس']
      )
    end

    it 'returns the subject_headings with vernacular for display' do
      expect(headings_doc.subject_headings).to eq(['Something', 'دمنتري فلمس'])
    end
  end

  ########################
  # URL
  ########################

  describe 'url' do
    context 'field contains multiple complete url data' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE12345',
          url_a: ['{"href":"http://www.law.duke.edu/journals/lcp/",'\
                  '"type":"other",'\
                  '"text":"Law and contemporary problems, v. 63, no. 1-2"}',
                  '{"href":"http://www.law.duke.edu/journals/lcp/",'\
                  '"type":"other",'\
                  '"text":"Law and contemporary problems, v. 63, no. 1-2"}',
                  '{"href":"{proxyPrefix}http://www.law.duke.edu/journals/lcp/",'\
                  '"type":"other",'\
                  '"text":"Law and contemporary problems, v. 63, no. 1-2"}']
        )
      end

      it 'deserializes each of the url entries and maps any templated URL segments' do
        expect(solr_document.urls).to(
          eq([{ href: 'http://www.law.duke.edu/journals/lcp/',
                type: 'other',
                text: 'Law and contemporary problems, v. 63, no. 1-2' },
              { href: 'http://www.law.duke.edu/journals/lcp/',
                type: 'other',
                text: 'Law and contemporary problems, v. 63, no. 1-2' },
              { href: '{proxyPrefix}http://www.law.duke.edu/journals/lcp/',
                type: 'other',
                text: 'Law and contemporary problems, v. 63, no. 1-2' }])
        )
      end
    end

    context 'field contains incomplete url data' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE12345',
          url_a: ['{"href":"http://purl.access.gpo.gov/GPO/LPS606","type":"fulltext"}']
        )
      end

      it 'deserializes each of the url entries and sets the missing keys' do
        expect(solr_document.urls).to(
          eq([{ href: 'http://purl.access.gpo.gov/GPO/LPS606', type: 'fulltext', text: '' }])
        )
      end
    end

    context 'field contains url note' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'NCSU1234567',
          url_a: ['{"href":"http://purl.access.gpo.gov/GPO/LPS606","type":"fulltext",'\
                  '"note":"This is an 856$3 note."}']
        )
      end

      it 'deserializes the url entry and includes the note.' do
        expect(solr_document.urls).to(
          eq([{ href: 'http://purl.access.gpo.gov/GPO/LPS606', type: 'fulltext',
                text: '', note: 'This is an 856$3 note.' }])
        )
      end
    end

    context 'field contains some values not parsable as JSON' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE12345',
          url_a: ['a', nil, '{"href":"http://purl.access.gpo.gov/GPO/LPS606","type":"fulltext"}']
        )
      end

      it 'deserializes each of the parsable URL entries and rejects unparsable values' do
        expect(solr_document.urls).to(
          eq([{ href: 'http://purl.access.gpo.gov/GPO/LPS606', type: 'fulltext', text: '' }])
        )
      end
    end
  end

  describe 'fulltext_urls' do
    let(:solr_document) do
      SolrDocumentTestClass.new(
        id: 'DUKE12345',
        url_a: ['{"href":"http://purl.access.gpo.gov/GPO/LPS606","type":"fulltext"}',
                '{"href":"http://some/open/access/thinkg","type":"fulltext", "restricted":"false"}']
      )
    end

    it 'deserializes and selects the restricted fulltext URLs' do
      expect(solr_document.fulltext_urls).to(
        eq([{ href: 'http://purl.access.gpo.gov/GPO/LPS606', type: 'fulltext', text: '' }])
      )
    end
  end

  describe 'open_access_urls' do
    let(:solr_document) do
      SolrDocumentTestClass.new(
        id: 'DUKE12345',
        url_a: ['{"href":"http://purl.access.gpo.gov/GPO/LPS606","type":"fulltext"}',
                '{"href":"http://some/open/access/thing","type":"fulltext", "restricted":"false"}']
      )
    end

    it 'deserializes and selects the restricted fulltext URLs' do
      expect(solr_document.open_access_urls).to(
        eq([{ href: 'http://some/open/access/thing', type: 'fulltext', text: '', restricted: 'false' }])
      )
    end
  end

  describe 'shared_fulltext_urls' do
    let(:solr_document) do
      SolrDocumentTestClass.new(
        id: 'DUKE12345',
        url_a: ['{"href":"{+proxyPrefix}http://www.law.duke.edu/journals/lcp/",'\
                '"type":"fulltext",'\
                '"text":"Law and contemporary problems, v. 63, no. 1-2"}'],
        institution_a: %w[duke unc]
      )
    end

    it 'returns the proxied link for the the local institution' do
      expect(solr_document.shared_fulltext_urls).to(
        eq([{ href: 'http://libproxy.lib.unc.edu/login?url=http://www.law.duke.edu/journals/lcp/',
              type: 'fulltext',
              text: 'Law and contemporary problems, v. 63, no. 1-2' }])
      )
    end
  end

  describe 'expanded_shared_fulltext_urls' do
    let(:solr_document) do
      SolrDocumentTestClass.new(
        id: 'DUKE12345',
        url_a: ['{"href":"{+proxyPrefix}http://www.law.duke.edu/journals/lcp/",'\
                '"type":"fulltext",'\
                '"text":"Law and contemporary problems, v. 63, no. 1-2"}'],
        institution_a: %w[duke unc]
      )
    end

    it 'returns the proxied links for each institution that has access' do
      expect(solr_document.expanded_shared_fulltext_urls).to(
        eq('duke' => [{ href: 'http://proxy.lib.duke.edu/login?url=http://www.law.duke.edu/journals/lcp/',
                        type: 'fulltext',
                        text: 'Law and contemporary problems, v. 63, no. 1-2' }],
           'unc' => [{ href: 'http://libproxy.lib.unc.edu/login?url=http://www.law.duke.edu/journals/lcp/',
                       type: 'fulltext',
                       text: 'Law and contemporary problems, v. 63, no. 1-2' }])
      )
    end
  end

  ########################
  # RIS Field Mapping
  ########################

  describe 'export as ris' do
    let(:test_document) do
      SolrDocument.new(YAML.safe_load(file_fixture('documents/DUKE002952265.yml').read).first)
    end

    # Skip until pub date is indexed correctly
    xit 'exports the document as RIS' do
      expect(test_document.export_as_ris).to eq(
        "TY  - BOOK\r\n"\
        "A1  - Maureen E. Downey.\r\n"\
        "AV  - Perkins Public Documents/Maps (Call Number: SI 1.27:435)\r\n"\
        "ID  - DUKE002952265\r\n"\
        "KW  - Brisingida -- Atlantic Ocean -- Classification\r\n"\
        "KW  - Echinodermata -- Classification\r\n"\
        "KW  - Echinodermata -- Atlantic Ocean -- Classification\r\n"\
        "LA  - English\r\n"\
        "PB  - Washington : Smithsonian Institution Press, 1986.\r\n"\
        "PY  - 1986\r\n"\
        'TI  - Revision of the Atlantic Brisingida (Echinodermata:Asteroidea), '\
        "with description of a new genus and family /\r\n"\
        "UR  - https://discovery.trln.org/catalog/DUKE002952265\r\n"\
        'ER  - '
      )
    end
  end

  ########################
  # Open CTX KEV Field
  ########################

  describe 'export as openurl_ctx_kev' do
    subject(:ctx_kev) do
      SolrDocument.new(YAML.safe_load(
        file_fixture('documents/DUKE002952265.yml').read
      ).first).export_as_openurl_ctx_kev
    end

    it 'contains a url_ver' do
      expect(ctx_kev).to match('url_ver=Z39.88-2004')
    end

    it 'contains a url_ctx_fmt' do
      expect(ctx_kev).to match('url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx')
    end

    it 'contains a ctx_ver' do
      expect(ctx_kev).to match('ctx_ver=Z39.88-2004')
    end

    it 'contains an rft.title' do
      expect(ctx_kev).to match('rft.title=Revision\+of\+the\+Atlantic\+Brisingida\+'\
                               '%28Echinodermata%3AAsteroidea%29%2C\+with\+description\+'\
                               'of\+a\+new\+genus\+and\+family\+%2F')
    end

    # Skip until pub date is indexed correctly
    xit 'contains an rft.date' do
      expect(ctx_kev).to match('rft.date=1986')
    end

    it 'contains an rft.au' do
      expect(ctx_kev).to match('rft.au=Maureen\+E.\+Downey.')
    end

    it 'contains an rft_val_fmt' do
      expect(ctx_kev).to match('rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook')
    end

    it 'contains an rft_id' do
      expect(ctx_kev).to match('rft_id=https%3A%2F%2Fdiscovery.trln.org%2Fcatalog%2FDUKE002952265')
    end
  end

  ########################
  # Email Field Mapping
  ########################

  describe 'export to email' do
    let(:test_document) do
      SolrDocument.new(YAML.safe_load(file_fixture('documents/DUKE002952265.yml').read).first)
    end

    # rubocop:disable ExampleLength
    # Skip until pub date is indexed correctly
    xit 'exports the document to email text' do
      expect(test_document.to_email_text).to eq(
        "\n"\
        "Title:\n"\
        '  Revision of the Atlantic Brisingida (Echinodermata:Asteroidea), '\
        "with description of a new genus and family /\n"\
        "\n"\
        "Author:\n"\
        "  Maureen E. Downey.\n"\
        "\n"\
        "Link to Record:\n"\
        "  https://discovery.trln.org/catalog/DUKE002952265\n"\
        "\n"\
        "Location:\n"\
        "  Perkins Public Documents/Maps (Call Number: SI 1.27:435)\n"\
        "\n"\
        "Publisher:\n"\
        "  Washington : Smithsonian Institution Press, 1986.\n"\
        "\n"\
        "Date:\n"\
        "  1986\n"\
        "\n"\
        "Format:\n"\
        '  Book'
      )
    end
  end

  ########################
  # SMS Field Mapping
  ########################

  describe 'export to sms' do
    let(:test_document) do
      SolrDocument.new(YAML.safe_load(file_fixture('documents/DUKE002952265.yml').read).first)
    end

    # Skip until pub date is indexed correctly
    xit 'exports the document to email text' do
      expect(test_document.to_email_text).to eq(
        "\n"\
        "Title:\n"\
        '  Revision of the Atlantic Brisingida (Echinodermata:Asteroidea), '\
        "with description of a new genus and family /\n"\
        "\n"\
        "Author:\n"\
        "  Maureen E. Downey.\n"\
        "\n"\
        "Link to Record:\n"\
        "  https://discovery.trln.org/catalog/DUKE002952265\n"\
        "\n"\
        "Location:\n"\
        "  Perkins Public Documents/Maps (Call Number: SI 1.27:435)\n"\
        "\n"\
        "Publisher:\n"\
        "  Washington : Smithsonian Institution Press, 1986.\n"\
        "\n"\
        "Date:\n"\
        "  1986\n"\
        "\n"\
        "Format:\n"\
        '  Book'
      )
    end
  end

  ########################
  # Work Entry
  ########################

  describe 'included_work' do
    let(:included_work_document) do
      SolrDocumentTestClass.new(
        id: 'UNC002981535',
        included_work_a: ['{"author":"Saint-Saëns, Camille, 1835-1921.","title":["Quartets,",'\
                          '"violins (2), viola, cello,","no. 2, op. 153,","G major"]}',
                          '{"author":"Masson, VeNeta.","title":["Rehab at the Florida Avenue Grill."],'\
                          '"isbn":["0967368804"]}']
      )
    end

    it 'deserializes the string and mixes in a title_linking field for building progressive links' do
      expect(included_work_document.included_work).to eq(
        [{ label: '',
           author: 'Saint-Saëns, Camille, 1835-1921.',
           title: ['Quartets,', 'violins (2), viola, cello,', 'no. 2, op. 153,', 'G major'],
           title_variation: '',
           details: '',
           isbn: [],
           issn: '',
           title_linking:
             [{ params:
                { author: 'Saint-Saëns, Camille, 1835-1921.', title: 'Quartets,' },
                display_segments: ['Saint-Saëns, Camille, 1835-1921.', 'Quartets,'] },
              { params:
                { author: 'Saint-Saëns, Camille, 1835-1921.',
                  title: 'Quartets, violins (2), viola, cello,' },
                display_segments:
                  ['Saint-Saëns, Camille, 1835-1921.',
                   'Quartets,',
                   'violins (2), viola, cello,'] },
              { params:
                { author: 'Saint-Saëns, Camille, 1835-1921.',
                  title: 'Quartets, violins (2), viola, cello, no. 2, op. 153,' },
                display_segments:
                  ['Saint-Saëns, Camille, 1835-1921.',
                   'Quartets,',
                   'violins (2), viola, cello,',
                   'no. 2, op. 153,'] },
              { params:
                { author: 'Saint-Saëns, Camille, 1835-1921.',
                  title: 'Quartets, violins (2), viola, cello, no. 2, op. 153, G major' },
                display_segments:
                  ['Saint-Saëns, Camille, 1835-1921.',
                   'Quartets,',
                   'violins (2), viola, cello,',
                   'no. 2, op. 153,',
                   'G major'] }] },
         { label: '',
           author: 'Masson, VeNeta.',
           title: ['Rehab at the Florida Avenue Grill.'],
           title_variation: '',
           details: '',
           isbn: ['0967368804'],
           issn: '',
           title_linking:
            [{ params:
               { author: 'Masson, VeNeta.',
                 title: 'Rehab at the Florida Avenue Grill.' },
               display_segments:
                 ['Masson, VeNeta.', 'Rehab at the Florida Avenue Grill.'] }] }]
      )
    end
  end

  ########################
  # Imprint
  ########################

  describe 'Imprint' do
    let(:imprint_document) do
      SolrDocumentTestClass.new(
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

    describe '#imprint_main_for_header_display' do
      it 'assembles the imprint main field values for header display' do
        expect(imprint_document.imprint_main_for_header_display).to(
          eq('Fall/Winter 2002-: Savannah, GA : Dept. of Languages, '\
             'Literature & Philosophy, Armstrong Atlantic State University')
        )
      end
    end

    describe '#imprint_multiple_for_display' do
      it 'assembles imprint_main and imprint_multiple for display' do
        expect(imprint_document.imprint_multiple_for_display).to(
          eq('Raleigh, N.C. : Published by the editors in cooperation with the School of Liberal Arts at '\
          'North Carolina State of the University of North Carolina, [1964-<br />'\
          'Spring 1978-winter 1995: Charlotte, N.C. : English Dept., '\
          'UNCC<br />Summer 1996-winter 1999'\
          ': Charlotte, N.C. : Advancment Studies, CPCC<br />'\
          'Summer 2000-summer 2001: Charlotte, N.C. : English Dept., CPCC<br />'\
          'Fall/Winter 2002-: Savannah, GA : Dept. of Languages, '\
          'Literature & Philosophy, Armstrong Atlantic State University')
        )
      end
    end

    describe '#imprint_main_to_text' do
      it 'assembles imprint main for exporting to text formats' do
        expect(imprint_document.imprint_main_to_text).to(
          eq(['Fall/Winter 2002-: Savannah, GA : Dept. of Languages, Literature & Philosophy, '\
              'Armstrong Atlantic State University'])
        )
      end
    end

    describe '#imprint_main' do
      it 'deserializes the imprint_main values' do
        expect(imprint_document.imprint_main).to(
          eq([{ type: 'imprint',
                label: 'Fall/Winter 2002-',
                value: 'Savannah, GA : Dept. of Languages, Literature & Philosophy, '\
                       'Armstrong Atlantic State University' }])
        )
      end
    end

    describe '#imprint_multiple' do
      it 'deserializes the imprint_multiple values' do
        expect(imprint_document.imprint_multiple).to(
          eq([{ type: 'imprint',
                label: '',
                value: 'Raleigh, N.C. : Published by the editors in cooperation with the School of Liberal Arts '\
                       'at North Carolina State of the University of North Carolina, [1964-' },
              { type: 'imprint',
                label: 'Spring 1978-winter 1995',
                value: 'Charlotte, N.C. : English Dept., UNCC' },
              { type: 'imprint',
                label: 'Summer 1996-winter 1999',
                value: 'Charlotte, N.C. : Advancment Studies, CPCC' },
              { type: 'imprint',
                label: 'Summer 2000-summer 2001',
                value: 'Charlotte, N.C. : English Dept., CPCC' },
              { type: 'imprint',
                label: 'Fall/Winter 2002-',
                value: 'Savannah, GA : Dept. of Languages, Literature & Philosophy, '\
                       'Armstrong Atlantic State University' }])
        )
      end
    end
  end

  ########################
  # Expand Document
  ########################

  describe 'ExpandDocument' do
    context 'rolled up record' do
      let(:rollup_id) { 'OCLC5555' }
      let(:expanded_solr_doc) do
        SolrDocumentTestClass.new(
          id: 'DUKE123456789',
          rollup_id: rollup_id,
          owner_a: ['duke'],
          items: 'a duke item'
        )
      end

      let(:rolled_up_doc) do
        { id: 'UNC123456789',
          rollup_id: rollup_id,
          owner_a: ['unc'],
          items_a: 'a unc item',
          url_a: ['{"href":"https://proxy.lib.unc.edu/login?url='\
                  'http://www.aspresolver.com/aspresolver.asp?ANTH;1659389",'\
                  '"type":"fulltext","text":"Episode 1"}'] }
      end

      let(:another_rolled_up_doc) do
        { id: 'UNC123456790',
          rollup_id: rollup_id,
          owner_a: ['unc'],
          items_a: 'another unc item' }
      end

      let(:response) do
        { 'expanded' => { rollup_id => { 'docs' => [rolled_up_doc, another_rolled_up_doc] } } }
      end

      before do
        allow(expanded_solr_doc).to receive(:response).and_return(response)
      end

      it 'combines the expanded doc with the rolled up doc' do
        expect(expanded_solr_doc.expanded_docs.count).to eq(3)
      end

      it 'groups documents by record association and includes unc' do
        expect(expanded_solr_doc.expanded_docs_grouped_by_association).to(
          have_key('unc')
        )
      end

      it 'groups documents by record association and includes duke' do
        expect(expanded_solr_doc.expanded_docs_grouped_by_association).to(
          have_key('duke')
        )
      end

      it 'combines the unc records into single pseudo record with combined items' do
        expect(expanded_solr_doc.docs_with_holdings_merged_from_expanded_docs['unc']['items_a']).to(
          eq(['a unc item', 'another unc item'])
        )
      end

      it 'groups the urls by institution' do
        expect(expanded_solr_doc.all_shared_and_local_fulltext_urls_by_inst).to(
          eq('unc' => [{ href: 'https://proxy.lib.unc.edu/login?url='\
                               'http://www.aspresolver.com/aspresolver.asp?ANTH;1659389',
                         type: 'fulltext',
                         text: 'Episode 1' }])
        )
      end
    end

    context 'shared open access resource' do
      let(:shared_document) do
        SolrDocumentTestClass.new(
          id: 'DUKE123456789',
          owner_a: ['unc'],
          institution_a: %w[unc duke ncsu nccu],
          url_a: ['{"href":"http://purl.access.gpo.gov/GPO/LPS111292","type":"fulltext","restricted":"false"}']
        )
      end

      it 'returns open access urls as part of the trln group' do
        expect(shared_document.all_open_access_urls_by_inst).to(
          eq('trln' => [{ href: 'http://purl.access.gpo.gov/GPO/LPS111292',
                          type: 'fulltext',
                          text: '',
                          restricted: 'false' }])
        )
      end
    end
  end

  ########################
  # Syndetics Data
  ########################

  describe '#cover_image' do
    context 'when we link to a Syndetics cover image with various options' do
      let(:oclc) do
        '123098080985'
      end

      let(:isbn) do
        '123456789012X'
      end

      let(:document) do
        SolrDocumentTestClass.new(
          id: 'TRLN12345',
          isbn_number_a: ['123456789012X']
        )
      end

      let(:oclc_document) do
        SolrDocumentTestClass.new(
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
        actual = document.cover_image { |x| URI(x) }
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end

      it 'generates a link to a small cover image with custom options' do
        expected = URI(format(url_template.gsub(/trlnet/, 'ncstateu'), isbn, 'SC.GIF'))
        actual = document.cover_image(size: 'small', client: 'ncstateu') do |x|
          URI(x)
        end
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end

      it 'generates a link to a medium cover image with an OCLC number' do
        expected = URI(format(url_template + '&oclc=' + oclc, isbn, 'MC.GIF'))
        actual = oclc_document.cover_image(size: :medium) { |x| URI(x) }
        expect(CGI.parse(actual.query)).to eq(CGI.parse(expected.query))
      end
    end
  end
end
