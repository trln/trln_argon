describe BlacklightAdvancedSearch::QueryParser do
  let(:obj) { described_class.new(search_state, config) }
  let(:search_state) {}
  let(:config) { Blacklight::Configuration.new }

  # rubocop:disable RSpec/NestedGroups
  describe '#keyword_queries_adjusted_for_truncation' do
    context 'when query truncation is not turned on via config' do
      before { TrlnArgon::Engine.configuration.enable_query_truncation = '' }

      let(:keyword_queries) do
        [{ field: 'all_fields', query: '1 2 3 4 5 6 7 8 9 10 11 12' }]
      end

      it 'does not truncate the query' do
        expect(obj.keyword_queries_adjusted_for_truncation(keyword_queries)).to eq(
          [{ field: 'all_fields', query: '1 2 3 4 5 6 7 8 9 10 11 12' }]
        )
      end
    end

    context 'when query truncation is turned on via config' do
      before { TrlnArgon::Engine.configuration.enable_query_truncation = 'true' }

      context 'with a basic short query in all_fields' do
        let(:keyword_queries) do
          [{ field: 'all_fields', query: '1 2 3 4' }]
        end

        it 'does not truncate anything' do
          expect(obj.keyword_queries_adjusted_for_truncation(keyword_queries)).to eq(
            [{ field: 'all_fields', query: '1 2 3 4' }]
          )
        end
      end

      context 'with a long query in all_fields' do
        let(:keyword_queries) do
          [{ field: 'all_fields', query: '1 2 3 4 5 6 7 8 9 10 11 12' }]
        end

        it 'truncates to 9 terms' do
          expect(obj.keyword_queries_adjusted_for_truncation(keyword_queries)).to eq(
            [{ field: 'all_fields', query: '1 2 3 4 5 6 7 8 9' }]
          )
        end
      end

      context 'with a long query in title' do
        let(:keyword_queries) do
          [{ field: 'title',
query: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30' }]
        end

        it 'truncates to 19 terms' do
          expect(obj.keyword_queries_adjusted_for_truncation(keyword_queries)).to eq(
            [{ field: 'title', query: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19' }]
          )
        end
      end

      context 'with 8 terms in all_fields & 8 terms in title' do
        let(:keyword_queries) do
          [{ field: 'all_fields', query: '1 2 3 4 5 6 7 8' },
           { field: 'title', query: '1 2 3 4 5 6 7 8' }]
        end

        it 'truncates all_fields to 5 terms but leaves title untruncated' do
          expect(obj.keyword_queries_adjusted_for_truncation(keyword_queries)).to eq(
            [{ field: 'all_fields', query: '1 2 3 4 5' },
             { field: 'title', query: '1 2 3 4 5 6 7 8' }]
          )
        end
      end

      context 'with 10 terms in title, author, subject, series, publisher, isbn_issn' do
        let(:keyword_queries) do
          [{ field: 'title', query: '1 2 3 4 5 6 7 8 9 10' },
           { field: 'author', query: '1 2 3 4 5 6 7 8 9 10' },
           { field: 'subject', query: '1 2 3 4 5 6 7 8 9 10' },
           { field: 'series', query: '1 2 3 4 5 6 7 8 9 10' },
           { field: 'publisher', query: '1 2 3 4 5 6 7 8 9 10' },
           { field: 'isbn_issn', query: '1 2 3 4 5 6 7 8 9 10' }]
        end

        it 'truncates title to 5 but leaves the other fields untruncated' do
          expect(obj.keyword_queries_adjusted_for_truncation(keyword_queries)).to eq(
            [{ field: 'title', query: '1 2 3 4 5' },
             { field: 'author', query: '1 2 3 4 5 6 7 8 9 10' },
             { field: 'subject', query: '1 2 3 4 5 6 7 8 9 10' },
             { field: 'series', query: '1 2 3 4 5 6 7 8 9 10' },
             { field: 'publisher', query: '1 2 3 4 5 6 7 8 9 10' },
             { field: 'isbn_issn', query: '1 2 3 4 5 6 7 8 9 10' }]
          )
        end
      end

      context 'with 15 terms in all_fields, title, author, subject' do
        let(:keyword_queries) do
          [{ field: 'all_fields', query: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15' },
           { field: 'title', query: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15' },
           { field: 'author', query: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15' },
           { field: 'subject', query: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15' }]
        end

        it 'truncates all_fields to 1, title to 4, but leaves the rest untruncated' do
          expect(obj.keyword_queries_adjusted_for_truncation(keyword_queries)).to eq(
            [{ field: 'all_fields', query: '1' },
             { field: 'title', query: '1 2 3 4' },
             { field: 'author', query: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15' },
             { field: 'subject', query: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15' }]
          )
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
