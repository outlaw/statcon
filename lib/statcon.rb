require 'statcon/version'
require_relative 'statcon/issue_repository'
require 'thor'

require 'middleman-core'
require 'middleman-core/logger'
require 'middleman-core/builder'
require 'middleman-core/application'
require 'middleman-core/profiling'
require 'fileutils'

module Statcon
  class App < Thor
    package_name "Statcon"

    desc "build", "build the thing"
    def build
      Dir.mktmpdir("mm_root") do |dest|
        mm_root = File.join(File.dirname(__FILE__), '..', 'mm_root')
        FileUtils.cp_r(mm_root, dest)

        tmp_mm_root = File.join(dest, 'mm_root')
        ENV['MM_ROOT'] = tmp_mm_root

        data_dir = File.join(tmp_mm_root, 'data')
        filename = File.join(data_dir, 'events.yml')
        FileUtils.mkdir_p(data_dir)

        File.open(filename, 'w') do |fp|
          fp.puts YAML.dump(IssueRepository.new.get_issues(repo: 'hooroo/hooroo-status', token: ENV['GITHUB_TOKEN']))
        end

        build_middleman
      end
    end

    protected

    def build_middleman
      @app = ::Middleman::Application.new do
        config[:mode] = :build
        config[:show_exceptions] = false
      end

      builder = Middleman::Builder.new(@app,
                                       glob: options['glob'],
                                       clean: options['clean'],
                                       parallel: options['parallel'])

      builder.on_build_event(&method(:on_event))
      builder.run!
    end

    def on_event(event_type, target, extra=nil)
      case event_type
      when :error
        say_status :error, target, :red
        shell.say extra, :red if options['verbose']
      when :deleted
        say_status :remove, target, :green
      when :created
        say_status :create, target, :green
      when :identical
        say_status :identical, target, :blue
      when :updated
        say_status :updated, target, :yellow
      else
        say_status event_type, extra, :blue
      end
    end
  end
end
