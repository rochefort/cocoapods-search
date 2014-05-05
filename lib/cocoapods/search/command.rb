require 'thor'

module Cocoapods::Search
  class Command < Thor
    map '-v' => :version,
        '--version' => :version

    option :from, :required => true

    default_command :search

    desc :version, 'Show version'
    def version
      say "cocoapods-search version: #{VERSION}", :green
    end

    desc 'search [NAME]', 'Search cocopapods'
    def search(name = nil)
      return invoke :help unless name
      cs = Cocoapods::Search::Cli.new(name)
      cs.search
    end

    private
      def method_missing(name)
        Command.start ['search', name.to_s]
      end
  end
end