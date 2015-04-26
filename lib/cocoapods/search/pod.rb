module Cocoapods::Search
  class Pod
    attr_accessor :name, :star_count, :fork_count

    def score
      if github?
        @star_count + @fork_count * 5
      else
        0
      end
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
