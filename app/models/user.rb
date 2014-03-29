class User < ActiveRecord::Base
  has_secure_password

  validates :name, :presence => true
  validates :email, :presence => true, :format => /\A\S+@\S+\.\S+\z/, :uniqueness => {:case_sensitive => false}
  validates :password, :length => { :minimum => 10, :allow_blank => true }
  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}, :format => /[[:alnum:]]+/
end
