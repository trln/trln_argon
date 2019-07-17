describe TrlnArgon::InternetArchiveControllerBehavior do
  class InternetArchiveControllerBehaviorTestClass < InternetArchiveController
  end

  let(:mock_controller) { InternetArchiveControllerBehaviorTestClass.new }
  let(:response) do
    YAML.safe_load(file_fixture('internet_archive/internet_archive_response.yml').read)
  end
  let(:ids) do
    'publiclawsresol00nort|publiclawsres00nort|'\
    'publiclawsresolu00nort|publiclawsreso00nort|shouldbeexlcuded'
  end
  let(:expectation) do
    YAML.safe_load(file_fixture('internet_archive/internet_archive_response_expectation.yml').read)
  end

  describe '#ia_ids_grouped_by_class' do
    it 'assembles the response' do
      allow(mock_controller).to receive(:ia_api_response).and_return(response.to_json)
      allow(mock_controller).to receive(:sanitize_internet_archive_id_params).and_return(ids)
      expect(mock_controller.send(:ia_ids_grouped_by_class)).to eq(expectation)
    end
  end
end
