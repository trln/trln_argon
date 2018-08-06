# frozen_string_literal: true

class RecordMailer < ActionMailer::Base
  def email_record(documents, details, url_gen_params)
    title = begin
              documents.first[TrlnArgon::Fields::TITLE_MAIN]
            rescue StandardError
              I18n.t('blacklight.email.text.default_title')
            end
    subject = I18n.t('blacklight.email.text.subject', count: documents.length, title: title)

    @documents      = documents
    @message        = details[:message]
    @url_gen_params = url_gen_params

    mail(to: details[:to], subject: subject)
  end
end
