# frozen_string_literal: true

# TRLN CUSTOMIZATION: add title & responsibility to <title> tag; omit <author>. See:
# https://github.com/projectblacklight/blacklight/blob/release-8.x/app/views/catalog/_document.rss.builder
xml.item do
  xml.title(document.title_and_responsibility)
  xml.link(polymorphic_url(search_state.url_for_document(document)))
end
