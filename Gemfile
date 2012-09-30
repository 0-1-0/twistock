source 'https://rubygems.org'

gem 'rails', '3.2.7'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'coffee-rails', '~> 3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  #gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'
  # Я не умею верстать
  gem "twitter-bootstrap-rails", "2.1.0"
end

gem 'jquery-rails'
gem 'jquery-datatables-rails'

# Оказывается SLIM быстрее HAML
gem 'slim'
gem 'slim-rails'
gem 'less-rails'

# simple_form избавляет от головной боли
gem 'simple_form'

# аутентификация
gem 'omniauth'
gem 'omniauth-twitter'

# twitter API
gem 'twitter','2.2.0'

# очередь для обработки тяжелых запросов
gem 'sidekiq'
# требуется для его веб-интерфейса
gem 'sinatra'

# более наглядный код запросов
gem 'squeel'

# полезные для разработки утилиты
group :development do
  gem 'looksee'
  gem 'rails_best_practices'
end

# --- BDD фреймворки

# cucumber для интерфейса
group :test do
  gem 'cucumber-rails'
  gem 'capybara'
end

# rspec для тестирования моделей и контроллеров
group :test, :development do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

#для графиков
gem 'gchartrb', :require => 'google_chart'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# мониторинг
gem 'newrelic_rpm','3.4.1'

# парсинг accept-language из запросов
gem 'http_accept_language'

#интернационализация js-кода
gem 'i18n-js'
