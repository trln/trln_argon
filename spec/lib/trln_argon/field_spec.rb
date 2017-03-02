describe TrlnArgon::Field do

  describe "stored single value field" do

    let(:field) { TrlnArgon::Field.new :food }

    before do
      I18n.backend.store_translations(:en, {
        trln_argon: {
          fields: {
            food: { label:  'All the Foods' }
          }
        }
      })
    end

    it "should return its solr field name" do
      expect(field).to eq('food')
    end

    it "should use a translated label" do
      expect(field.label).to eq('All the Foods')
    end

  end

  describe "stored multivalued field" do

    let(:field) { TrlnArgon::Field.new :blah_blah_a }

    it "should return its solr field name" do
      expect(field).to eq('blah_blah_a')
    end

    it "should have a label" do
      expect(field.label).to eq('Blah Blah')
    end

  end

  describe "facet field" do

    let(:field) { TrlnArgon::Field.new :blah_blah_facet }

    it "should return its solr field name" do
      expect(field).to eq('blah_blah_facet')
    end

    it "should have a label" do
      expect(field.label).to eq('Blah Blah')
    end

  end

end
