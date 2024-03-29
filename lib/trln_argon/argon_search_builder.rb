require 'trln_argon/argon_search_builder/add_query_to_solr'
require 'trln_argon/argon_search_builder/add_solr_debug_info'
require 'trln_argon/argon_search_builder/author_boost'
require 'trln_argon/argon_search_builder/disable_boolean_for_all_caps'
require 'trln_argon/argon_search_builder/count_only'
require 'trln_argon/argon_search_builder/home_facets'
require 'trln_argon/argon_search_builder/local_filter'
require 'trln_argon/argon_search_builder/min_match'
require 'trln_argon/argon_search_builder/subjects_boost'
require 'trln_argon/argon_search_builder/wildcard_char_strip'
require 'trln_argon/argon_search_builder/share_bookmarks'
require 'trln_argon/argon_search_builder/clause_count'

module TrlnArgon
  # Shared SearchBuilder behaviors concerning record rollup,
  # local record filtering, etc.
  module ArgonSearchBuilder
    include AddQueryToSolr
    include AddSolrDebugInfo
    include AuthorBoost
    include DisableBooleanForAllCaps
    include CountOnly
    include HomeFacets
    include LocalFilter
    include MinMatch
    include SubjectsBoost
    include WildcardCharStrip
    include ShareBookmarks
    include ClauseCount
  end
end
