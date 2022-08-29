module TrlnArgon
  class MetadataFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent

    # @param field [Blacklight::FieldPresenter]
    def initialize(field:, label_class: '', value_class: '')
      @field = field
      @key = @field.key.parameterize
      @label_class = label_class
      @value_class = value_class
    end

    def render?
      value.present?
    end
  end
end
