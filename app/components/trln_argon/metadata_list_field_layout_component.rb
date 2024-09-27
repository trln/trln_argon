module TrlnArgon
  class MetadataListFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    def initialize(field:, label_class: 'visually-hidden', value_class: '')
      super
      @field = field
      @key = @field.key.parameterize
      @label_class = label_class
      @value_class = value_class
    end
  end
end
