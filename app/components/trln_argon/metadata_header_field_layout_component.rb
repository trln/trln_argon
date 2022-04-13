module TrlnArgon
  class MetadataHeaderFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    def render?
      value.present?
    end
  end
end
