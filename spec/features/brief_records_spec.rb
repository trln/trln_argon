describe 'brief records' do
  before do
    visit search_catalog_path
    click_button 'search'
  end

  describe 'displays multiple fields from the record' do
    def brief_records
      page.find(:css, '#documents:first-of-type')
    end

    describe 'author field' do
      it 'displays the author field label' do
        expect(brief_records).to have_css('dt.blacklight-authors_main_a', text: 'Author:')
      end

      it 'displays the author field value' do
        expect(brief_records).to have_css('dd.blacklight-authors_main_a', text: /.+/)
      end
    end

    it 'displays the format field label' do
      expect(brief_records).to have_css('dt.blacklight-format_a', text: 'Format:')
    end

    it 'displays the format field value' do
      expect(brief_records).to have_css('dd.blacklight-format_a', text: /.+/)
    end

    it 'displays the language field label' do
      expect(brief_records).to have_css('dt.blacklight-language_a', text: 'Language:')
    end

    it 'displays the language field value' do
      expect(brief_records).to have_css('dd.blacklight-language_a', text: /.+/)
    end

    it 'displays the publisher field label' do
      expect(brief_records).to have_css('dt.blacklight-publisher_etc_a', text: 'Publisher Etc:')
    end

    it 'displays the publisher field value' do
      expect(brief_records).to have_css('dd.blacklight-publisher_etc_a', text: /.+/)
    end

    it 'displays the publication year field label' do
      expect(brief_records).to have_css('dt.blacklight-publication_year_isort_stored_single', text: 'Date:')
    end

    it 'displays the publication year field value' do
      expect(brief_records).to have_css('dd.blacklight-publication_year_isort_stored_single', text: /.+/)
    end

    it 'displays the institution field label' do
      expect(brief_records).to have_css('dt.blacklight-institution_a', text: 'Institution:')
    end

    it 'displays the institution field value' do
      expect(brief_records).to have_css('dd.blacklight-institution_a', text: /.+/)
    end
  end

  it 'has a title that links to the full record' do
    brief_record_title = page.find('.document-position-0 .document-title-heading')
    expect(brief_record_title).to have_link(nil, href: %r{/catalog/.+})
  end
end
