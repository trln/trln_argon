require 'trln_argon/argon_search_builder/add_query_to_solr'
require 'trln_argon/argon_search_builder/begins_with'
require 'trln_argon/argon_search_builder/local_filter'

module TrlnArgon
  # Shared SearchBuilder behaviors concerning record rollup,
  # local record filtering, and ISxN match boosting.
  module ArgonSearchBuilder
    include AddQueryToSolr
    include BeginsWith
    include LocalFilter
  end
end
