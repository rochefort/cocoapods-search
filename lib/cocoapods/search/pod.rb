module Cocoapods::Search
  class Pod
    attr_accessor :name, :star_count, :fork_count

    def initialize
      @star_count, @fork_count = nil, nil
    end

    def score
      github? ? (@star_count + @fork_count * 5) : 0
    end

    def to_a
      if github?
        [@name, score.to_s, @star_count.to_s, @fork_count.to_s]
      else
        [@name, '-', '-', '-']
      end
    end

    private

    def github?
      @star_count || @fork_count
    end
  end
end
