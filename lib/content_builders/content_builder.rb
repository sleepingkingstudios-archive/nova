# lib/content_builders/content_builder.rb

class ContentBuilder
  def initialize object
    case object
    when Class
      @content_class = object
    else
      @content_class = object.class
      @content       = object
    end # case
  end # constructor

  attr_reader :content, :content_class

  def build_content params
    @content = @content_class.new build_content_params(params)
  end # method build_content

  def build_content_params params
    content_params params
  end # method build_content_params

  def content_params params
    params.permit()
  end # method content_params
end # class
