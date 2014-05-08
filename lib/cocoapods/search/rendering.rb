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

      def render_to_header
        f=DEFAULT_RULED_LINE_SIZE.dup
        fmt = "%-#{f[0]}s %#{f[1]}s %#{f[2]}s %#{f[3]}s"
        puts fmt % ['Name(Ver)', 'Score', 'Star', 'Fork']
        puts fmt % ['-'*f[0], '-'*f[1], '-'*f[2], '-'*f[3]]
      end

      def render_to_body(pods)
        f=DEFAULT_RULED_LINE_SIZE.dup
        fmt = "%-#{f[0]}s %#{f[1]}s %#{f[2]}s %#{f[3]}s"
        pods.each { |pod| puts fmt % pod.to_a }
      end
  end
end