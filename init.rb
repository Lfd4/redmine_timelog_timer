
Redmine::Plugin.register :timelog_timer do
  name 'Timelog Timer plugin'
  author 'Behigh'
  description 'A simple javascript timer for Hours field in timelog form'
  version '2.0.0-lfda.1'
  url 'https://github.com/behigh/redmine_timelog_timer.git'
#  author_url 'http://example.com/about'
end

# Load the hook listener (lib/timelog_timer_hook_listener.rb) by its constant: autoloaded on
# Redmine 3/4 (lib/ on the autoload path) and Redmine 5+ (Zeitwerk; init.rb then runs
# inside to_prepare, so loading it here is fine). require_dependency fails on Redmine 5+.
if Rails.respond_to?(:autoloaders)
  TimelogTimerHookListener
else
  Rails.configuration.to_prepare { TimelogTimerHookListener }
end
