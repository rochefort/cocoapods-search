require 'mechanize'
require 'open3'
require 'uri'

module Cocoapods::Search
  class Cli
    include Cocoapods::Search::Rendering

    def initialize
      @agent = Mechanize.new
      proxy = URI.parse(ENV['http_proxy']) if ENV['http_proxy']
      if proxy
        @agent.set_proxy(proxy.host, proxy.port, proxy.user, proxy.password)
      end
    end

    def search(keyword)
      @keyword = keyword
      pods = get_pods
      pods.sort!{ |x,y| [y.score, x.name.upcase] <=> [x.score, y.name.upcase] }
      Cli.render(pods)
    end

    private
      def get_pods
        pods = []
        pod_search.each do |result|
          pod = Pod.new
          first_line = result.lines.to_a[0].strip
          # if searching result is nothing
          raise LibraryNotFound, first_line if first_line =~ /Unable to find a pod with name matching/
          pod.name = first_line
          result.lines.each do |line|
            if line =~ /- Source:\s+(https?:\/\/.*)\.git/
              github_url = $1
              pod.star_count, pod.fork_count = scrape_social_score(github_url)
              pod.has_github = true
            end
          end
          pods << pod
        end
        pods
      end

      def pod_search
        # TODO: status is unused variable
        pod_search_result, status = Open3.capture2("pod search #{@keyword}")
        pods = pod_search_result.split(/\n{2,3}->/)
        pods.delete("")
        pods
      end

      def scrape_social_score(url)
        page = @agent.get(url)
        page.search(".social-count").map{ |elm| elm.text.strip.gsub(',', '').to_i }
      end
  end
end