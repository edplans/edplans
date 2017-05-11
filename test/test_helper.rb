ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


require File.join(Rails.root, 'test', 'factories')

class ActiveSupport::TestCase

end
