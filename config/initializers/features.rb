# config/initializers/features.rb

# Auto-require all models in the app/models/features directory. Once required,
# each feature is responsible for registering itself using Directory::feature,
# which should be done immediately inside the class definition.
Dir[Rails.root.join 'app', 'models', 'features', '**', '*.rb'].each do |file|
  require file
end # each
