# app/models/user.rb

class User
  include Mongoid::Document

  devise :database_authenticatable, :registerable, :validatable

  ## Devise authentication fields.
  field :email,                  :type => String, :default => ""
  field :encrypted_password,     :type => String, :default => ""
end # model
