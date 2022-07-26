describe TrlnArgon::ArgonSearchBuilder::AdvancedSearchCleanup do
  let :solr_parameters do
    {
      # a real search, nonsense but a hard case anyhow
      fq: [
        '{!lucene}{!query v=$f_inclusive.date_cataloged_dt.0} OR {!query v=$f_inclusive.date_cataloged_dt.1}',
        'date_cataloged_dt:(\"last_week\" OR  \"last_three_months\")',
        'institution_f:unc'
      ]
    }
  end

  let(:instance) do
    config = Blacklight::Configuration.new
    config.add_home_facet_field(
      TrlnArgon::Fields::DATE_CATALOGED_FACET.to_s,
      query: {
        'last_week' => { label: 'Last Week',
                          fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-7DAY/DAY TO NOW]" },
        'last_month' => { label: 'Last Month',
                          fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-1MONTH/DAY TO NOW]" },
        'last_three_months' => { label: 'Last Three Months',
                                fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-3MONTH/DAY TO NOW]" }
      },
      label: TrlnArgon::Fields::DATE_CATALOGED_FACET.label,
      limit: true
    )

    stub_const('Dummy', Class.new)
    # wants to use `described_class` but it's out of scope here
    # rubocop:disable RSpec/DescribedClass
    Dummy.class_eval do
      include TrlnArgon::ArgonSearchBuilder::AdvancedSearchCleanup
      attr_accessor :blacklight_config
    end
    # rubocop:enable RSpec/DescribedClass

    val = Dummy.new
    val.blacklight_config = config
    val
  end

  it 'removes aliased date range query parameters' do
    params = solr_parameters
    instance.send(:remove_facet_convenience_values, params)
    expect(params).to satisfy('no valid date cataloged params') do |p|
      p.grep(/^date_cataloged_dt:/).empty?
    end
  end
end
