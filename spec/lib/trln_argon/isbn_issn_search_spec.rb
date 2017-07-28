class IsbnIssnSearchTestClass < CatalogController
  include TrlnArgon::IsbnIssnSearch
end

describe TrlnArgon::IsbnIssnSearch do
  let(:test_class) { IsbnIssnSearchTestClass.new }

  describe '#strip_extraneous_chars_from_isbn_issn_search' do
    before do
      allow(test_class).to receive(:params).and_return(params)
      test_class.send(:strip_extraneous_chars_from_isbn_issn_search)
    end

    context 'an isbn_issn fielded search' do
      let(:params) { { search_field: 'isbn_issn', q: '0343 12-58' } }

      it 'strips extraneous characters from the q parameter' do
        expect(params[:q]).to eq '03431258'
      end
    end

    context 'an advanced search query with an isbn_issn value' do
      let(:params) { { search_field: 'advanced', isbn_issn: '0343 12-58' } }

      it 'strips extraneous characters from the isbn_issn parameter' do
        expect(params[:isbn_issn]).to eq '03431258'
      end
    end

    context 'an All Fields search' do
      let(:params) { { search_field: 'all_fields', q: '0343 12-58' } }

      it 'does not modify the q parameter' do
        expect(params[:q]).to eq '0343 12-58'
      end
    end
  end
end
