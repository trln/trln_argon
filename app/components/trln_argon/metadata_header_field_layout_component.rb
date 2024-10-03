module TrlnArgon
  class MetadataHeaderFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    def initialize(field:, label_class: 'visually-hidden', value_class: '')
      super
      @field = field
      @key = @field.key.parameterize
      @label_class = label_class
      @value_class = value_class
    end

    # values is an Array of ViewComponent::SlotV2
    # objects, each containing html markup, some with only
    # \n for content. So this requires gymnastics.
    def render?
      values.map(&:to_s)
            .map { |v| strip_tags(v).squish }
            .compact_blank.present?
    end
  end
end
