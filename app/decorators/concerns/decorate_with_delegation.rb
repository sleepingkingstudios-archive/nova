# app/decorators/concerns/decorate_with_delegation.rb

module DecorateWithDelegation
  def respond_to? symbol, include_all = false
    __delegate__.respond_to?(symbol, include_all) || super
  end # method respond_to?

  private

  def __delegate__
    object
  end # method __delegate__

  def method_missing symbol, *args
    __delegate__.send symbol, *args
  end # method method_missing
end # module
