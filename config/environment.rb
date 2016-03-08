# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.smtp_settings = {
:domain  => 'email.flawlessbeautysalon.us'
}

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.gmail.com',
  :port           => '587',
  :authentication => :login,
  :user_name => '',
  :password => '',
  :enable_starttls_auto => true
}
