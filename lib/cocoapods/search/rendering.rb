module Cocoapods::Search
  module Rendering
    DEFAULT_RULED_LINE_SIZE = [40, 6, 5, 5]

    def self.included(base)
      base.extend(self)
    end

    def render(pods)
      set_ruled_line_size(pods)
      render_to_header
      render_to_body(pods)
    end

    private
      def set_ruled_line_size(pods)
        max_pod_name_size = pods.max_by { |pod| pod.name.size }.name.size
        if max_pod_name_size > DEFAULT_RULED_LINE_SIZE[0]
          DEFAULT_RULED_LINE_SIZE[0] = max_pod_name_size
        end
      end

      def render_with
        f = DEFAULT_RULED_LINE_SIZE.dup
        fmt = "%-#{f[0]}s %#{f[1]}s %#{f[2]}s %#{f[3]}s"
        yield(f, fmt)
      end

      def render_to_header
        render_with do |fields, fmt|
          puts fmt % ['Name(Ver)', 'Score', 'Star', 'Fork']
          puts fmt % fields.map{ |f| '-'*f }
        end
      end

      def render_to_body(pods)
        render_with do |fields, fmt|
          pods.each { |pod| puts fmt % pod.to_a }
        end
      end
  end
end
