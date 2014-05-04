require 'mechanize'

module Cocoapods::Search
  class Cli
    include Cocoapods::Search::Rendering

    def initialize(keyword)
      @keyword = keyword
      @agent = Mechanize.new
    end

    def search
      pods = get_pods
      pods.sort!{ |x,y| [y.score, x.name.upcase] <=> [x.score, y.name.upcase] }
      Cli.render(pods)
    end

    private
      def get_pods
        pods = []
        pod_search.each do |result|
          pod = Pod.new
          pod.name = result.lines[0].strip
          result.lines do |line|
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
        pod_search_result = `pod search #{@keyword}`
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