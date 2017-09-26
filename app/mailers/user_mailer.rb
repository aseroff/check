class UserMailer < Devise::Mailer   
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  default from: ('Tokens <no-reply@' + Rails.application.config.app_domain + '>' )
  layout 'mailer'

end