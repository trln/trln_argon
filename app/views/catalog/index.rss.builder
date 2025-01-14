# frozen_string_literal: true

# TRLN CUSTOMIZATION: Fix link to catalog. See:
# https://github.com/projectblacklight/blacklight/blob/release-8.x/app/views/catalog/index.rss.builder
xml.instruct! :xml, version: '1.0'
xml.rss(version: '2.0') do
  xml.channel do
    xml.title(t('blacklight.search.page_title.title', constraints: render_search_to_page_title(params),
application_name: application_name))
    # BL core renders <link> with catalog.rss, so we fix it here
    # xml.link(search_action_url(search_state.to_h.merge(only_path: false)))
    xml.link(search_action_url(params.merge(format: '').to_unsafe_h))
    xml.description(t('blacklight.search.page_title.title', constraints: render_search_to_page_title(params),
application_name: application_name))
    xml.language('en-us')
    @response.documents.each_with_index do |document, document_counter|
      xml << render_xml_partials(document, blacklight_config.view_config(:rss).partials,
                                 document_counter: document_counter)
    end
  end
end
