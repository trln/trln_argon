module TrlnArgon
  module ControllerOverride
    module ExpandDocumentResults
      extend ActiveSupport::Concern

      def index
        super
        return if local_filter_applied?
        expanded_documents_hash
      end

      private

      def expanded_documents_hash
        @expanded_documents_hash ||= Hash[@response.documents.map { |doc| [doc.id, expanded_documents(doc)] }]
      end

      def expanded_documents(doc)
        group_docs = expanded_documents_response.group(TrlnArgon::Fields::ROLLUP_ID).groups.select do |group|
          group.key == doc[TrlnArgon::Fields::ROLLUP_ID]
        end.first
        group_docs = group_docs.respond_to?(:docs) ? group_docs.docs : [doc]
        Hash[group_docs.map do |gr_doc|
          [gr_doc[TrlnArgon::Fields::INSTITUTION].first, gr_doc]
        end]
      end

      def rollup_ids_from_response
        @rollup_ids_from_response ||= @response.documents.map do |doc|
          doc[TrlnArgon::Fields::ROLLUP_ID]
        end.compact.join(' ')
      end

      def expanded_documents_search_builder
        @expanded_documents_search_builder ||= SearchBuilder.new([:add_query_to_solr], self)
      end

      def expanded_documents_query
        @expanded_documents_query ||= expanded_documents_search_builder
                                      .where("_query_:\"{!q.op=OR df=#{TrlnArgon::Fields::ROLLUP_ID} v=$rollup_ids}\"")
                                      .merge(rollup_ids: rollup_ids_from_response,
                                             group: 'true',
                                             'group.field' => TrlnArgon::Fields::ROLLUP_ID,
                                             'group.limit' => '4',
                                             fl: "#{TrlnArgon::Fields::ID}, #{TrlnArgon::Fields::ROLLUP_ID}, "\
                                                 "#{TrlnArgon::Fields::INSTITUTION}, #{TrlnArgon::Fields::AVAILABLE}, "\
                                                 "#{TrlnArgon::Fields::URLS}")
      end

      def expanded_documents_response
        @expanded_documents_response ||= repository.search(expanded_documents_query)
      end
    end
  end
end
