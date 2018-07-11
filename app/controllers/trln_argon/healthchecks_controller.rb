require_dependency 'trln_argon/application_controller'

module TrlnArgon
  class HealthchecksController < ::ApplicationController
    @cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 3.minutes)

    def index
      result = self.class.ping
      if result.nil?
        render json: { status: 'FAILED' }, status: 500
      else
        count = begin
                  result['response']['numFound'] 
                rescue StandardError
                  'unknown'
                end
        render json: { status: 'OK', count: count }
      end
    end

    def self.ping
      @cache.fetch(:ping) do
        begin
          solr = ENV['SOLR_URL']
          return nil unless solr
          (RSolr.connect url: solr).get('select', params: { rows: 0 })
        rescue StandardError
          nil
        end
      end
    end
  end
end
