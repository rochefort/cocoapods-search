require 'mechanize'

module Cocoapods::Search
  class Pod
    attr_accessor :name, :star_count, :fork_count, :has_github

    def initilaize
      @has_github = false
    end

    def score
      if @has_github
        @star_count + @fork_count * 5
      else
        0
      end
    end

    def to_a
      if @has_github
        [@name, score.to_s, @star_count.to_s, @fork_count.to_s]
      else
        [@name, '-', '-', '-', '-']
      end
    end
  end
end