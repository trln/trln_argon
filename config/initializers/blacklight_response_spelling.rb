# rubocop:disable ClassAndModuleChildren
class Blacklight::Solr::Response
  module Blacklight::Solr::Response::Spelling
    class Base
      def collation
        spellcheck = response[:spellcheck]
        return unless spellcheck && spellcheck[:collations]

        collations = spellcheck[:collations]

        # solution for Solr 7.7
        collations.delete('collation')
        collations
      end
    end
  end
end
