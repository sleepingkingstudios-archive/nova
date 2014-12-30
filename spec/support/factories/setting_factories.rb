# spec/support/factories/setting_factories.rb

FactoryGirl.define do
  factory :setting do
    sequence(:key) { |index| "setting-#{index}" }
  end # factory

  factory :string_setting, :class => 'StringSetting', :parent => :setting do
    value 'Alas, poor Yorick; I knew him, Horatio - a man of infinite jest.'
  end # factory
end # define
