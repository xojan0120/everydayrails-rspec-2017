source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.1'
gem 'sqlite3'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# 開発環境とテスト環境で使用するgem
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.15.2'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper' # capybaraでchromedriverによるjavascriptをサポートするため

  # "~> 3.6.0"の意味は"3.6.0以上3.7.0未満の最新のものを使用する"
  gem 'rspec-rails', '~> 3.6.0'
  gem 'factory_bot_rails', "~> 4.10.0"

  # guard関連
  gem 'guard'
  gem 'guard-rspec', require: false
end

# 開発環境のみで使用するgem
group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'faker', require: false # for sample data in development

  # binstubを使うために必要
  gem 'spring-commands-rspec'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bootstrap-sass'
gem 'jquery-rails'
gem 'devise'
gem 'paperclip'
gem 'geocoder'
