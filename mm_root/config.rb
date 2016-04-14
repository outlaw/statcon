require 'active_support/all'
require 'bourbon'
require 'neat'
require 'font-awesome-sass'
###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

STATUSES = ['Major Outage', 'Degredated Performance', 'All Systems Nominal']

helpers do
  def statcon(app_id)
    app_events(app_id).select{ |event| event.closed_at.nil? }.any? ? 1 : 3
  end

  def statcon_in_words(statcon)
    ['fail', 'warning', 'healthy'][statcon-1]
  end

  def event_is_on_day?(event:, date:)
    created_at = event.created_at.at_midnight
    closed_at = event.closed_at || Time.now.at_end_of_day
    date >= created_at && date <= closed_at
  end

  def app_events(app_id, date: nil)
    data.events.select do |event|
      event.apps.include?(app_id) &&
      (date.nil? || event_is_on_day?(event: event, date: date))
    end
  end

  def history(app_id, days: 90)
    days.times.map do |day|
      day_events = app_events(app_id, date: day.days.ago)
      {
        date: Time.now.at_midnight,
        events: day_events,
        statcon: day_events.any? ? 1 : 3
      }
    end
  end

  def downtime(app_id, days: 90)
    app_events(app_id).map do |event|
      event = event.closed_at.nil? || event.closed_at >= days.days.ago
      
    end
  end

  def system_statcon
    data.apps.any? do |app|
      statcon(app.id) == 1
    end ? 1 : 3
  end

  def current_outage?
    system_statcon != 3
  end

  def system_status
    STATUSES[system_statcon - 1]
  end
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
