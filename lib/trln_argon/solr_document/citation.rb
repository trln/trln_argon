require 'citeproc'
require 'csl/styles'
require 'bibtex'
require 'citeproc/ruby'
require 'json'

module TrlnArgon
  module SolrDocument
    module Citation
      MAPPING = {
        'id' => 'id',
        'title_main' => 'title',
        'publication_year_sort' => 'year',
        'names_a' => 'author',
        'note_general_a' => 'note',
        'isbn_number_a' => 'number',
        'physical_description_a' => 'pages',
        'publisher_a' => 'publisher',
        'resource_type_a' => 'type',
        'edition_a' => 'edition',
        'publisher_location_a' => 'address',
        'language_a' => 'language',
        'issn_primary_a' => 'issn',
        'url_a' => 'url'
      }.freeze

      def citations
        @all_citations ||= generate_citations
      end

      def generate_citations
        citation_hash = {}
        result = map_document_values
        bibtex_string = convert_to_bibtex_format(result)
        bibliography = BibTeX.parse(bibtex_string)
        process_citations(bibliography, citation_hash)
        citation_hash
      end

      private

      def map_document_values
        MAPPING.each_with_object([]) do |(key, value), output|
          docvalue = fetch(key, [])
          next if docvalue.empty?

          case key
          when 'url_a'
            process_url(docvalue, value, output)
          when 'names_a'
            process_names(docvalue, output)
          else
            process_docvalue(output, value, docvalue)
          end
        end
      end

      def process_url(docvalue, value, output)
        processed_value = parse_url(docvalue)
        process_docvalue(output, value, processed_value)
      end

      def process_names(docvalue, output)
        authors, editors = parse_authors_and_editors(docvalue)
        process_docvalue(output, 'author', authors) unless authors.empty?
        process_docvalue(output, 'editor', editors) unless editors.empty?
      end

      def parse_url(docvalue)
        JSON.parse(docvalue.first)['href']
      end

      def parse_authors_and_editors(docvalue)
        authors = []
        editors = []
        docvalue.each do |doc|
          parsed_doc = JSON.parse(doc)
          if parsed_doc['rel'] == 'editor'
            editors << parsed_doc['name']
          elsif parsed_doc['rel'] != 'illustrator'
            authors << parsed_doc['name']
          end
        end
        [authors.join(' and '), editors.join(' and ')]
      end

      def convert_to_bibtex_format(input)
        identifier = input.detect { |key, _| key == 'id' }[1]
        entry_type = input.detect { |key, _| key == 'type' }[1].split(',').first.strip.downcase
        entry_type = map_entry_type(entry_type)
        # The bibtex string should look like this
        # "@book{id, author = {Author, A.}, title = {Title}, journal = {Journal}, year = {2020}}"
        formatted_pairs = input.reject { |key, _| ['id', 'type'].include?(key) }.map do |key, value|
          "#{key} = {#{value}}"
        end
        "@#{entry_type}{#{identifier}, #{formatted_pairs.join(', ')}}"
      end

      def process_citations(bibliography, citation_hash)
        desired_formats.each do |format|
          style = CSL::Style.load(format)
          processor = CiteProc::Processor.new(style: style, format: 'html')
          processor.import(bibliography.to_citeproc)
          citation = processor.render(:bibliography, id: bibliography.first.id).first
          citation_hash[format] = citation
        end
      end

      # rubocop:disable CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      def map_entry_type(entry_type)
        case entry_type
        when 'Archival and manuscript material'
          'manuscript'
        when 'Audiobook'
          'audio'
        when 'Book'
          'book'
        when 'Database'
          'database'
        when 'Dataset -- Statistical'
          'dataset'
        when 'Dataset -- Geospatial'
          'dataset'
        when 'Game'
          'game'
        when 'Government publication'
          'government'
        when 'Image'
          'image'
        when 'Journal, Magazine, or Periodical'
          'article-journal'
        when 'Kit'
          'kit'
        when 'Map'
          'map'
        when 'Music recording'
          'music'
        when 'Music score'
          'music'
        when 'Newspaper'
          'article-newspaper'
        when 'Non-musical sound recording'
          'audio'
        when 'Object'
          'object'
        when 'Software/multimedia'
          'software'
        when 'Thesis/Dissertation'
          'thesis'
        when 'Video'
          'video'
        when 'Web page or site'
          'webpage'
        else
          'book'
        end
        # rubocop:enable CyclomaticComplexity
        # rubocop:enable Metrics/MethodLength
      end

      def desired_formats
        TrlnArgon::Engine.configuration.citation_formats.split(', ')
      end
    end
  end
end
