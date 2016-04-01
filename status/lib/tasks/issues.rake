require 'octokit'
require 'yaml'
# require 'dotenv'
require 'pry'

namespace :issues do
  desc 'Updates local data from GitHub issues'
  task :update do
    puts "Updating issues data from GitHub"
    token  = ENV['GITHUB_TOKEN']
    repos  = ['hooroo/hooroo-status']
    client = Octokit::Client.new(access_token: token)

    issues = Hash[repos.map do |repo|
      print "."
      STDOUT.flush
      [repo, client.issues(repo).map { |i| i.to_h }]
    end]

    puts "\nDone"
    puts "Writing events"

    data_dir = File.join(File.dirname(__FILE__), '..', '..', 'data')
    filename = File.join(data_dir, 'events.yml')
    File.open(filename, 'w') do |fp|
      fp.puts YAML.dump(issues[repos.first].map { |i| { id: i[:id], apps: i[:labels].map { |a| a[:name] }, created_at: i[:created_at], updated_at: i[:updated_at], closed_at: i[:closed_at] } })
    end
    puts "Done"
  end
end
