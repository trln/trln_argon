module TrlnArgon
  class MetadataHeaderFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent

    # rubocop:disable Style/RedundantParentheses
    def render?
      # value is actually a ViewComponent::SlotV2 and is probably
      # not nil?
      # Rubocop lies, I find this clearer
      !(value&.to_s.blank?)
    end
    # rubocop:enable Style/RedundantParentheses
  end
end
