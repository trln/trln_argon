describe DefaultTrlnSearchBuilder do
  let(:obj) { described_class.new(CatalogController.new) }

  describe 'processor chain' do
    it 'adds the wildcard_char_strip method to the processor chain' do
      expect(obj.processor_chain).to include(:wildcard_char_strip)
    end

    it 'adds the min_match_for_cjk method to the processor chain' do
      expect(obj.processor_chain).to include(:min_match_for_cjk)
    end

    it 'adds the min_match_for_boolean method to the processor chain' do
      expect(obj.processor_chain).to include(:min_match_for_boolean)
    end

    it 'adds the local filter method to the processor chain' do
      expect(obj.processor_chain).to include(:rollup_duplicate_records)
    end

    it 'adds the only home facets method to the processor chain' do
      expect(obj.processor_chain).to include(:only_home_facets)
    end
  end
end
