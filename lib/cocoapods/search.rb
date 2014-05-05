require 'rubygems'

module Cocoapods
  module Search
  class LibraryNotFound < LoadError; end

    autoload :Cli,       'cocoapods/search/cli'
    autoload :Pod,       'cocoapods/search/pod'
    autoload :Rendering, 'cocoapods/search/rendering'
    autoload :VERSION,   'cocoapods/search/version'
  end
end
