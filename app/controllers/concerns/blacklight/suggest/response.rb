# frozen_string_literal: true

module Blacklight
  module Suggest
    class Response
      attr_reader :response, :request_params, :suggest_path, :suggest_component

      ##
      # Creates a suggest response
      # @param [RSolr::HashWithResponse] response
      # @param [Hash] request_params
      # @param [String] suggest_path
      # @param [String] suggest_component
      def initialize(response, request_params, suggest_path, suggest_component)
        @response = response
        @request_params = request_params
        @suggest_path = suggest_path
        @suggest_component = suggest_component
      end

      ##
      # Merges the suggest response.
      # @return [Hash]
      def suggestions
        title_suggestions.merge(author_suggestions)
                         .merge(subject_suggestions)
      end

      def title_suggestions
        assemble_suggestions('title')
      end

      def author_suggestions
        assemble_suggestions('author')
      end

      def subject_suggestions
        assemble_suggestions('subject')
      end

      def assemble_suggestions(category)
        suggestions = {}
        suggestions[category] = (response.try(:[], suggest_component)
                                         .try(:[], "#{category}Suggester")
                                         .try(:[], request_params[:q])
                                         .try(:[], 'suggestions') || [])
                                .uniq { |h| h['term'] }
                                .each { |h| h['term'] = "\"#{h['term']}\"" }
                                .each { |h| h['category'] = category }
        suggestions
      end
    end
  end
end
