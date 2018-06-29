describe RollupOnlySearchBuilder do
  let(:obj) { described_class.new(CatalogController.new) }

  describe 'processor chain' do
    it 'adds the rollup method to the processor chain' do
      expect(obj.processor_chain).to include(:rollup_duplicate_records)
    end
  end
end
