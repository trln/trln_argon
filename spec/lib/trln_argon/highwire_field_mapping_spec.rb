# rubocop:disable RSpec/FilePath
describe TrlnArgon::SolrDocument::HighwireFieldMapping do
  include described_class
  # rubocop:disable RSpec/LeakyConstantDeclaration
  class SolrDocumentTestClass
    include Blacklight::Solr::Document
    include TrlnArgon::SolrDocument
  end
  # rubocop:enable RSpec/LeakyConstantDeclaration

  describe '#highwire_metadata_tags' do
    let(:document1) do
      SolrDocumentTestClass.new(
        'title_main' => 'Title',
        'publisher_a' => 'Publisher',
        'publication_year_sort' => '2023',
        'isbn_number_a' => '12345678',
        'publisher_location_a' => 'Durham',
        'language_a' => 'English',
        'statement_of_responsibility_a' => [
          { name: 'Author 1', rel: 'author' },
          { name: 'Author 2', rel: 'editor' }
        ]
      )
    end

    let(:document2) do
      SolrDocumentTestClass.new(
        'title_main' => 'Title',
        'publisher_a' => 'Publisher'
      )
    end

    let(:document3) do
      SolrDocumentTestClass.new(
        'title_main' => 'Title',
        'publisher_a' => 'Publisher',
        'issn_primary_a' => '123456'
      )
    end

    it 'generates metadata tags based on the mapping' do
      result = document1.highwire_metadata_tags
      expect(result).to include(
        ['citation_title', 'Title'],
        ['citation_publication_date', '2023'],
        ['citation_publisher', 'Publisher'],
        ['citation_place', 'Durham'],
        ['citation_isbn', '12345678'],
        ['citation_author', { 'name' => 'Author 1', 'rel' => 'author' }],
        ['citation_author', { 'name' => 'Author 2', 'rel' => 'editor' }],
        ['citation_language', 'English']
      )
    end

    it 'does not include citation_author if there are no authors' do
      result = document2.highwire_metadata_tags
      expect(result).not_to include(['citation_author'])
    end

    it 'includes issn if there is an issn' do
      result = document3.highwire_metadata_tags
      expect(result).to include(
        ['citation_title', 'Title'],
        ['citation_publisher', 'Publisher'],
        ['citation_issn', '123456']
      )
    end
  end
end
# rubocop:enable RSpec/FilePath
