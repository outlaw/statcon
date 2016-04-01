require 'octokit'
require 'yaml'
require 'dotenv'
require 'pry'

token  = ENV['GITHUB_TOKEN']
repos  = ['hooroo/hooroo-status']
client = Octokit::Client.new(access_token: token)
issues = Hash[repos.map do |repo|
  [repo, client.issues(repo).map { |i| i.to_h }]
end]

puts YAML.dump(issues[repos.first].map { |i| { id: i[:id], apps: i[:labels].map { |a| a[:name] }, created_at: i[:created_at], updated_at: i[:updated_at], closed_at: i[:closed_at] } })
