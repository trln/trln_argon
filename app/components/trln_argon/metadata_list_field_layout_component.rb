module TrlnArgon
  class MetadataListFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    renders_one :value
    def render?
      value.present?
    end
  end
end
