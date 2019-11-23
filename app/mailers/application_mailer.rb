# frozen_string_literal: true

# Top-level mailer
class ApplicationMailer < ActionMailer::Base
  default from: ('no-reply@' + Rails.application.config.app_domain)
  layout 'mailer'
end
