describe DefaultLocalSearchBuilder do
  let(:obj) { described_class.new(CatalogController.new) }

  describe 'processor chain' do
    it 'adds the min_match_for_cjk method to the processor chain' do
      expect(obj.processor_chain).to include(:min_match_for_cjk)
    end

    it 'adds the min_match_for_boolean method to the processor chain' do
      expect(obj.processor_chain).to include(:min_match_for_boolean)
    end

    it 'adds the local filter method to the processor chain' do
      expect(obj.processor_chain).to include(:show_only_local_holdings)
    end

    it 'adds the before filter method to the processor chain' do
      expect(obj.processor_chain).to include(:begins_with_filter)
    end

    it 'adds the only home facets method to the processor chain' do
      expect(obj.processor_chain).to include(:only_home_facets)
    end
  end
end
