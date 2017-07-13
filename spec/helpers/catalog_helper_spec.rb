describe CatalogHelper do
  include ERB::Util
  include described_class

  let(:docs) { json['docs'] }

  def mock_response(args)
    current_page = args[:current_page] || 1
    per_page = args[:rows] || args[:per_page] || 10
    total = args[:total]
    start = (current_page - 1) * per_page

    mock_docs = (1..total).to_a.map { ActiveSupport::HashWithIndifferentAccess.new }

    mock_response = Kaminari.paginate_array(mock_docs).page(current_page).per(per_page)

    allow(mock_response).to receive(:docs).and_return(mock_docs.slice(start, per_page))
    mock_response
  end

  def render_grouped_response?
    false
  end

  describe '#page_entries_info', verify_stubs: false do
    let(:filter_scope_name) { 'scope_name' }

    it 'with no results' do
      response = mock_response total: 0

      html = page_entries_info(response, entry_name: 'entry_name')
      expect(html).to eq 'No scope_name entry_names found'
    end

    it 'with no results (and no entry_name provided)' do
      response = mock_response total: 0

      html = page_entries_info(response)
      expect(html).to eq 'No scope_name results found'
    end

    it 'with an empty page of results' do
      response = double(limit_value: -1)

      html = page_entries_info(response)
      expect(html).to be_blank
    end

    describe 'with a single result' do
      it 'uses the provided entry name' do
        response = mock_response total: 1

        html = page_entries_info(response, entry_name: 'entry_name')
        expect(html).to eq '<strong>1</strong> scope_name entry_name found'
      end

      it 'infers a name' do
        response = mock_response total: 1

        html = page_entries_info(response)
        expect(html).to eq '<strong>1</strong> scope_name result found'
      end

      it 'uses the model_name from the response' do
        response = mock_response total: 1
        allow(response).to receive(:model_name).and_return(double(human: 'thingy'))

        html = page_entries_info(response)
        expect(html).to eq '<strong>1</strong> scope_name thingy found'
      end

      it 'with a single page of results' do
        response = mock_response total: 7

        html = page_entries_info(response, entry_name: 'entry_name')
        expect(html).to eq '<strong>1</strong> - <strong>7</strong> of <strong>7 scope_name entry_names</strong>'
      end

      it 'on the first page of multiple pages of results' do
        response = mock_response total: 15, per_page: 10

        html = page_entries_info(response, entry_name: 'entry_name')
        expect(html).to eq '<strong>1</strong> - <strong>10</strong> of <strong>15 scope_name entry_names</strong>'
      end

      it 'on the second page of multiple pages of results' do
        response = mock_response total: 47, per_page: 10, current_page: 2

        html = page_entries_info(response, entry_name: 'entry_name')
        expect(html).to eq '<strong>11</strong> - <strong>20</strong> of <strong>47 scope_name entry_names</strong>'
      end

      it 'on the last page of results' do
        response = mock_response total: 47, per_page: 10, current_page: 5

        html = page_entries_info(response, entry_name: 'entry_name')
        expect(html).to eq '<strong>41</strong> - <strong>47</strong> of <strong>47 scope_name entry_names</strong>'
      end

      it 'works with rows the same as per_page' do
        response = mock_response total: 47, rows: 20, current_page: 2

        html = page_entries_info(response, entry_name: 'entry_name')
        expect(html).to eq '<strong>21</strong> - <strong>40</strong> of <strong>47 scope_name entry_names</strong>'
      end

      it 'uses delimiters with large numbers' do
        response = mock_response total: 5000, rows: 10, current_page: 101
        html = page_entries_info(response, entry_name: 'entry_name')

        expect(html).to eq '<strong>1,001</strong> - <strong>1,010</strong> ' \
                           'of <strong>5,000 scope_name entry_names</strong>'
      end
    end
  end
end
