describe ConsortiumSearchBuilder do

  before { @obj = ConsortiumSearchBuilder.new(CatalogController.new) }

  describe 'processor chain' do

    it 'should add the rollup method to the processor chain' do
      expect(@obj.processor_chain).to include(:rollup_duplicate_records)
    end

  end

end
