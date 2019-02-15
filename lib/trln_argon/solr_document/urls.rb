module TrlnArgon
  module SolrDocument
    module Urls
      # All the desererlized URL data. No filtering or param substitution applied.
      def urls
        @urls ||= deserialized_urls
      end

      # All the restricted and local fulltext URLs.
      # Excludes Shared URLs that require param substitution
      # Excludes URLs that are set to restricted: false
      def fulltext_urls
        @fulltext_urls ||= select_urls('fulltext').reject do |url|
          url_has_variables?(url[:href]) ||
            url.fetch(:restricted, 'true') == 'false'
        end
      end

      # Fulltext URLs that are marked as restricted: false
      def open_access_urls
        @open_access_urls ||= select_urls('fulltext').select do |url|
          url.fetch(:restricted, 'true') == 'false'
        end
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
                               { href: '', type: '', text: '', note: '' },
                               :href)
      end

      def inst_urls_pairs(urls, inst)
        [inst, urls.each { |url| url[:href] = url_template_subst(url[:href], inst) }]
      end

      def templated_fulltext_shared_urls
        deserialized_urls.select do |url|
          url_has_variables?(url[:href]) && url[:type] == 'fulltext'
        end
      end

      def url_has_variables?(url)
        Addressable::Template.new(url).variables.any?
      rescue RegexpError => e
        Rails.logger.warn('unable to parse URL template for '\
                          "#{fetch('id', 'unknown document')}: #{e}")
        false
      end

      def url_template_subst(href, inst)
        template_values = config_lookup(inst)
        uri_template = Addressable::Template.new(href)
        uri_template.expand(template_values).to_s
      end

      def config_lookup(inst)
        TrlnArgon::LookupManager.instance.map([inst, 'url_template'].join('.'))
      end
    end
  end
end
