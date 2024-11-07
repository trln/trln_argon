describe 'brief records' do
  before do
    VCR.use_cassette('brief_records/how_milton_works') do
      visit search_catalog_path
      fill_in('q', with: 'how milton works stanley fish')
      click_button 'search'
    end
  end

  describe 'displays multiple fields from the record' do
    def brief_records
      page.find(:css, '#documents:first-of-type')
    end

    it 'displays the statement of responsibility field value' do
      expect(brief_records).to have_css('dd.blacklight-statement_of_responsibility_a', text: /.+/)
    end

    it 'does not display a blank edition field value' do
      expect(brief_records).not_to have_css('.document[data-document-id=UNCb3917352] dd.blacklight-edition_a')
    end

    it 'displays the imprint main field value' do
      expect(brief_records).to have_css('dd.blacklight-imprint_main_a', text: /.+/)
    end

    it 'displays the resource_type field value' do
      expect(brief_records).to have_css('dd.blacklight-resource_type_a', text: /.+/)
    end
  end

  it 'has a title that links to the full record' do
    brief_record_title = page.find('.document-position-1 .document-title-heading')
    expect(brief_record_title).to have_link(nil, href: %r{/catalog/.+})
  end
end
