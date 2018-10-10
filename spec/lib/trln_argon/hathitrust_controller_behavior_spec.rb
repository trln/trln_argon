describe TrlnArgon::HathitrustControllerBehavior do
  class HathitrustControllerBehaviorTestClass < HathitrustController
  end

  let(:mock_controller) { HathitrustControllerBehaviorTestClass.new }
  let(:response) do
    YAML.safe_load(file_fixture('hathitrust/hathitrust_response.yml').read)
  end
  let(:expectation) do
    YAML.safe_load(file_fixture('hathitrust/hathitrust_response_expectation.yml').read)
  end

  describe '#hathi_links_grouped_by_oclc_number' do
    it 'assembles the response' do
      allow(mock_controller).to receive(:hathitrust_response_hash).and_return(response)
      expect(mock_controller.send(:hathi_links_grouped_by_oclc_number)).to eq(expectation.to_json)
    end
  end
end
