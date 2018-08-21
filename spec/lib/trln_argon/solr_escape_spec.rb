describe TrlnArgon::SolrEscape do
  describe 'escape_colon_after_space' do
    let(:raw_query) { "100 years of the Nineteenth Amendment : an appraisal of women's political activism" }

    it '#escapes colons preceded by a space' do
      expect(described_class.escape_colon_after_space(raw_query)).to eq(
        '100 years of the Nineteenth Amendment \\: an appraisal of women\'s political activism'
      )
    end
  end

  describe '#unescape_colon_after_space' do
    let(:escaped_query) { "100 years of the Nineteenth Amendment \\: an appraisal of women's political activism" }

    it 'unescapes colons preceded by a space' do
      expect(described_class.unescape_colon_after_space(escaped_query)).to eq(
        '100 years of the Nineteenth Amendment : an appraisal of women\'s political activism'
      )
    end
  end

  describe '#escape_escaped_backslash' do
    let(:query) { "100 years of the Nineteenth Amendment \\: an appraisal of women's political activism" }

    it 'escapes colons preceded by a space' do
      expect(described_class.escape_escaped_backslash(query)).to eq(
        '100 years of the Nineteenth Amendment \\\\: an appraisal of women\'s political activism'
      )
    end
  end

  describe '#unescape_escaped_backslash' do
    let(:escaped_query) { "100 years of the Nineteenth Amendment \\\\: an appraisal of women's political activism" }

    it 'unescapes colons preceded by a space' do
      expect(described_class.unescape_escaped_backslash(escaped_query)).to eq(
        '100 years of the Nineteenth Amendment \\: an appraisal of women\'s political activism'
      )
    end
  end

  describe 'query is nil' do
    let(:query) { nil }

    it 'does not object to the query being nil' do
      expect(described_class.unescape_escaped_backslash(query)).to eq(
        ''
      )
    end
  end
end
