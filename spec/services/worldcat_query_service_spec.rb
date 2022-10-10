describe WorldcatQueryService do
  let(:search_session) { { query_params: { q: 'test' } } }

  let(:slashy) { 'http://www.example.com/' }

  let(:noslashy) { 'http://www.example.com' }

  let(:expected) { 'http://www.example.com/search?queryString=kw:test' }

  let(:instance) { described_class.new(search_session) }

  it 'correctly processes env var with slash' do
    ENV['WORLDCAT_URL'] = slashy
    expect(instance.query_url).to eq(expected)
  end

  it 'correctly processes env var without slash' do
    ENV['WORLDCAT_URL'] = noslashy
    expect(instance.query_url).to eq(expected)
  end
end
