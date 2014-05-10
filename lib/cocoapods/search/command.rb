# coding: utf-8
require 'thor'

module Cocoapods::Search
  class Command < Thor
    map '-v' => :version,
        '--version' => :version

    default_command :search

    desc :version, 'Show version'
    def version
      say "cocoapods-search version: #{VERSION}", :green
    end

    desc 'search [NAME]', 'Search cocopapods'
    def search(name = nil)
      return invoke :help unless name
      cs = Executor.new
      cs.search(name)
    rescue LibraryNotFound => e
      say e.message, :red
      abort
    rescue OldRepositoryError => e
      # repository 更新時はエラーとする
      say '[cocoapods-search] Plz update your repository and retry.', :red
      say e.message
      abort
    rescue PodError => e
      say e.message
      abort
    end

    private
      def method_missing(name)
        Command.start ['search', name.to_s]
      end
  end
end