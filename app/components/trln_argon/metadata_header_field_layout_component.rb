module TrlnArgon
  class MetadataHeaderFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    renders_one :value
    def render?
      # value is actually a ViewComponent::SlotV2 and is probably
      # not nil? 
      !(value&.to_s.blank?)
    end
  end
end
