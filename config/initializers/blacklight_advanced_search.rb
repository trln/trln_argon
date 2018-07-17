# Yet another Solr 7 BL compatibility hack.
# Forces BL Advanced Search to specify
# local params query type as edismax.
module BlacklightAdvancedSearch
  class QueryParser
    # rubocop:disable ClassAndModuleChildren
    module ParsingNesting::Tree
      class Node
        def build_local_params(hash = {}, _force_deftype = 'edismax')
          puts hash.inspect
          if !hash.empty?
            '{!edismax ' + hash.collect { |k, v| "#{k}=#{v.to_s.include?(' ') ? "'" + v + "'" : v}" }.join(' ') + '}'
          else
            # still have to set edismax
            '{!edismax}'
          end
        end
      end
    end
  end
end
