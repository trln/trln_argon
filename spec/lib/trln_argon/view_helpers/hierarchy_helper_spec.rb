describe TrlnArgon::ViewHelpers::HierarchyHelper, type: :helper do
  describe '#map_argon_facet_codes' do
    context 'when a mapping exists' do
      let(:item) { instance_double('item', qvalue: 'duke:dukedivy', value: 'dukedivy') }

      it 'returns a mapped value' do
        expect(helper.map_argon_facet_codes(item)).to eq('Divinity')
      end
    end

    context 'when a mapping does not exist' do
      let(:item2) { instance_double('item', qvalue: 'foo', value: 'bar') }

      it 'returns the unmapped path' do
        expect(helper.map_argon_facet_codes(item2)).to eq('foo.facet.bar')
      end
    end
  end
end
