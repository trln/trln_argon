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
        eq(['institution_f:unc'])
      )
    end
  end

  describe 'rollup_duplicate_records' do
    before { search_builder.rollup_duplicate_records(solr_parameters) }
    it 'adds an fq parameter to rollup duplicate records' do
      expect(solr_parameters[:fq]).to(
        eq(['{!tag=rollup}{!collapse field=rollup_id nullPolicy=expand max=termfreq(institution_f,"unc")}'])
      )
    end

    it 'sets expand parameter to true' do
      expect(solr_parameters[:expand]).to eq 'true'
    end
    it 'sets expand.rows to 50' do
      expect(solr_parameters['expand.rows']).to eq 50
    end

    it 'sets expand.q to *:*' do
      expect(solr_parameters['expand.q']).to eq '*:*'
    end
  end

  describe 'remove_params_for_count_only_query' do
    before { search_builder.remove_params_for_count_only_query(solr_parameters) }
    it 'removes the stats solr parameters' do
      expect(solr_parameters).not_to include('stats')
    end

    it 'removes the stats.field solr parameters' do
      expect(solr_parameters).not_to include('stats.field')
    end

    it 'removes the expand solr parameters' do
      expect(solr_parameters).not_to include('expand')
    end

    it 'removes the expand.rows parameters' do
      expect(solr_parameters).not_to include('expand.rows')
    end

    it 'removes the expand.q parameters' do
      expect(solr_parameters).not_to include('expand.q')
    end
  end

  describe 'wildcard_char_strip' do
    before do
      builder_with_params.add_query_to_solr(solr_parameters)
      builder_with_params.wildcard_char_strip(solr_parameters)
    end

    context 'query contains question marks' do
      let(:builder_with_params) { search_builder.with(q: 'What? Will? Humans? Do?') }

      it 'removes question marks from the query' do
        expect(solr_parameters[:q]).to eq('What Will Humans Do')
      end
    end
  end

  describe 'min_match_for_boolean' do
    before { builder_with_params.min_match_for_boolean(solr_parameters) }

    context 'query contains a boolean operator' do
      let(:builder_with_params) { search_builder.with(q: 'deforestation AND (columbia OR ecuador)') }

      it 'applies the min match setting for boolean searches' do
        expect(solr_parameters[:mm]).to eq('1')
      end
    end

    context 'query does not contain any boolean operators' do
      let(:builder_with_params) { search_builder.with(q: 'deforestation columbia ecuador)') }

      it 'applies the min match setting for boolean searches' do
        expect(solr_parameters[:mm]).to be_nil
      end
    end
  end

  describe 'min_match_for_cjk' do
    before { builder_with_params.min_match_for_cjk(solr_parameters) }

    context 'query contains only cjk characters' do
      let(:builder_with_params) { search_builder.with(q: '阎连科') }

      it 'uses the base cjk mm value' do
        expect(solr_parameters[:mm]).to eq('3<86%')
      end
    end

    context 'query contains both cjk and non-cjk characters' do
      let(:builder_with_params) { search_builder.with(q: '毛沢東 dai') }

      it 'requires all non-cjk tokens' do
        expect(solr_parameters[:mm]).to eq('4<86%')
      end
    end

    context 'query does not contain cjk characters' do
      let(:builder_with_params) { search_builder.with(q: "je vais à l'école en bus") }

      it 'does not set the mm value' do
        expect(solr_parameters[:mm]).to be_nil
      end
    end
  end
end
