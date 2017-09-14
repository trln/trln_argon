module TrlnArgon
  module Fields
    def self.solr_field_names
      constants.map { |v| "TrlnArgon::Fields::#{v}".constantize }
    end
  end
end
