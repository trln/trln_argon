describe TrlnArgon::SolrDocument do
  class SolrDocumentTestClass
    include Blacklight::Solr::Document
    include TrlnArgon::SolrDocument
  end

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
                  '{"href":"http://www.law.duke.edu/journals/lcp/",'\
                  '"type":"other",'\
                  '"text":"Law and contemporary problems, v. 63, no. 1-2"}']
        )
      end

      it 'deserializes each of the url entries' do
        expect(solr_document.urls).to(
          eq([{ href: 'http://www.law.duke.edu/journals/lcp/',
                type: 'other',
                text: 'Law and contemporary problems, v. 63, no. 1-2' },
              { href: 'http://www.law.duke.edu/journals/lcp/',
                type: 'other',
                text: 'Law and contemporary problems, v. 63, no. 1-2' },
              { href: 'http://www.law.duke.edu/journals/lcp/',
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

  describe 'export as ris' do
    let(:test_document) do
      SolrDocument.new(YAML.safe_load(file_fixture('documents/DUKE002952265.yml').read).first)
    end

    before do
      allow(test_document).to receive(:expanded_holdings) do
        { 'duke' => {
          'DOCS' => {
            'PGSM' => {
              'loc_b' => 'DOCS', 'loc_n' => 'PGSM', 'call_no' => 'SI 1.27:435'
            }
          }
        } }
      end
    end

    it 'exports the document as RIS' do
      expect(test_document.export_as_ris).to eq(
        "TY  - GEN\r\n"\
        "A1  - Downey, Maureen E.\r\n"\
        "A2  - Smithsonian Institution. Press.\r\n"\
        "AV  - Located at Duke: Perkins Public Documents/Maps (Call Number: SI 1.27:435)\r\n"\
        "ID  - DUKE002952265\r\n"\
        "KW  - Brisingida -- Atlantic Ocean -- Classification\r\n"\
        "KW  - Echinodermata -- Classification\r\n"\
        "KW  - Echinodermata -- Atlantic Ocean -- Classification\r\n"\
        "LA  - English\r\n"\
        "N1  - Distributed to depository libraries in microfiche.\r\n"\
        "N1  - Includes index.\r\n"\
        "N1  - Bibliography: p. 53-56.\r\n"\
        "PY  - 1986\r\n"\
        'TI  - Revision of the Atlantic Brisingida (Echinodermata:Asteroidea), '\
        "with description of a new genus and family /\r\n"\
        "UR  - https://discovery.trln.org/catalog/DUKE002952265\r\n"\
        'ER  - '
      )
    end
  end

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

    it 'contains an rft.date' do
      expect(ctx_kev).to match('rft.date=1986')
    end

    it 'contains an rft.au' do
      expect(ctx_kev).to match('rft.au=Downey%2C\+Maureen\+E.&rft.au=Smithsonian\+Institution.\+Press.')
    end

    it 'contains an rft_val_fmt' do
      expect(ctx_kev).to match('rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook')
    end

    it 'contains an rft_id' do
      expect(ctx_kev).to match('rft_id=info%3Asid%2Fdiscovery.trln.org%2Fcatalog')
    end
  end
end
