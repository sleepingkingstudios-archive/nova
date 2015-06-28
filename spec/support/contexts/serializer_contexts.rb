# spec/support/contexts/serializer_contexts.rb

module Spec
  module Contexts
    module SerializerContexts
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      shared_context 'with a serializer for' do |resource_class|
        let(:resource_class)         { resource_class }
        let(:blacklisted_attributes) { %w(_id _type) }

        it { expect(described_class).to be_constructible.with(0, :arbitrary, :keywords) }

        describe '::resource_class' do
          it { expect(described_class).to have_reader(:resource_class).with(resource_class) }
        end # describe

        let(:instance_options)  { {} }
        let(:instance)          { described_class.new(**instance_options) }
      end # shared_context
    end # module
  end # module
end # module
