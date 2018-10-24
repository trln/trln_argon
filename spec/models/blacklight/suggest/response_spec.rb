# frozen_string_literal: true

describe Blacklight::Suggest::Response do
  let(:empty_response) { described_class.new({}, { q: 'hello' }, 'suggest', 'suggest') }
  let(:suggestions_01) { YAML.safe_load(file_fixture('suggestions/suggestion_01.yml').read) }
  let(:full_response) do
    described_class.new(
      suggestions_01,
      {
        q: 'new'
      },
      'suggest',
      'suggest'
    )
  end

  describe '#initialize' do
    it 'creates a Blacklight::Suggest::Response' do
      expect(empty_response).to be_a described_class
    end
  end

  describe '#suggestions' do
    it 'returns a hash of suggestions' do
      expect(full_response.suggestions).to be_a Hash
    end

    it 'returns 3 suggestions' do
      expect(full_response.suggestions.count).to eq 3
    end

    it 'returns a suggested term' do
      expect(full_response.suggestions['title'].first['term']).to eq '"new jersey"'
    end
  end
end
