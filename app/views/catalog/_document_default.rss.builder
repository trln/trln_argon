xml.item do
  xml.title(document.title_and_responsibility)
  xml.link(polymorphic_url(url_for_document(document)))
end
