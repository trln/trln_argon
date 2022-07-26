module TrlnArgon
  module ArgonSearchBuilder
    # when an advanced search is issued, the query is likely to contain
    # 'friendly' values for various facets displayed on the home page (e.g.
    # `last_week` for freshly cataloged items)
    module AdvancedSearchCleanup
      def facetize_advanced_search_fields(solr_parameters)
        return unless blacklight_params[:search_field] == 'advanced'

        remove_facet_convenience_values(solr_parameters)
      end

      private

      MAPPED_FIELDS = Set.new([TrlnArgon::Fields::DATE_CATALOGED_FACET.to_s])

      def mapped?(field_name)
        MAPPED_FIELDS.include?(field_name)
      end

      def home_facet_config
        blacklight_config.home_facet_fields
      end

      # advanced search will often add the 'convenience' value (e.g. `last_week`)
      # as the value of a facet, but with a little extra escaping, e.g.
      # `date_cataloged_dt:(\"last_week\")`
      def remove_facet_convenience_values(solr_parameters)
        solr_parameters[:fq] = solr_parameters[:fq].map { |k| process_parameter(k) }.compact
      end

      def process_parameter(param)
        solr_field, solr_value = param.split(':')
        return param unless mapped?(solr_field)

        cf = home_facet_config[solr_field]
        mapped_values = cf&.query&.keys || []
        parsed = parse_parameter_value(solr_value)
        valid = parsed[:values].reject { |v| mapped_values.include?(param_literal(v)) }
        valid.length.positive? ? "#{solr_field}:#{reassemble(valid, parsed[:connector])}" : nil
      end

      def parse_parameter_value(solr_param)
        parts = solr_param.split(/ (AND|OR) /)
        if parts.length >= 3
          vals = parts.each_slice(2).map(&:first)
          return { values: vals, connector: parts[1] }
        end
        { values: [parts[0]] }
      end

      def param_literal(value)
        value&.gsub(/[\W: \[\]]/, '')
      end

      def requote_param(param)
        param.include?('[') ? param : "\"#{param}\""
      end

      def reassemble(params, connector)
        "(#{params.map { |v| requote_param(v) }.join(" #{connector} ")})"
      end
    end
  end
end
