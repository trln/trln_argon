module TrlnArgon
  module SolrDocument
    module Urls
      # All the desererlized URL data. No filtering or param substitution applied.
      def urls
        @urls ||= deserialized_urls
      end

      # All the local fulltext URLs. (Excludes Shared URLs that require param substitution)
      def fulltext_urls
        @fulltext_urls ||= select_urls('fulltext').reject { |url| url[:href].match(/\{[A-Za-z0-9]*\}/) }
      end

      # Shared fulltext URLs with params substituted for the local institution only.
      def shared_fulltext_urls
        inst = TrlnArgon::Engine.configuration.local_institution_code
        templated_fulltext_shared_urls.each { |url| url[:href] = url_template_subst(url[:href], inst) }
      end

      # Shared fulltext URLs with params substituted as needed for
      # each institution that has access.
      # e.g. { 'duke' => [{}, {}}], 'unc' => [{}, {}] }
      def expanded_shared_fulltext_urls
        @expanded_shared_fulltext_urls ||=
          fetch(TrlnArgon::Fields::INSTITUTION, []).map { |inst| [inst, templated_fulltext_shared_urls] }
                                                   .to_h
                                                   .map { |inst, urls| inst_urls_pairs(urls, inst) }
                                                   .to_h
      end

      def findingaid_urls
        @findingaid_urls ||= select_urls('findingaid')
      end

      def thumbnail_urls
        @thumbnail_urls ||= select_urls('thumbnail')
      end

      def secondary_urls
        @secondary_urls ||= related_urls.concat other_urls
      end

      def related_urls
        @related_urls ||= select_urls('related')
      end

      def other_urls
        @other_urls ||= select_urls('other')
      end

      private

      def select_urls(type)
        urls.select { |url| url[:type] == type }
      end

      def deserialized_urls
        deserialize_solr_field(TrlnArgon::Fields::URLS,
                               { href: '', type: '', text: '' },
                               :href)
      end

      def inst_urls_pairs(urls, inst)
        [inst, urls.each { |url| url[:href] = url_template_subst(url[:href], inst) }]
      end

      def templated_fulltext_shared_urls
        deserialized_urls.select { |url| url[:href].match(/\{[A-Za-z0-9]*\}/) && url[:type] == 'fulltext' }
      end

      def url_template_subst(href, inst)
        href.scan(/\{[A-Za-z0-9]*\}/)
            .map { |template_code| [template_code, config_lookup(template_code, inst)] }
            .to_h
            .each { |template_code, config_value| href.gsub!(template_code, config_value) }
        href
      end

      def config_lookup(template_code, inst)
        lookup_path = [inst,
                       'url_template',
                       template_code[1...-1]].join('.')
        TrlnArgon::LookupManager.instance.map(lookup_path)
      end
    end
  end
end
