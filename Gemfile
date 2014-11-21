source 'https://rubygems.org'

gem 'rails', '4.1.7'

### App Server ###
gem 'thin'

### Datastore ###
gem 'mongoid',                       '~> 4.0.0'
gem 'mongoid-sleeping_king_studios', '~> 0.7', '>= 0.7.9', :git => 'https://github.com/sleepingkingstudios/mongoid-sleeping_king_studios.git', :branch => 'feature-scoped-ordering'

### Authentication ###
gem 'devise', '~> 3.4.1'

### JS Runtime ###
gem 'therubyracer', '~> 0.12.1'

### Assets ###
gem 'haml-rails',           '~> 0.5.3'
gem 'less-rails',           '~> 2.6.0'
gem 'less-rails-bootstrap', '~> 3.3.1'
gem 'coffee-rails',         '~> 4.1.0'
gem 'jquery-rails',         '~> 3.1.2'
gem 'uglifier',             '>= 1.3.0' # Compressor for JavaScript assets.

### Content ###
gem 'github-markdown', '~> 0.6.7'

### Support ###
gem 'jbuilder',                    '~> 2.0' # Build JSON APIs. Read more: https://github.com/rails/jbuilder
gem 'sleeping_king_studios-tools', '~> 0.1.2'

### Testing ###
group :development, :test do
  gem 'rake', '~> 10.3.2' # Required for Travis-CI.

  gem 'rspec',                       '~> 3.1'
  gem 'rspec-rails',                 '~> 3.1'
  gem 'rspec-collection_matchers',   '~> 1.1.2'
  gem 'rspec-sleeping_king_studios', '>= 2.0.0.rc.0'

  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'database_cleaner',   '~> 1.3.0'

  gem 'pry', '~> 0.10.1'
end # group

### Production ###
group :production do
  gem 'rails_12factor', '~> 0.0.3' # Required for Heroku deployment.
end # group

ruby "2.1.5"
