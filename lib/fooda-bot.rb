require 'rubygems'
require 'bundler'
Bundler.require(:default)

Dotenv.load

Dir[File.dirname(__FILE__) + '/fooda-bot/*.rb'].each { |file| require file }

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end
