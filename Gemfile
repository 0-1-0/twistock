# This's magic string. It makes code faster, better and annihilate bugs! >_<

source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'compass-rails'
  gem 'zurb-foundation'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'skim'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platform: :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'clockwork'

# Оказывается SLIM быстрее HAML
gem 'slim-rails'
gem 'slim', '~> 1.2.2'

# simple_form избавляет от головной боли
gem 'simple_form'

#интернационализация js-кода
gem 'i18n-js'

# хороший русификатор
gem 'russian'

# аутентификация
gem 'omniauth'
gem 'omniauth-twitter'

# twitter API
gem 'twitter','2.2.0'

# для графиков
gem "highcharts-rails", "~> 2.3.0"

# очередь для обработки тяжелых запросов
gem 'sidekiq'
# требуется для его веб-интерфейса
gem 'sinatra'

# более наглядный код запросов
gem 'squeel'

# парсинг accept-language из запросов
gem 'http_accept_language'

# Автодетекция языка
gem 'wtf_lang'

# Ебанем по неуклюжему JS!
gem 'rails-backbone'
gem 'masonry-rails'

# полезные для разработки утилиты
group :development do
  gem 'looksee'
  gem 'rails_best_practices'
  gem 'quiet_assets'
  gem 'thin'

  gem 'meta_request', '0.2.0' # for rails panel chrome plugin
end

# --- BDD фреймворки

# rspec для тестирования моделей и контроллеров
group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'

  gem 'faker'
  gem 'shoulda-matchers'

  gem 'database_cleaner'

  gem 'spork', '~> 1.0rc'
  gem "guard-spork"
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


gem 'newrelic_rpm'

#Для рассылки email'ов
gem 'pony'