describe 'Routing' do
  it "maps { :controller => 'catalog', :action => 'show', :id => NCSU3724376 } to /catalog/NCSU3724376" do
    expect(get: '/catalog/NCSU3724376').to route_to(controller: 'catalog', action: 'show', id: 'NCSU3724376')
  end

  it 'routes a SolrDocument correctly' do
    expect(get: solr_document_path(SolrDocument.new(id: 'NCSU3724376'))).to(
      route_to(controller: 'catalog', action: 'show', id: 'NCSU3724376')
    )
  end
end
