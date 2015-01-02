# spec/support/factories/setting_factories.rb

FactoryGirl.define do
  factory :setting do
    sequence(:key) { |index| "setting#{index}" }

    factory :navigation_list_setting, :class => 'NavigationListSetting'

    factory :string_setting, :class => 'StringSetting' do
      value 'Alas, poor Yorick; I knew him, Horatio - a man of infinite jest.'
    end # factory
  end # factory
end # define
