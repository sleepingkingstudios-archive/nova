# app/models/setting.rb

class Setting
  include Mongoid::Document
  include Mongoid::Timestamps

  ### Class Methods ###
  class << self
    def fetch key, default = nil
      value = get(key)
      return value unless value.nil?

      return default unless default.nil?

      raise KeyError.new "key not found: #{key.inspect}"
    end # class method fetch

    def fetch_with_i18n_fallback key, default = nil
      value = get(key)
      return value unless value.nil?

      translated = translate(key)
      return translated unless translated.nil?

      return default unless default.nil?

      raise KeyError.new "key not found: #{key.inspect}"
    end # class method fetch_with_i18n_fallback

    def get key
      # TODO: Implement caching here.
      where(:key => key).first.try(:value)
    end # class method get

    private

    def translate key
      I18n.translate(key, :raise => true)
    rescue I18n::MissingTranslationData
      nil
    end # class method translate
  end # eigenclass

  ### Attributes ###
  field :key,               :type => String
  field :value,             :type => Object
  field :validate_presence, :type => Boolean

  ### Validations ###
  validates :key, :presence => true, :uniqueness => true

  validates :value, :presence => { :if => :validate_presence? }
end # class
