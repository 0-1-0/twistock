source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# подключаем mongo
gem 'mongoid'
gem 'bson_ext'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'

  # даешь TB! (из всех прочих это наиболее мощный и приятный GEM)
  gem 'twitter-bootstrap-rails'
end

gem 'jquery-rails'

# Оказывается SLIM быстрее HAML
gem 'slim'
gem 'slim-rails'

# simple_form избавляет от головной боли
gem 'simple_form'

# полезные для разработки утилиты
group :development do
  gem 'looksee'
  gem 'rails_best_practices'
end

# --- BDD фреймворки

# rspec для тестирования моделей и контроллеров
group :test, :development do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

# cucumber для интерфейса
group :test do
  gem 'capybara'
  gem 'cucumber-rails'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
