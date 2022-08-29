module TrlnArgon
  class MetadataListFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent

    def render?
      value.present?
    end
  end
end
