# spec/validators/unique_within_siblings_validator_spec.rb

require 'rails_helper'
require 'validators/unique_within_siblings_validator'

RSpec.describe UniqueWithinSiblingsValidator, :type => :validator do
  let(:options)    { { :attributes => %i(slug) } }
  let(:instance)   { described_class.new options }

  shared_context 'with a parent directory', :parent => :one do
    let(:parent)     { build :directory }
    let(:attributes) { super().merge :parent => parent }
  end # shared_context

  describe '#validate_each' do
    it { expect(instance).to respond_to(:validate_each).with(3).arguments }

    describe 'with a directory' do
      let(:attributes) { attributes_for(:directory) }
      let(:directory)  { build(:directory, attributes) }

      context 'with a persisted directory' do
        before(:each) { directory.save! }

        it 'does not append an error' do
          expect { instance.validate_each directory, :slug, directory.slug }.not_to change { directory.errors[:slug].count }
        end # it
      end # context

      context 'with no siblings' do
        it 'does not append an error' do
          expect { instance.validate_each directory, :slug, directory.slug }.not_to change { directory.errors[:slug].count }
        end # it
      end # context

      context 'with a sibling directory' do
        before(:each) { create(:directory, :slug => directory.slug) }

        it 'appends an error' do
          expect { instance.validate_each directory, :slug, directory.slug }.to change { directory.errors[:slug].count }.by(1)

          expect(directory.errors[:slug].last).to be == 'is already taken'
        end # it
      end # context

      context 'with a sibling feature' do
        before(:each) { create(:feature, :slug => directory.slug) }

        it 'appends an error' do
          expect { instance.validate_each directory, :slug, directory.slug }.to change { directory.errors[:slug].count }.by(1)

          expect(directory.errors[:slug].last).to be == 'is already taken'
        end # it
      end # context

      context 'with a parent directory', :parent => :one do
        context 'with an unrelated directory' do
          before(:each) { create(:directory, :slug => directory.slug) }

          it 'does not append an error' do
            expect { instance.validate_each directory, :slug, directory.slug }.not_to change { directory.errors[:slug].count }
          end # it
        end # context

        context 'with an unrelated feature' do
          before(:each) { create(:feature, :slug => directory.slug) }
          
          it 'does not append an error' do
            expect { instance.validate_each directory, :slug, directory.slug }.not_to change { directory.errors[:slug].count }
          end # it
        end # context

        context 'with a sibling directory' do
          before(:each) { create(:directory, :parent => parent, :slug => directory.slug) }

          it 'appends an error' do
            expect { instance.validate_each directory, :slug, directory.slug }.to change { directory.errors[:slug].count }.by(1)

            expect(directory.errors[:slug].last).to be == 'is already taken'
          end # it
        end # context

        context 'with a sibling feature' do
          before(:each) { create(:feature, :directory => parent, :slug => directory.slug) }

          it 'appends an error' do
            expect { instance.validate_each directory, :slug, directory.slug }.to change { directory.errors[:slug].count }.by(1)

            expect(directory.errors[:slug].last).to be == 'is already taken'
          end # it
        end # context
      end # context
    end # describe
  end # describe
end # describe
