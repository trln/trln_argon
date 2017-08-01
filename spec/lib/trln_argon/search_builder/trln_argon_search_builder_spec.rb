describe TrlnArgonSearchBuilder do
  let(:obj) { described_class.new(CatalogController.new) }

  describe 'processor chain' do
    it 'adds the local filter method to the processor chain' do
      expect(obj.processor_chain).to include(:apply_local_filter)
    end

    it 'adds the isxn boost method to the processor chain' do
      expect(obj.processor_chain).to include(:boost_isxn_matches)
    end
  end
end
