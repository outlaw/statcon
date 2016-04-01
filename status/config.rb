require 'active_support/all'
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

helpers do
  def statcon(app_id)
    app_events(app_id).select{ |event| event.closed_at.nil? }.any? ? 1 : 3
  end

  def statcon_in_words(statcon)
    ['fail', 'warning', 'healthy'][statcon-1]
  end

  def app_events(app_id)
    data.events.select do |event|
      event.apps.include?(app_id)
    end
  end

  def history(app_id, days: 90)
    events = app_events(app_id)
    days.times.map do |day|
      start_time = (day.days.ago).at_midnight
      end_time = (day.days.ago).at_end_of_day

      day_events = events.select do |event|
        created_at = event.created_at
        closed_at = event.closed_at.present? && event.closed_at

        if closed_at
          (created_at >= start_time && created_at <= end_time) ||
          (event.closed_at >= start_time && event.closed_at <= end_time)
        else
          start_time >= created_at
        end
      end
      {
        date: Time.now.at_midnight,
        events: day_events,
        statcon: day_events.any? ? 1 : 3
      }
    end
  end

  def system_statcon
    data.apps.any? do |app|
      statcon(app.id) == 1
    end ? 1 : 3
  end

  def current_outage?
    system_statcon == 1
  end

  def system_status
    current_outage? ? "Major Outage" : "All Systems Nominal"
  end
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
