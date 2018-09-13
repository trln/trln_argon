# frozen_string_literal: true

module Blacklight
  class SuggestSearch
    attr_reader :request_params, :category, :repository

    ##
    # @param [Hash] params
    def initialize(params, category, repository)
      @request_params = { q: params[:q] }
      @category = category
      @repository = repository
    end

    ##
    # For now, only use the q parameter to create a
    # Blacklight::Suggest::Response
    # @return [Blacklight::Suggest::Response]
    def suggestions
      Blacklight::Suggest::Response.new suggest_results,
                                        request_params,
                                        suggest_handler_path,
                                        suggest_component
    end

    ##
    # Query the suggest handler using RSolr::Client::send_and_receive
    # @return [RSolr::HashWithResponse]
    def suggest_results
      repository.connection.send_and_receive(suggest_handler_path, params: request_params)
    end

    def suggest_component
      repository.blacklight_config.autocomplete_solr_component
    end

    ##
    # @return [String]
    def suggest_handler_path
      case category
      when 'title'
        repository.blacklight_config.autocomplete_path_title
      when 'author'
        repository.blacklight_config.autocomplete_path_author
      when 'subject'
        repository.blacklight_config.autocomplete_path_subject
      else
        repository.blacklight_config.autocomplete_path
      end
    end
  end
end
