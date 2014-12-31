# app/models/settings/navigation_list_setting.rb

class NavigationListSetting < Setting
  validate :value_must_be_a_hash_of_labels_and_urls

  private

  def value_must_be_a_hash_of_labels_and_urls
    errors.add(:value, 'must be a hash') and return unless value.is_a?(Hash)

    value.each do |label, url|
      value_label_must_be_present(label)

      value_url_must_be_present(url)
    end # each
  end # method value_must_be_a_hash_of_labels_and_urls

  def value_label_must_be_present label
    errors.add(:value, "label can't be blank") if label.blank?
  end # method value_label_must_be_present

  def value_url_must_be_present url
    errors.add(:value, "url can't be blank") if url.blank?
  end # method value_url_must_be_present
end # class
