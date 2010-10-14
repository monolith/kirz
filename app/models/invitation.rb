class Invitation < ActiveRecord::Base
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :message => "already exists on the invite list.  This person has already registered or can register with this email."
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  attr_accessible :name

end

