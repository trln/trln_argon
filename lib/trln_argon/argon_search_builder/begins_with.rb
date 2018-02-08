module TrlnArgon
  module ArgonSearchBuilder
    module BeginsWith
      def begins_with_filter(solr_parameters)
        return unless blacklight_params[:begins_with].present?
        solr_parameters[:fq] ||= []
        solr_parameters[:fq].concat begins_with_queries(blacklight_params[:begins_with])
      end

      private

      def begins_with_queries(begins_with)
        queries = []
        begins_with.each do |field, segments|
          segments.reject!(&:empty?)
          next if segments.empty?
          queries << begins_with_query(field, segments)
        end
        queries
      end

      def begins_with_query(field, segments)
        "_query_:\"{!q.op=AND df=#{field}}#{join_begins_with_segments(segments)}\""
      end

      def join_begins_with_segments(segments)
        segments.map { |segment| "/#{solr_regex_escape(segment)}.*/" }.join(' ')
      end

      def solr_regex_escape(segment)
        segment.gsub(%r([\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\\/])) { |s| "\\\\#{s}" }
      end
    end
  end
end
