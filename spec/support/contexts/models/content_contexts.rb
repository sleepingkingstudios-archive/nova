# spec/support/contexts/models/content_contexts.rb

module Spec
  module Contexts
    module Models
      module ContentContexts
        extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

        shared_context 'with a container', :container => :one do
          let(:container)  { build :page }
          let(:attributes) { super().merge :container => container }
        end # shared_context
      end # module
    end # module
  end # module
end # module
