# app/models/settings/string_setting.rb

class StringSetting < Setting
  validate :value_must_be_a_string

  private

  def value_must_be_a_string
    errors.add(:value, 'must be a string') unless value.is_a?(String)
  end # method value_must_be_a_string
end # class
