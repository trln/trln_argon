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
        'statement_of_responsibility_a' => 'author',
        'note_general_a' => 'note',
        'isbn_number_a' => 'number',
        'physical_description_a' => 'pages',
        'publisher_a' => 'publisher',
        'resource_type_a' => 'type',
        'edition_a' => 'edition',
        'address' => 'publisher_location_a'
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
        MAPPING.each_with_object([]) do |(k, v), o|
          docvalue = fetch(k, [])
          process_docvalue(o, v, docvalue) unless docvalue.empty?
        end
      end

      def convert_to_bibtex_format(input)
        identifier = input.detect { |key, _| key == "id" }[1]
        entry_type = input.detect { |key, _| key == "type" }[1].split(',').first.strip.downcase
        entry_type = map_entry_type(entry_type)
        
        # The bibtex string should look like this
        # "@book{id, author = {Author, A.}, title = {Title}, journal = {Journal}, year = {2020}}"
        formatted_pairs = input.reject { |key, _| key == "id" || key == "type" }.map do |key, value|
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
          citation_hash[format_display_name(format)] = citation
        end
      end

      def format_display_name(format)
        case format
        when 'apa'
          'APA'
        when 'modern-language-association'
          'MLA'
        when 'chicago-fullnote-bibliography'
          'Chicago'
        when 'harvard-cite-them-right'
          'Harvard'
        when 'turabian-fullnote-bibliography'
          'Turabian'
        else
          format
        end
      end

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
      end 

      def desired_formats
        %w[apa modern-language-association chicago-fullnote-bibliography harvard-cite-them-right turabian-fullnote-bibliography]
      end
    end
  end
end
