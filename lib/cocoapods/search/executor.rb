require 'mechanize'
require 'open3'
require 'uri'

module Cocoapods::Search
  class Executor
    def initialize
      @agent = Mechanize.new
      proxy = URI.parse(ENV['http_proxy']) if ENV['http_proxy']
      @agent.set_proxy(proxy.host, proxy.port, proxy.user, proxy.password) if proxy
    end

    def search(keyword)
      print 'Searching '
      @keyword = keyword
      pods = search_pods { print '.' }
      pods.sort! { |x, y| [y.score, x.name.upcase] <=> [x.score, y.name.upcase] }
      puts
      pods
    end

    private

    def search_pods
      pods = []
      pod_search.each do |result|
        pod = Pod.new
        first_line = result.lines.to_a[0].strip
        pod.name = first_line
        result.lines.each do |line|
          if line =~ %r{- Source:\s+(https?://github.*)\.git}
            github_url = $1
            pod.star_count, pod.fork_count = scrape_social_score(github_url) { yield }
            pod.has_github = true if pod.star_count || pod.fork_count
          end
        end
        pods << pod
      end
      pods
    end

    def pod_search
      result, error, status = Open3.capture3("pod search --no-ansi #{@keyword}")
      fail LibraryNotFound, result if result =~ /Unable to find a pod with name matching/
      fail OldRepositoryError, result if result =~ /Setting up CocoaPods master repo/
      fail PodError, "#{result} #{error}" unless status.success?
      pods = result.split(/\n{2,3}->/)
      pods.delete('')
      pods
    end

    # @return [Array] star_count and fork_count
    def scrape_social_score(url)
      yield
      page = @agent.get(url)
      page.search('.social-count').map { |elm| elm.text.strip.gsub(',', '').to_i }
      rescue Mechanize::ResponseCodeError
        return nil
    end
  end
end
