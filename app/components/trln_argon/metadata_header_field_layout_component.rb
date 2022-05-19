module TrlnArgon
  class MetadataHeaderFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    renders_one :value
    def render?
      return false if value&.to_s.blank?

      value.present? && !value.blank?
    end
  end
end
