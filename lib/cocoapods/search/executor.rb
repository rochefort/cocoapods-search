# -*- coding: utf-8 -*-
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
      pod_search.map do |result|
        pod = Pod.new
        pod.name = result.lines.to_a[0].strip
        github_url = extract_github_url(result)
        if github_url
          pod.star_count, pod.fork_count = scrape_social_score(github_url) { yield }
        end
        pod
      end
    end

    # pod searchの結果を 改行+`=>` で分割する
    # @return [Array] pod
    def pod_search
      result, error, status = Open3.capture3("pod search --no-ansi #{@keyword}")
      fail LibraryNotFound, result if result =~ /Unable to find a pod with name matching/
      fail OldRepositoryError, result if result =~ /Setting up CocoaPods master repo/
      fail PodError, "#{result} #{error}" unless status.success?
      pods = result.split(/\n{2,3}->/)
      pods.delete('')
      pods
    end

    def extract_github_url(result)
      result.lines.each do |line|
        return $1 if line =~ %r{- Source:\s+(https?://github.*)\.git}
      end
      nil
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
