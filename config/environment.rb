# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Twitterexchange::Application.initialize!

logger = Logger.new('updateworker.log')
