require File.expand_path('../../test_helper', __FILE__)

# The hook puts the timer scripts into every page's head; timer.js then adds its button
# next to the hours field (tested end-to-end in the deployment repo, tools/e2e).
class TimerAssetsTest < ActionController::TestCase
  tests TimelogController
  include TimelogTimerTestHelper
  fixtures :projects, :users, :email_addresses, :user_preferences, :members, :member_roles,
           :roles, :enabled_modules, :trackers, :projects_trackers, :issues, :issue_statuses,
           :enumerations, :time_entries

  def setup
    @request.session[:user_id] = 2
  end

  def script_srcs
    css_select('script[src]').map { |s| s['src'] }
  end

  def test_log_time_form_includes_the_timer_scripts
    timer_get :new, :project_id => 1
    assert_response :success
    assert_select '#time_entry_hours'
    assert script_srcs.any? { |src| src.include?('/plugin_assets/timelog_timer/javascripts/timer.js') }
    assert script_srcs.any? { |src| src.include?('/plugin_assets/timelog_timer/javascripts/store.js') }
  end

  def test_german_users_get_the_german_strings
    User.find(2).update_column(:language, 'de')
    timer_get :new, :project_id => 1
    assert_response :success
    assert script_srcs.any? { |src| src.include?('/plugin_assets/timelog_timer/javascripts/i18n/de.js') }
  end

  def test_english_users_get_no_translation_file
    User.find(2).update_column(:language, 'en')
    timer_get :new, :project_id => 1
    assert_response :success
    assert script_srcs.none? { |src| src.include?('/i18n/') }
  end
end
