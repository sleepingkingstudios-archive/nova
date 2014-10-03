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

  def update_content params
    builder = decorate(self.content, :builder, :default => :ContentBuilder)
    builder.update_content(ActionController::Parameters.new params)
  end # method update_content
end # module
