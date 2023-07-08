# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('APP_MAIL', 'fake@mail.com')
  layout 'mailer'
end
