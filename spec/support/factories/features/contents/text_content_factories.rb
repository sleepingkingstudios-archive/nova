# spec/support/factories/features/contents/text_content_factories.rb

FactoryGirl.define do
  factory :text_content, :class => 'TextContent', :parent => :content do
    text_content 'It is a truth universally acknowledged, that a single man in possession of a good fortune, must be in want of a wife.'
  end # factory
end # define
