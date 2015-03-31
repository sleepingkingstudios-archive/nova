# app/forms/form.rb

class Form < ResourceDecorator
  def assign_attributes params
    resource.assign_attributes(resource_params params)
  end # method assign_attributes

  def resource_params params
    params.fetch(resource_key, {}).permit(*permitted_params)
  end # method resource_params

  def update_attributes params
    assign_attributes(params)

    resource.save
  end # method update_attributes
  alias_method :update, :update_attributes

  private

  def permitted_params
    []
  end # method permitted_params
end # class
