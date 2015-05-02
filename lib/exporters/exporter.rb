# lib/exporters/exporter.rb

Dir[Rails.root.join 'lib', 'exporters', 'strategies', '*strategy.rb'].each do |file|
  require file
end # each

class Exporter
  class << self
    delegate :deserialize, :serialize, :export, :import, :to => :instance

    def instance
      @instance ||= new
    end # class method instance

    %w(serialize deserialize export import).each do |method_name|
      send :define_method, method_name do |*args, **kwargs, &block|
        instance.send method_name, *args, **kwargs, &block
      end # class method
    end # each
  end # eigenclass

  def deserialize object, **options
    object
  end # method deserialize

  def export object, strategy_name = nil, **options
    strategies[strategy_name || default_strategy].serialize(serialize object)
  end # method export

  def import string, strategy_name = nil, **options
    deserialize strategies[strategy_name || default_strategy].deserialize(string)
  end # method import

  def serialize object, **options
    object
  end # method serialize

  private

  def default_strategy
    :json
  end # method default_strategy

  def strategies
    @strategies ||= Hash.new { |hsh, key| "#{key.to_s.classify}ExportStrategy".constantize }
  end # method strategies
end # class
