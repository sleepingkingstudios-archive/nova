# spec/support/contexts/delegates/delegate_contexts.rb

module Spec
  module Contexts
    module Delegates
      module DelegateContexts
        shared_context 'with a controller', :controller => true do
          let(:flash_messages) { ActionDispatch::Flash::FlashHash.new }
          let(:controller)     { double('controller', :flash => flash_messages, :render => nil, :redirect_to => nil) }

          def assigns
            controller.instance_variables.each.with_object({}) do |key, hsh|
              hsh[key.to_s.sub(/\A@/, '')] = controller.instance_variable_get(key)
            end.with_indifferent_access
          end # method assigns

          before(:each) { instance.controller = controller }
        end # shared_context
      end # module
    end # module
  end # module
end # module
