# Add some configurable field sets to Blacklight's Configuration class
# See configurations in lib/trln_argon/controller_override.rb
module Blacklight
  class Configuration
    extend ActiveSupport::Autoload
    eager_autoload do
      autoload :HomeFacetField
      autoload :ShowSubHeaderField
      autoload :ShowAuthorsField
      autoload :ShowSubjectsField
      autoload :ShowIncludedWorksField
      autoload :ShowRelatedWorksField
    end

    define_field_access :home_facet_field, Blacklight::Configuration::HomeFacetField
    define_field_access :show_sub_header_field, Blacklight::Configuration::ShowSubHeaderField
    define_field_access :show_authors_field, Blacklight::Configuration::ShowAuthorsField
    define_field_access :show_subjects_field, Blacklight::Configuration::ShowSubjectsField
    define_field_access :show_included_works_field, Blacklight::Configuration::ShowIncludedWorksField
    define_field_access :show_related_works_field, Blacklight::Configuration::ShowRelatedWorksField
  end
end
