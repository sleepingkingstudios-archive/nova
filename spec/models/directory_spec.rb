require 'rails_helper'

RSpec.describe Directory, :type => :model do
  let(:attributes) { FactoryGirl.attributes_for :directory }
  let(:instance)   { described_class.new attributes }

  describe '#title' do
    it { expect(instance).to have_property :title }
  end # describe

  describe '#slug' do
    let(:value) { FactoryGirl.attributes_for(:directory).fetch(:title).parameterize }

    it { expect(instance).to have_property :slug }

    it 'sets #slug_lock to true' do
      expect { instance.slug = value }.to change(instance, :slug_lock).to(true)
    end # it
  end # describe

  describe '#slug_lock' do
    it { expect(instance).to have_property :slug_lock }
  end # describe

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'title must be present' do
      let(:attributes) { super().merge :title => nil }

      it { expect(instance).to have_errors.on(:title).with_message("can't be blank") }
    end # describe

    describe 'slug must be present' do
      let(:attributes) { super().merge :slug => nil }

      it { expect(instance).to have_errors.on(:slug).with_message("can't be blank") }
    end # describe
  end # describe
end # describe
