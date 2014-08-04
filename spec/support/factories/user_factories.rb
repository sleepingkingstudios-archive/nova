# spec/support/factories/user_factories.rb

FactoryGirl.define do
  factory :user do
    sequence(:email) { |index| "user.#{index}@example.com" }
    password { 'swordfish' }
    password_confirmation { password }
  end # factory
end # define
