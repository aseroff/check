class ApplicationMailer < ActionMailer::Base
  default from: ('no-reply@' + Rails.config.app_domain )
  layout 'mailer'
end
