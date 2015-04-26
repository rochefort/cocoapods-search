module Cocoapods
  module Search
    class LibraryNotFound < StandardError; end
    class OldRepositoryError < StandardError; end
    class PodError < StandardError; end

    autoload :Command,   'cocoapods/search/command'
    autoload :Executor,  'cocoapods/search/executor'
    autoload :Pod,       'cocoapods/search/pod'
    autoload :Rendering, 'cocoapods/search/rendering'
    autoload :VERSION,   'cocoapods/search/version'
  end
end
