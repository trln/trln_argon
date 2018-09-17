describe 'brief records' do
  before do
    visit search_catalog_path
    click_button 'search'
  end

  describe 'displays multiple fields from the record' do
    def brief_records
      page.find(:css, '#documents:first-of-type')
    end

    it 'displays the statement of responsibility field value' do
      expect(brief_records).to have_css('li.statement_of_responsibility_a', text: /.+/)
    end

    it 'displays the imprint main field value' do
      expect(brief_records).to have_css('li.imprint_main_a', text: /.+/)
    end

    it 'displays the resource_type field value' do
      expect(brief_records).to have_css('li.resource_type_a', text: /.+/)
    end
  end

  it 'has a title that links to the full record' do
    brief_record_title = page.find('.document-position-0 .document-title-heading')
    expect(brief_record_title).to have_link(nil, href: %r{/catalog/.+})
  end
end
