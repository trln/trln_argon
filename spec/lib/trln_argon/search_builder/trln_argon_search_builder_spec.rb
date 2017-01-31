describe TrlnArgonSearchBuilder do

  before { @obj = TrlnArgonSearchBuilder.new(CatalogController.new) }

  describe 'processor chain' do

    it 'should add the local filter method to the processor chain' do
      expect(@obj.processor_chain).to include(:apply_local_filter)
    end

  end

end
