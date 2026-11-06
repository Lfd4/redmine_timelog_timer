# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

module TimelogTimerTestHelper
  # Functional GET that works on Rails 4.2 (Redmine 3.x) and Rails 5+ (Redmine 4+).
  def timer_get(action, params = {})
    if Rails::VERSION::MAJOR >= 5
      get action, :params => params
    else
      get action, params
    end
  end
end
