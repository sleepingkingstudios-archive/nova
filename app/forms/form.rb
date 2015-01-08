# app/forms/form.rb

class Form < ResourceDecorator
  def resource_params params
    params.fetch(resource_key, {}).permit(*permitted_params)
  end # method resource_params

  def update params
    resource.update_attributes(resource_params params)
  end # method update

  private

  def permitted_params
    []
  end # method permitted_params
end # class
