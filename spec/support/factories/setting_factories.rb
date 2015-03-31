# spec/support/factories/setting_factories.rb

FactoryGirl.define do
  factory :setting do
    sequence(:key) { |index| "setting_#{index}" }

    factory :navigation_list_setting, :class => 'NavigationListSetting' do
      trait :with_a_list do
        list do
          list = build(:navigation_list)
          list.items.build(:label => 'Sedimentary Rocks', :url => '/rocks/sedimentary/limestone')
          list.items.build(:label => 'Igneous Rocks',     :url => '/rocks/igneous/basalt')
          list.items.build(:label => 'Metamorphic Rocks', :url => '/rocks/metamorphic/slate')
        end # block
      end # trait
    end # factory

    factory :string_setting, :class => 'StringSetting' do
      value 'Alas, poor Yorick; I knew him, Horatio - a man of infinite jest.'
    end # factory
  end # factory
end # define
