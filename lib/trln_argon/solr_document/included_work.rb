module TrlnArgon
  module SolrDocument
    module IncludedWork
      def included_work
        @included_work ||= add_progressive_linking_data(
          deserialize_solr_field(TrlnArgon::Fields::INCLUDED_WORK,
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
