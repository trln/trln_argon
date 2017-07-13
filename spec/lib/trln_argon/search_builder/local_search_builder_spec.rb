describe LocalSearchBuilder do
  let(:obj) { described_class.new(CatalogController.new) }

  describe 'processor chain' do
    it 'adds the local holdings method to the processor chain' do
      expect(obj.processor_chain).to include(:show_only_local_holdings)
    end
  end
end
