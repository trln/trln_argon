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

  # rubocop:disable RSpec/NestedGroups
  describe 'clause_count' do
    context 'when query truncation is not turned on via config' do
      before do
        TrlnArgon::Engine.configuration.enable_query_truncation = ''
        builder_with_params.add_query_to_solr(solr_parameters)
        builder_with_params.clause_count(solr_parameters)
      end
      let(:builder_with_params) do
        search_builder.with(
          q: 'One two three four five six seven eight nine ten eleven twelve',
          'search_field' => 'all_fields'
        )
      end

      it 'does not truncate the query at 10 terms' do
        expect(solr_parameters[:q]).to eq('One two three four five six seven eight nine ten eleven twelve')
      end
    end

    context 'when query truncation is turned on via config' do
      before do
        TrlnArgon::Engine.configuration.enable_query_truncation = 'true'
        builder_with_params.add_query_to_solr(solr_parameters)
        builder_with_params.clause_count(solr_parameters)
      end

      context 'All fields search: query contains more than 10 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'One two three four five six seven eight nine ten eleven twelve',
            'search_field' => 'all_fields'
          )
        end

        it 'truncates query at 10 terms' do
          expect(solr_parameters[:q]).to eq('One two three four five six seven eight nine ten')
        end
      end

      context 'All fields search: query contains less than 10 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'One two three four five six seven eight nine',
            'search_field' => 'all_fields'
          )
        end

        it 'does not truncate query at 10 terms' do
          expect(solr_parameters[:q]).to eq('One two three four five six seven eight nine')
        end
      end

      context 'All fields search: query contains more than 10 terms and two colons' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'One two three four five : six seven eight nine ten : one',
            'search_field' => 'all_fields'
          )
        end

        it 'truncates query at 10 terms' do
          expect(solr_parameters[:q]).to eq('One two three four five \\: six seven eight nine ten')
        end
      end

      context 'All fields search: query contains an apostrophe and -' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'Fanaroff and Martin’s Neonatal-perinatal medicine: Diseases of the fetus and infant',
            'search_field' => 'all_fields'
          )
        end

        it 'truncates query at 10 terms' do
          expect(solr_parameters[:q]).to eq('Fanaroff and Martin’s Neonatal-perinatal medicine: Diseases of the')
        end
      end

      context 'Title search: query contains more than 19 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'One two three four five six seven eight nine ten One two three four five six seven eight nine ten',
            'search_field' => 'title'
          )
        end

        it 'truncates query at 19 terms' do
          expect(solr_parameters[:q]).to eq('{!edismax qf=$title_qf pf=$title_pf pf3=$title_pf3 pf2=$title_pf2}'\
            'One two three four five six seven eight nine ten '\
            'One two three four five six seven eight nine')
        end
      end

      context 'Title search: query contains less than 19 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18',
            'search_field' => 'title'
          )
        end

        it 'does not truncate query at 19 terms' do
          expect(solr_parameters[:q]).to eq('{!edismax qf=$title_qf pf=$title_pf pf3=$title_pf3 pf2=$title_pf2}'\
            '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18')
        end
      end

      context 'Title search: query contains an apostrophe and -' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'Fanaroff and Martin’s Neonatal-perinatal medicine: Diseases of the fetus '\
            'and infant Fanaroff and Martin’s Neonatal-perinatal medicine: Diseases of the fetus and infant',
            'search_field' => 'title'
          )
        end

        it 'truncates query at 19 terms' do
          expect(solr_parameters[:q]).to eq('{!edismax qf=$title_qf pf=$title_pf pf3=$title_pf3 pf2=$title_pf2}'\
            'Fanaroff and Martin’s Neonatal-perinatal medicine: Diseases of the fetus '\
            'and infant Fanaroff and Martin’s Neonatal-perinatal')
        end
      end

      context 'Author search: query contains more than 27 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'One two three four five six seven eight nine ten '\
            'One two three four five six seven eight nine ten '\
            'One two three four five six seven eight nine ten',
            'search_field' => 'author'
          )
        end

        it 'truncates query at 27 terms' do
          expect(solr_parameters[:q]).to eq('{!edismax qf=$author_qf pf=$author_pf pf3=$author_pf3 pf2=$author_pf2}'\
            'One two three four five six seven eight nine ten '\
            'One two three four five six seven eight nine ten '\
            'One two three four five six seven')
        end
      end

      context 'Author search: query contains less than 27 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'One two three four five six seven eight nine ten',
            'search_field' => 'author'
          )
        end

        it 'does not truncate query at 10 terms' do
          expect(solr_parameters[:q]).to eq('{!edismax qf=$author_qf pf=$author_pf pf3=$author_pf3 pf2=$author_pf2}'\
            'One two three four five six seven eight nine ten')
        end
      end

      context 'Subject search: query contains more than 132 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 '\
            '41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 '\
            '61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 '\
            '81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 '\
            '101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 '\
            '121 122 123 124 125 126 127 128 129 130 131 132 133',
            'search_field' => 'subject'
          )
        end

        it 'truncates query at 132 terms' do
          expect(solr_parameters[:q]).to \
            eq('{!edismax qf=$subject_qf pf=$subject_pf pf3=$subject_pf3 pf2=$subject_pf2}'\
              '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
              '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 '\
              '41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 '\
              '61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 '\
              '81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 '\
              '101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 '\
              '121 122 123 124 125 126 127 128 129 130 131 132')
        end
      end

      context 'Subject search: query contains less than 132 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'One two three four five six seven eight',
            'search_field' => 'subject'
          )
        end

        it 'does not truncate query at 132 terms' do
          expect(solr_parameters[:q]).to \
            eq('{!edismax qf=$subject_qf pf=$subject_pf pf3=$subject_pf3 pf2=$subject_pf2}'\
              'One two three four five six seven eight')
        end
      end

      context 'ISBN search: query contains more than 117 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 '\
            '41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 '\
            '61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 '\
            '81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 '\
            '101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118',
            'search_field' => 'isbn_issn'
          )
        end

        it 'truncates query at 117 terms' do
          expect(solr_parameters[:q]).to eq('{!edismax qf=$isbn_issn_qf pf=\'\' pf3=\'\' pf2=\'\'}'\
            '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 '\
            '41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 '\
            '61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 '\
            '81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 '\
            '101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117')
        end
      end

      context 'ISBN search: query contains less than 117 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: 'One two three four five six seven eight',
            'search_field' => 'isbn_issn'
          )
        end

        it 'does not truncate query at 117 terms' do
          expect(solr_parameters[:q]).to eq('{!edismax qf=$isbn_issn_qf pf=\'\' pf3=\'\' pf2=\'\'}'\
            'One two three four five six seven eight')
        end
      end

      context 'Work entry search field: query contains more than 20 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40',
            'search_field' => 'work_entry'
          )
        end

        it 'truncates query at 20 terms' do
          expect(solr_parameters[:q]).to eq(\
            '{!edismax qf=$work_entry_qf pf=$work_entry_pf pf3=\'\' pf2=\'\'}1 2 3 4 5 6 7 8 9 10 11 12'
          )
        end
      end

      context 'Publisher search field: query contains more than 20 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40',
            'search_field' => 'publisher'
          )
        end

        it 'truncates query at 20 terms' do
          expect(solr_parameters[:q]).to eq(\
            '{!edismax }1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18'
          )
        end
      end

      context 'Series statement search field: query contains more than 20 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40',
            'search_field' => 'series_statement'
          )
        end

        it 'truncates query at 20 terms' do
          expect(solr_parameters[:q]).to eq(\
            '{!edismax qf=$series_qf pf=$series_pf pf3=$series_pf3 pf2=$series_pf2}1 2 3 4 5 6 7 8 9 10'
          )
        end
      end

      context 'Genre headings search field: query contains more than 20 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40',
            'search_field' => 'genre_headings'
          )
        end

        it 'truncates query at 20 terms' do
          expect(solr_parameters[:q]).to eq(\
            '{!edismax qf=\'genre_headings_t genre_headings_ara_v genre_headings_cjk_v '\
            'genre_headings_rus_v\' pf=\'\' pf3=\'\' pf2=\'\'}1 2 3 4 5 6 7 8 9 10'
          )
        end
      end

      context 'Call number search: query contains more than 20 terms' do
        let(:builder_with_params) do
          search_builder.with(
            q: '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40',
            'search_field' => 'call_number'
          )
        end

        it 'do not truncate query at 20 terms' do
          expect(solr_parameters[:q]).to eq(\
            '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 '\
            '21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40'
          )
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe 'disable_boolean_for_all_caps' do
    before do
      builder_with_params.add_query_to_solr(solr_parameters)
      builder_with_params.disable_boolean_for_all_caps(solr_parameters)
    end

    context 'query contains a boolean operator and is all caps' do
      let(:builder_with_params) { search_builder.with(q: 'STURM AND DRANG') }

      it 'downcases the query to turn off boolean treatment' do
        expect(solr_parameters[:q]).to eq('sturm and drang')
      end
    end

    context 'query contains a boolean operator and a lowercase letter' do
      let(:builder_with_params) { search_builder.with(q: 'sturm AND drang') }

      it 'does not modify the query' do
        expect(solr_parameters[:q]).to eq('sturm AND drang')
      end
    end

    context 'query does not contain boolean operators and is all caps' do
      let(:builder_with_params) { search_builder.with(q: 'STURM UND DRANG') }

      it 'does not modify the query' do
        expect(solr_parameters[:q]).to eq('STURM UND DRANG')
      end
    end

    context 'query does not contain boolean operators and has a lowercase letter' do
      let(:builder_with_params) { search_builder.with(q: 'sturm und drang') }

      it 'does not modify the query' do
        expect(solr_parameters[:q]).to eq('sturm und drang')
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

      it 'does not apply the min match setting for boolean searches' do
        expect(solr_parameters[:mm]).to be_nil
      end
    end

    context 'query contains a boolean operator and is all uppercase' do
      let(:builder_with_params) { search_builder.with(q: 'STRANGE AND STRANGER') }

      it 'does not apply the min match setting for boolean searches' do
        expect(solr_parameters[:mm]).to be_nil
      end
    end
  end

  describe 'min_match_for_titles' do
    before do
      builder_with_params.min_match_for_titles(solr_parameters)
    end

    context 'all fields search contains an initial article' do
      let(:builder_with_params) do
        search_builder.with(q: 'the two three four five six')
      end

      it 'does not set the min match setting' do
        expect(solr_parameters[:mm]).to be_nil
      end
    end

    context 'title search contains an initial article and has 3 or fewer terms' do
      let(:builder_with_params) do
        search_builder.with(q: 'the two three', 'search_field' => 'title')
      end

      it 'does not set the min match setting' do
        expect(solr_parameters[:mm]).to be_nil
      end
    end

    context 'title search contains an initial article and more than 3 terms' do
      let(:builder_with_params) do
        search_builder.with(q: 'the two three four five six', 'search_field' => 'title')
      end

      it 'sets the min match setting' do
        expect(solr_parameters[:mm]).to eq('5<95%')
      end
    end

    context 'title search does not contain an initial article' do
      let(:builder_with_params) do
        search_builder.with(q: 'one two three four five', 'search_field' => 'title')
      end

      it 'does not set the min match setting' do
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

  describe 'author_boost' do
    before { builder_with_params.author_boost(solr_parameters) }

    context 'query contains a basic author search' do
      let(:builder_with_params) do
        search_builder.with(
          q: 'Haruki Murakami',
          'search_field' => 'author'
        )
      end

      it 'adds the bq parameter to the solr query' do
        expect(solr_parameters[:bq]).to eq(
          ['language_f:English^500']
        )
      end

      it 'adds the bf parameter to the solr query' do
        current_year = Date.today.year
        current_year_plus_two = current_year + 2
        current_year_minus_ten = current_year - 10
        expect(solr_parameters[:bf]).to eq(
          ["linear(map(publication_year_isort,#{current_year_plus_two}," \
           "10000,#{current_year_minus_ten}," \
           'abs(publication_year_isort)),11,0)^0.5']
        )
      end
    end

    context 'query contains an advanced author search' do
      let(:builder_with_params) do
        search_builder.with(
          'author' => 'Haruki Murakami',
          'search_field' => 'advanced'
        )
      end

      it 'adds the bq parameter to the solr query' do
        expect(solr_parameters[:bq]).to eq(
          ['language_f:English^500']
        )
      end

      it 'adds the bf parameter to the solr query' do
        current_year = Date.today.year
        current_year_plus_two = current_year + 2
        current_year_minus_ten = current_year - 10
        expect(solr_parameters[:bf]).to eq(
          ["linear(map(publication_year_isort,#{current_year_plus_two}," \
           "10000,#{current_year_minus_ten}," \
           'abs(publication_year_isort)),11,0)^0.5']
        )
      end
    end
  end

  describe 'subjects_boost' do
    before { builder_with_params.subjects_boost(solr_parameters) }

    context 'query contains a basic subject search' do
      let(:builder_with_params) do
        search_builder.with(
          q: 'civil war history',
          'search_field' => 'subject'
        )
      end

      it 'adds the bq parameter to the solr query' do
        expect(solr_parameters[:bq]).to eq(
          ['language_f:English^1000',
           'title_main_indexed_tp:(civil war history)^50',
           'resource_type_f:Book^10']
        )
      end

      it 'adds the bf parameter to the solr query' do
        current_year = Date.today.year
        current_year_plus_two = current_year + 2
        current_year_minus_ten = current_year - 10
        expect(solr_parameters[:bf]).to eq(
          ["linear(map(publication_year_isort,#{current_year_plus_two}," \
           "10000,#{current_year_minus_ten}," \
           'abs(publication_year_isort)),11,0)^5']
        )
      end
    end

    context 'query contains an advanced subject search' do
      let(:builder_with_params) do
        search_builder.with(
          'subject' => 'civil war history',
          'search_field' => 'advanced'
        )
      end

      it 'adds the bq parameter to the solr query' do
        expect(solr_parameters[:bq]).to eq(
          ['language_f:English^1000',
           'title_main_indexed_tp:(civil war history)^50',
           'resource_type_f:Book^10']
        )
      end

      it 'adds the bf parameter to the solr query' do
        current_year = Date.today.year
        current_year_plus_two = current_year + 2
        current_year_minus_ten = current_year - 10
        expect(solr_parameters[:bf]).to eq(
          ["linear(map(publication_year_isort,#{current_year_plus_two}," \
           "10000,#{current_year_minus_ten}," \
           'abs(publication_year_isort)),11,0)^5']
        )
      end
    end
  end

  describe 'share_bookmarks' do
    before { builder_with_params.add_document_ids_query(solr_parameters) }

    context 'query contains a single bookmark ID' do
      let(:builder_with_params) do
        search_builder.with(
          doc_ids: 'UNCb9249630'
        )
      end

      it 'adds the correct defType to the solr query' do
        expect(solr_parameters[:defType]).to eq(
          'lucene'
        )
      end

      it 'adds the correct q parameter to the solr query' do
        expect(solr_parameters[:q]).to eq(
          '{!lucene}id:(UNCb9249630)'
        )
      end
    end

    context 'query contains multiple bookmark IDs' do
      let(:builder_with_params) do
        search_builder.with(
          doc_ids: 'UNCb9249630|UNCb9001022|UNCb7925949'
        )
      end

      it 'adds the correct defType to the solr query' do
        expect(solr_parameters[:defType]).to eq(
          'lucene'
        )
      end

      it 'adds the correct q parameter to the solr query' do
        expect(solr_parameters[:q]).to eq(
          '{!lucene}id:(UNCb9249630 OR UNCb9001022 OR UNCb7925949)'
        )
      end
    end

    context 'query contains junk' do
      let(:builder_with_params) do
        search_builder.with(
          doc_ids: '&///?**__$$ '
        )
      end

      it 'strips out the junk (only alphanumeric should pass)' do
        expect(solr_parameters[:q]).to eq(
          '{!lucene}id:()'
        )
      end
    end

    context 'query is empty' do
      let(:builder_with_params) do
        search_builder.with(
          doc_ids: ''
        )
      end

      it 'returns nil' do
        expect(solr_parameters[:q]).to eq(
          nil
        )
      end
    end
  end

  describe '#add_solr_debug' do
    before { builder_with_params.add_solr_debug(solr_parameters) }

    let(:builder_with_params) do
      search_builder.with(debug: 'true')
    end

    it 'adds the score to the fl paramater' do
      expect(solr_parameters[:fl]).to eq('*,score')
    end
  end
end
