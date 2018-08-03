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

  describe '#escape_double_backslashes' do
    let(:query) { "100 years of the Nineteenth Amendment \\: an appraisal of women's political activism" }

    it 'escapes colons preceded by a space' do
      expect(described_class.escape_double_backslashes(query)).to eq(
        '100 years of the Nineteenth Amendment \\\\: an appraisal of women\'s political activism'
      )
    end
  end

  describe '#unescape_double_backslashes' do
    let(:escaped_query) { "100 years of the Nineteenth Amendment \\\\: an appraisal of women's political activism" }

    it 'unescapes colons preceded by a space' do
      expect(described_class.unescape_double_backslashes(escaped_query)).to eq(
        '100 years of the Nineteenth Amendment \\: an appraisal of women\'s political activism'
      )
    end
  end
end
