class User < ActiveRecord::Base
  has_many :goals, :through => :usergoals #user.goals[3].name
  has_many :usergoals #user.usergoals
  #this means that each user has many goals 
  #name , password , email position , bio .
  
  attr_accessor :new_password, :new_password_confirmation
  validates_confirmation_of :new_password, :if => :password_changed?
  validates_length_of :new_password, :minimum => 5, :if => :password_changed?
  validates_length_of :name, :in => 4..30
  validates_uniqueness_of :name
  
  before_save :hash_new_password, :if => :password_changed?
  before_create :set_api_key

  def password_changed?
    !@new_password.blank?
  end

  def self.auth name, attempted_password
    user = find_by_name name
    if user and user.password == user.hash_password(attempted_password)
      user
    else
      nil
    end
  end
  
  def hash_new_password
    self.salt = ActiveSupport::SecureRandom.base64(8)
    self.password = hash_password @new_password
  end

  def set_api_key
    self.api_key = ActiveSupport::SecureRandom.hex(32)
  end

  def hash_password pass
    Digest::SHA2.hexdigest(salt + pass)
  end

  def to_s
    name
  end
end
