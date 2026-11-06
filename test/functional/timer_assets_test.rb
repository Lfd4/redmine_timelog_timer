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

  # Plugin script URL: /plugin_assets/timelog_timer/javascripts/timer.js up to Redmine 5,
  # /assets/plugin_assets/timelog_timer/timer-<digest>.js on Redmine 6 (Propshaft).
  def plugin_script?(name)
    pattern = %r{/plugin_assets/timelog_timer/(javascripts/)?#{Regexp.escape(name)}(-\h+)?\.js}
    script_srcs.any? { |src| src =~ pattern }
  end

  def test_log_time_form_includes_the_timer_scripts
    timer_get :new, :project_id => 1
    assert_response :success
    assert_select '#time_entry_hours'
    assert plugin_script?('timer'), script_srcs.inspect
    assert plugin_script?('store'), script_srcs.inspect
  end

  def test_german_users_get_the_german_strings
    User.find(2).update_column(:language, 'de')
    timer_get :new, :project_id => 1
    assert_response :success
    assert plugin_script?('i18n/de'), script_srcs.inspect
  end

  def test_english_users_get_no_translation_file
    User.find(2).update_column(:language, 'en')
    timer_get :new, :project_id => 1
    assert_response :success
    assert script_srcs.none? { |src| src.include?('/i18n/') }
  end
end
