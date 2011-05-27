require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

#  validates_presence_of     :login
#  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,     :message=> "Login has already been taken"
#  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

#  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
#  validates_length_of       :name,     :maximum => 100

#  validates_presence_of     :email
#  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,     :message=> "Email has already been taken"
#  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
#  validates_presence_of     :password,                   :if => :password_required?
#  validates_presence_of     :password_confirmation,      :if => :password_required?
#  validates_confirmation_of :password,                   :if => :password_required?
#  validates_length_of       :password, :within => 6..40, :if => :password_required?



  has_many :storagefiles, :dependent => :destroy

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation
#  


  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  def not_user_empty?(ffield)
    !(ffield.empty?)
  end
  private
  def validate
    if self.login.blank?
      errors.add(:login, "Login can't be blank")
      return false
    else
      if (self.login.length<=3)||(self.login.length > 40)
        errors.add(:login, "Login should be in range 4..40")
        return false
      else
        if self.login.match(Authentication.login_regex)== nil
          errors.add(:login, Authentication.bad_login_message)
          return false
        else
          #          if self.name.match(Authentication.name_regex)== nil
          #            errors.add(:name, Authentication.bad_name_message)
          #            return false
          #          else
          #            if (self.name.length > 100)
          #              errors.add(:name, "Name should be less than 100 symbols")
          #              return false
          #            else
          if self.email.blank?
            errors.add(:email, "Email can't be blank")
            return false
          else
            if (self.email.length<6)||(self.email.length > 100)
              errors.add(:email, "Email should be in range 6..100")
              return false
            else
              if self.email.match(Authentication.email_regex)== nil
                errors.add(:email, "Email " + Authentication.bad_email_message)
                return false
              else
                if self.password.blank?
                  errors.add(:password, "Password can't be blank")
                  return false
                else
                  if self.password_confirmation.blank?
                    errors.add(:password, "Password can't be blank")
                    return false
                  end
                end
              end
            end
          end
        end
      end
    end
  end


end
