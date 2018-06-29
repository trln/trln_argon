describe TrlnArgon::ArgonSearchBuilder do
  let(:solr_parameters) { Blacklight::Solr::Request.new }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:user_params) { {} }
  let(:context) { CatalogController.new }
  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder) do
      include Blacklight::Solr::SearchBuilderBehavior
      include TrlnArgon::ArgonSearchBuilder
    end
  end
  let(:search_builder) { search_builder_class.new(context) }

  describe 'show_only_local_holdings' do
    before { search_builder.show_only_local_holdings(solr_parameters) }
    it 'adds parameters to restrict results to local holdings' do
      expect(solr_parameters[:fq]).to(
        eq(['institution_f:unc OR institution_f:trln'])
      )
    end
  end

  describe 'rollup_duplicate_records' do
    before { search_builder.rollup_duplicate_records(solr_parameters) }
    it 'adds parameters to rollup duplicate records' do
      expect(solr_parameters[:fq]).to(
        eq(['{!collapse field=rollup_id nullPolicy=expand max=termfreq(institution_f,"unc")}'])
      )
    end
  end

  describe 'begins_with_filter' do
    let(:builder_with_params) { search_builder.with(begins_with: { subject_f: ['Technology -- History'] }) }

    before { builder_with_params.begins_with_filter(solr_parameters) }
    it 'applies the local holdings query' do
      expect(solr_parameters[:fq]).to(
        eq(['_query_:"{!q.op=AND df=subject_f}/Technology \\\\-\\\\- History.*/"'])
      )
    end
  end
end
