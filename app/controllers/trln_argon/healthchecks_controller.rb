require_dependency 'trln_argon/application_controller'

module TrlnArgon
  class HealthchecksController < ::ApplicationController
    @cache = ActiveSupport::Cache::MemoryStore.new

    def index
      result = self.class.ping
      if result.nil?
        render json: { status: 'FAILED' }, status: 500
      else
        count = result['response']['numFound'] rescue 'unknown'
        render json: { status: 'OK', count: count }
      end
    end

    def self.ping
      @cache.fetch(:ping) do
        begin
          solr = ENV['SOLR_URL']
          (RSolr.connect url: solr).get('select', params: { rows: 0 })
        rescue StandardError
          nil
        end
      end
    end
  end
end
