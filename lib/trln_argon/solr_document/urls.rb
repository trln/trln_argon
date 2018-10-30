module TrlnArgon
  module SolrDocument
    module Urls
      def urls
        @urls ||= deserialized_urls.each { |url| url[:href] = url_template_subst(url[:href]) }
      end

      def deserialized_urls
        @deserialized_urls ||= deserialize_solr_field(TrlnArgon::Fields::URLS,
                                                      { href: '', type: '', text: '' },
                                                      :href)
      end

      def fulltext_urls
        @fulltext_urls ||= select_urls('fulltext')
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

      def url_template_subst(href)
        href.scan(/\{[A-Za-z0-9]*\}/)
            .map { |p| [p, url_template_mapper(p)] }
            .to_h
            .each { |p, r| href.gsub!(p, r) }
        href
      end

      def url_template_mapper(template)
        lookup_path = [TrlnArgon::Engine.configuration.local_institution_code,
                       'url_template',
                       template[1..-2]].join('.')
        val = TrlnArgon::LookupManager.instance.map(lookup_path)
        val.present? ? val : lookup_path
      end
    end
  end
end
