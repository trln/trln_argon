# frozen_string_literal: true

describe Blacklight::SuggestSearch do
  let(:params) { { q: 'test' } }
  let(:suggest_path) { 'suggest' }
  let(:solr_component) { 'suggest' }
  let(:category) { nil }
  let(:connection) { instance_double(RSolr::Client, send_and_receive: 'sent') }
  let(:repository) { instance_double(Blacklight::Solr::Repository, connection: connection) }
  let(:suggest_search) { described_class.new(params, category, repository) }

  describe '#suggestions' do
    it 'returns a Blacklight::Suggest::Response' do
      allow(suggest_search).to receive_messages(
        suggest_results: [],
        suggest_handler_path: suggest_path,
        suggest_component: solr_component
      )
      expect(suggest_search.suggestions).to be_an Blacklight::Suggest::Response
    end
  end

  describe '#suggest_results' do
    it 'calls send_and_recieve from a repository connection' do
      allow(suggest_search).to receive(:suggest_handler_path).and_return(suggest_path)
      expect(suggest_search.suggest_results).to eq 'sent'
    end
  end
end
