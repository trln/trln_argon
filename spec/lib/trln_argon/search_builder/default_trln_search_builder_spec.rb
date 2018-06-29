describe DefaultTrlnSearchBuilder do
  let(:obj) { described_class.new(CatalogController.new) }

  describe 'processor chain' do
    it 'adds the local filter method to the processor chain' do
      expect(obj.processor_chain).to include(:rollup_duplicate_records)
    end

    it 'adds the before filter method to the processor chain' do
      expect(obj.processor_chain).to include(:begins_with_filter)
    end
  end
end
