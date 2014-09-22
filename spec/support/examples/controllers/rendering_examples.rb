# spec/support/examples/controllers/rendering_examples.rb

module Spec
  module Examples
    module Controllers
      module RenderingExamples
        shared_examples 'renders template' do |template, options = {}|
          it "renders the #{template} template}" do
            perform_action

            expect(response.status).to be == options.fetch(:status, 200)
            expect(response).to render_template(template)
          end # it
        end # shared_examples
      end # module
    end # module
  end # module
end # module
