# app/helpers/rendering_helper.rb

module RenderingHelper
  def render_component name, locals = {}, &block
    rendering_type = block_given? ? :layout : :partial

    render rendering_type => name, :locals => locals, &block
  end # method render_component
end # module
