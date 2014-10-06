# app/controllers/concerns/content_building.rb

Dir[Rails.root.join 'lib', 'content_builders', '**', '*.rb'].each do |file|
  require file
end # each

module ContentBuilding
  include DecoratorsHelper

  delegate :content, :content=, :to => :resource

  def build_content params, content_type = nil
    content_type ||= params.fetch(:_type, 'Content')

    builder = decorate(content_type, :Builder, :default => :ContentBuilder)

    self.content = builder.build_content(ActionController::Parameters.new params)
  end # method build_content

  def content_params params
    params.fetch(:resource, {}).fetch(:content, {})
  end # method content_params

  def content_type params
    case
    when type = params.fetch(:content_type, nil)
      type
    when type = content_params(params).fetch(:_type, nil)
      type
    when resource
      resource.class.default_content_type
    end.to_s.camelize.sub(/Content(s?)\z/, '') << "Content"
  end # method content_type

  def update_content params
    return if params.blank?

    content_type = params.fetch(:_type, resource.class.default_content_type)
    content_type = content_type.to_s.camelize.sub(/Content(s?)\z/, '') << "Content"

    if content_type == self.content._type
      builder = decorate(self.content, :builder, :default => :ContentBuilder)

      builder.update_content(ActionController::Parameters.new params)
    else
      builder = decorate(content_type, :Builder, :default => :ContentBuilder)

      self.content = builder.build_content(ActionController::Parameters.new params)
    end # if-else
  end # method update_content
end # module
