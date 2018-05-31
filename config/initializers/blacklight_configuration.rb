# Add some configurable field sets to Blacklight's Configuration class
# See configurations in lib/trln_argon/controller_override.rb
module Blacklight
  class Configuration
    define_field_access :show_sub_header_field
    define_field_access :show_authors_field
    define_field_access :show_subjects_field
    define_field_access :show_included_works_field
    define_field_access :show_related_works_field
  end
end
