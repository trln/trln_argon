module TrlnArgon
  module SolrDocument
    module WorkEntry
      def included_work
        @included_work ||= deserialize_work_entry(TrlnArgon::Fields::INCLUDED_WORK)
      end

      def related_work
        @related_work ||= deserialize_work_entry(TrlnArgon::Fields::RELATED_WORK)
      end

      def this_work
        @this_work ||= deserialize_work_entry(TrlnArgon::Fields::THIS_WORK)
      end

      def series_work
        @series_work ||= deserialize_work_entry(TrlnArgon::Fields::SERIES_WORK)
      end

      def subseries_work
        @subseries_work ||= deserialize_work_entry(TrlnArgon::Fields::SUBSERIES_WORK)
      end

      def translation_of_work
        @translation_of_work ||= deserialize_work_entry(TrlnArgon::Fields::TRANSLATION_OF_WORK)
      end

      def translated_as_work
        @translated_as_work ||= deserialize_work_entry(TrlnArgon::Fields::TRANSLATED_AS_WORK)
      end

      def has_supplement_work # rubocop:disable Style/PredicateName
        @has_supplement_work ||= deserialize_work_entry(TrlnArgon::Fields::HAS_SUPPLEMENT_WORK)
      end

      def has_supplement_to_work # rubocop:disable Style/PredicateName
        @has_supplement_to_work ||= deserialize_work_entry(TrlnArgon::Fields::HAS_SUPPLEMENT_TO_WORK)
      end

      def host_item_work
        @host_item_work ||= deserialize_work_entry(TrlnArgon::Fields::HOST_ITEM_WORK)
      end

      def alt_edition_work
        @alt_edition_work ||= deserialize_work_entry(TrlnArgon::Fields::ALT_EDITION_WORK)
      end

      def issued_with_work
        @issued_with_work ||= deserialize_work_entry(TrlnArgon::Fields::ISSUED_WITH_WORK)
      end

      def earlier_work
        @earlier_work ||= deserialize_work_entry(TrlnArgon::Fields::EARLIER_WORK)
      end

      def later_work
        @later_work ||= deserialize_work_entry(TrlnArgon::Fields::LATER_WORK)
      end

      def data_source_work
        @data_source_work ||= deserialize_work_entry(TrlnArgon::Fields::DATA_SOURCE_WORK)
      end

      private

      def deserialize_work_entry(field)
        add_progressive_linking_data(
          deserialize_solr_field(field,
                                 label: '',
                                 author: '',
                                 title: [],
                                 title_variation: '',
                                 details: '',
                                 isbn: [],
                                 issn: '')
        )
      end

      def add_progressive_linking_data(deserialized_data)
        deserialized_data.map do |work_entry|
          work_entry[:title_linking] = build_linking_structure(work_entry)
          work_entry
        end
      end

      def build_linking_structure(work_entry)
        work_entry[:title].map.with_index do |_, i|
          entry = { params: {}, display_segments: [] }

          unless work_entry[:author].empty?
            entry[:params][:author] = work_entry[:author]
            entry[:display_segments] << work_entry[:author]
          end

          entry[:params][:title] = work_entry[:title][0..i].join(' ')
          entry[:display_segments].concat(work_entry[:title][0..i])
          entry
        end
      end
    end
  end
end
