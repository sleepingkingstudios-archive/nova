class ManyRelationValidator < ActiveModel::Validator
  def validate record
    return if record.errors[relation_name].blank?

    record.errors[relation_name].delete 'is invalid'
    record.errors.delete(relation_name) if record.errors[:items].blank?

    documents.each.with_index do |document, index|
      next if document.valid?

      document.errors.each do |attribute, message|
        record.errors.add error_key(document, index, attribute), message
      end # each
    end # each
  end # method validate

  private

  def documents
    @record.send(children_name)
  end # method documents

  def error_key document, index, attribute
    :"#{relation_name}[#{index}][#{attribute}]"
  end # method relation_key

  def relation_name
    :relations
  end # method relation_name
end # class
