# spec/models/features/page_spec.rb

require 'rails_helper'

RSpec.describe Page, :type => :model do
  let(:attributes) { attributes_for(:page) }
  let(:instance)   { described_class.new attributes }

  shared_context 'with generic content', :content => :one do
    let(:content)    { build :page_content }
    let(:attributes) { super().merge :content => content }
  end # shared_context

  ### Attributes ###

  describe '#title' do
    it { expect(instance).to have_property(:title) }
  end # describe

  describe '#slug' do
    let(:value) { attributes_for(:page).fetch(:title).parameterize }

    it { expect(instance).to have_property :slug }

    it 'is generated from the title' do
      expect(instance.slug).to be == instance.title.parameterize
    end # it

    it 'sets #slug_lock to true' do
      expect { instance.slug = value }.to change(instance, :slug_lock).to(true)
    end # it
  end # describe

  describe '#slug_lock' do
    it { expect(instance).to have_property :slug_lock }
  end # describe

  ### Relations ###

  describe '#content' do
    it { expect(instance).to have_reader(:content).with(nil) }

    context 'with generic content', :content => :one do
      it { expect(instance.content).to be == content }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    context 'with generic content', :content => :one do
      it { expect(instance).to be_valid }
    end # context

    describe 'content must be present' do
      let(:attributes) { super().merge :content => nil }

      it { expect(instance).to have_errors.on(:content).with_message("can't be blank") }
    end # describe

    describe 'title must be present' do
      let(:attributes) { super().merge :title => nil }

      it { expect(instance).to have_errors.on(:title).with_message("can't be blank") }
    end # describe
  end # describe
end # describe
