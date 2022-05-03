module TrlnArgon
  class MetadataHeaderFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    renders_one :value
    def render?
      value.present?
    end
  end
end
