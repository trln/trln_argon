module Blacklight
  module Rendering
    class Join < AbstractStep
      def render
        options = config.separator_options || '<br />'
        next_step(values.map { |x| html_escape(x) }.join(options).html_safe)
      end

      private

      def html_escape(*args)
        ERB::Util.html_escape(*args)
      end
    end
  end
end
