describe SolrDocument do

  describe "unique identifier" do

    let(:solrdoc) do
      SolrDocument.new(id: "NCSU3724376")
    end

    describe "#id" do
      subject { solrdoc.id }
      it { is_expected.to eq "NCSU3724376" }
    end

    it "should use the Solr id field as its unique key" do
      expect(SolrDocument.unique_key).to eq "id"
    end

  end

end