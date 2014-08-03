source 'https://rubygems.org'

gem 'rails', '4.1.4'

### App Server ###
gem 'unicorn'

### Datastore ###
gem 'mongoid',                       '~> 4.0.0'
gem 'mongoid-sleeping_king_studios', '~> 0.7', '>= 0.7.9'

### Authentication ###
gem 'devise', '~> 3.2.4'

### Assets ###
gem 'haml-rails',   '~> 0.5.3'
gem 'sass-rails',   '~> 4.0.3'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails', '~> 3.1.1'
gem 'uglifier',     '>= 1.3.0' # Compressor for JavaScript assets.

### Content ###

### Support ###
gem 'jbuilder', '~> 2.0' # Build JSON APIs. Read more: https://github.com/rails/jbuilder

### App Preloader ###
gem 'spring', :group => :development

### Testing ###
group :development, :test do
  gem 'rake', '~> 10.3.2' # Required for Travis-CI.

  gem 'rspec-rails',                 '~> 3.0.2'
  gem 'rspec-collection_matchers',   '~> 1.0.0'
  gem 'rspec-sleeping_king_studios', '>= 2.0.0.beta.0'
  gem 'spring-commands-rspec',       '~> 1.0.2'

  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'database_cleaner',   '~> 1.3.0'
end # group

### Production ###
group :production do
  gem 'rails_12factor', '~> 0.0.2' # Required for Heroku deployment.
end # group

ruby "2.1.2"
