# spec/support/factories/features/contents/markdown_content_factories.rb 

FactoryGirl.define do
  factory :markdown_content, :class => 'MarkdownContent', :parent => :text_content do
    text_content '# This is an <h1> tag\n\nThis is a paragraph.'
  end # factory
end # define
