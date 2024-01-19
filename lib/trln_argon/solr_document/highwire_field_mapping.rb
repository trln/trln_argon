module TrlnArgon
  module SolrDocument
    module HighwireFieldMapping
      # https://raw.githubusercontent.com/zotero/translators/db2771d52d89d1480ff98efbd6968565893f2184/Embedded%20Metadata.js
      MAPPING = {
        'title_main' => 'citation_title',
        'publication_year_sort' => 'citation_publication_date',
        'publisher_a' => 'citation_publisher',
        'publisher_location_a' => 'citation_place',
        'isbn_number_a' => 'citation_isbn',
        'statement_of_responsibility_a' => 'citation_author',
        'issn_primary_a' => 'citation_issn',
        'language_a' => 'citation_language'
      }.freeze

      def highwire_metadata_tags
        result = MAPPING.each_with_object([]) do |(k, v), o|
          docvalue = fetch(k, [])
          process_docvalue(o, v, docvalue) unless docvalue.empty?
        end

        auths = highwire_authors
        process_authors(result, auths) if auths

        result
      end

      private

      def process_docvalue(result, key, docvalue)
        if docvalue.is_a?(Array)
          docvalue.each { |dv| result << [key, dv] }
        else
          result << [key, docvalue]
        end
      end

      def process_authors(result, auths)
        result.reject! { |x| x[0] == 'citation_author' }
        auths.each { |n| result << ['citation_authors', n] }
      end

      def highwire_authors
        named_authors = names.select { |n| n.fetch(:rel, '') == 'author' }
        named_editors = names.select { |n| n.fetch(:rel, '') == 'editor' }
        named_norel = names.select { |n| n.fetch(:rel, '').empty? }
        [named_authors, named_editors, named_norel].find { |x| !x.empty? }&.map { |x| x[:name] }
      end
    end
  end
end
