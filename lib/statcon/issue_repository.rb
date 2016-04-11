require 'octokit'

module Statcon
  class IssueRepository
    def get_issues(token:, repo:)
      client = Octokit::Client.new(access_token: token)
      issues = { repo => client.issues(repo).map { |i| i.to_h } }
      issues[repo].map { |i| { id: i[:id], apps: i[:labels].map { |a| a[:name] }, created_at: i[:created_at], updated_at: i[:updated_at], closed_at: i[:closed_at] } }
    end
  end
end
