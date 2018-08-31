describe RecordMailer do
  before do
    allow(described_class).to receive(:default).and_return(from: 'no-reply@projectblacklight.org')
    SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Email)
    SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Sms)
  end

  describe 'email' do
    let(:document) do
      SolrDocument.new(id: '123456',
                       institution_a: 'unc',
                       resource_type_a: ['Book'],
                       title_main: 'The horn',
                       statement_of_responsibility_a: 'Janetzky, Kurt')
    end
    let(:documents) { [document] }
    let(:details) { { to: 'test@test.com', message: 'This is my message' } }
    let(:email) do
      described_class.email_record(documents, details, host: 'projectblacklight.org', protocol: 'https')
    end

    it 'receives the TO paramater and send the email to that address' do
      expect(email.to).to include 'test@test.com'
    end

    it 'starts the subject w/ Item Record:' do
      expect(email.subject).to match(/^Library catalog record:/)
    end

    it 'puts the title of the item in the subject' do
      expect(email.subject).to match(/The horn/)
    end

    it 'has the correct from address (w/o the port number)' do
      expect(email.from).to include 'no-reply@projectblacklight.org'
    end

    it 'prints out the correct title in the body' do
      expect(email.body).to match(/Title:\n\s\sThe horn/)
    end

    it 'prints out the correct author in the body' do
      expect(email.body).to match(/Author:\n\s\sJanetzky, Kurt/)
    end
  end

  describe 'SMS' do
    let(:document) do
      SolrDocument.new(id: '123456',
                       institution_a: 'unc',
                       resource_type_a: ['Book'],
                       title_main: 'The horn',
                       statement_of_responsibility_a: 'Janetzky, Kurt')
    end
    let(:documents) { [document] }
    let(:details) { { to: '5555555555@txt.att.net' } }
    let(:sms) do
      described_class.sms_record(documents, details, host: 'projectblacklight.org:3000')
    end

    it 'creates the correct TO address for the SMS email' do
      expect(sms.to).to include '5555555555@txt.att.net'
    end

    it 'does not have a subject' do
      expect(sms.subject).to be_blank
    end

    it 'has the correct from address (w/o the port number)' do
      expect(sms.from).to include('no-reply@projectblacklight.org')
    end

    it 'prints out the correct message' do
      expect(sms.body).to match(/(Catalog result)/)
    end

    it 'prints out the correct title' do
      expect(sms.body).to match(/Title: The horn/)
    end
  end
end
