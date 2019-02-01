describe TrlnArgon::ViewHelpers::ItemsSectionHelper, type: :helper do
  let(:unc_serial_with_holdings_id) do
    hash = YAML.safe_load(file_fixture('documents/UNCb1699212.yml').read).first
    SolrDocument.new(hash)
  end

  let(:unc_item_data) do
    unc_serial_with_holdings_id.holdings['trln']['trln']
  end

  let(:ncsu_serial_with_lr_text) do
    hash = YAML.safe_load(file_fixture('documents/NCSU212262.yml').read).first
    SolrDocument.new(hash)
  end

  let(:ncsu_item_data) do
    ncsu_serial_with_lr_text.holdings['DHHILL']['STACKS']
  end

  context '#latest_received' do
    it 'returns text and a URL for UNC serial with holdings' do
      aggregate_failures do
        text, url = helper.latest_received(unc_serial_with_holdings_id, unc_item_data)
        expect(text).to eq('Latest Received')
        expect(url).not_to be_nil
      end
    end

    it 'returns only text for an NCSU serial with latest_received' do
      aggregate_failures do
        text, url = helper.latest_received(ncsu_serial_with_lr_text, ncsu_item_data)
        expect(text).to eq('V 31 N 4 OCT 2005')
        expect(url).to be_nil
      end
    end
  end
end
