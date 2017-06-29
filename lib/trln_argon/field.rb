module TrlnArgon
  class Field < SimpleDelegator
    attr_reader :solr_name

    def initialize(solr_name)
      @solr_name = solr_name.to_s
      super(@solr_name)
    end

    def label
      I18n.t "#{i18n_base}.label", default: base.gsub(/_facet$/, '').titleize
    end

    private

    def i18n_base
      "trln_argon.fields.#{base}"
    end

    def base
      case solr_name
      when /.*_a$/
        solr_name.gsub(/_a$/, '')
      when /.*_f$/
        solr_name.gsub(/_f$/, '_facet')
      else
        solr_name
      end
    end
  end
end
