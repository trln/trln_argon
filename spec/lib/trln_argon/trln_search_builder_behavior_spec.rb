describe TrlnArgon::TrlnSearchBuilderBehavior do
  let(:solr_parameters) { Blacklight::Solr::Request.new }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:user_params) { {} }
  let(:context) { CatalogController.new }
  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder) do
      include Blacklight::Solr::SearchBuilderBehavior
      include TrlnArgon::TrlnSearchBuilderBehavior
    end
  end
  let(:search_builder) { search_builder_class.new(context) }

  before { allow(context).to receive(:blacklight_config).and_return(blacklight_config) }

  describe 'apply_local_filter' do
    context 'when local filter is applied' do
      let(:builder_with_params) { search_builder.with(local_filter: 'true') }

      before { builder_with_params.apply_local_filter(solr_parameters) }

      it 'applies the local holdings query' do
        expect(solr_parameters[:fq]).to(
          eq(['institution_f:unc OR institution_f:trln'])
        )
      end
    end

    context 'when local filter is not applied' do
      let(:builder_with_params) { search_builder.with(local_filter: 'false') }

      before { builder_with_params.apply_local_filter(solr_parameters) }

      it 'applies the local holdings query' do
        expect(solr_parameters[:fq]).to(
          eq(['{!collapse field=rollup_id nullPolicy=expand max=termfreq(institution_f,"unc")}'])
        )
      end
    end
  end

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

  describe 'boost_isxn_matches' do
    before { builder_with_params.boost_isxn_matches(solr_parameters) }

    context 'when all fields search contains an issn search' do
      let(:builder_with_params) { search_builder.with(q: '03431258') }

      it 'sets the isxn_ns_v parameter' do
        expect(solr_parameters[:isxn_ns_v]).to eq('03431258')
      end

      it 'sets the isxn_v parameter' do
        expect(solr_parameters[:isxn_v]).to eq('03431258')
      end

      it 'sets the q parameter' do
        expect(solr_parameters[:q]).to(
          eq([' _query_:"{!edismax qf=$isbn_issn_qf v=$isxn_v}"^2',
              ' _query_:"{!edismax qf=$isbn_issn_qf v=$isxn_ns_v}"^2'])
        )
      end
    end

    context 'when all fields search contains a messy isbn search' do
      let(:builder_with_params) { search_builder.with(q: '98---121     00822') }

      it 'sets the isxn_ns_v parameter' do
        expect(solr_parameters[:isxn_ns_v]).to eq('9789812100825')
      end

      it 'sets the isxn_v parameter' do
        expect(solr_parameters[:isxn_v]).to be_nil
      end

      it 'sets the q parameter' do
        expect(solr_parameters[:q]).to(
          eq([' _query_:"{!edismax qf=$isbn_issn_qf v=$isxn_ns_v}"^2'])
        )
      end
    end

    context 'when all fields search with multiple isxn values and random text' do
      let(:builder_with_params) { search_builder.with(q: 'alexander and the terrible 9812100822 03431258') }

      it 'sets the isxn_ns_v parameter' do
        expect(solr_parameters[:isxn_ns_v]).to be_nil
      end

      it 'sets the isxn_v parameter' do
        expect(solr_parameters[:isxn_v]).to eq('9789812100825 03431258')
      end

      it 'sets the q parameter' do
        expect(solr_parameters[:q]).to(
          eq([' _query_:"{!edismax qf=$isbn_issn_qf v=$isxn_v}"^2'])
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
end
