module TrlnArgon
  module SolrDocument
    module Urls
      def urls
        @urls ||= deserialize_solr_field(TrlnArgon::Fields::URLS,
                                         { href: '', type: '', text: '' },
                                         :href)
      end

      def fulltext_urls
        @fulltext_urls ||= select_urls('fulltext')
      end

      def findingaid_urls
        @findingaid_urls ||= select_urls('finding_aid')
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
    end
  end
end
