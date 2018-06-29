module TrlnArgon
  module TrlnControllerBehavior
    extend ActiveSupport::Concern

    included do
      configure_blacklight do |config|
        config.search_builder_class = DefaultTrlnSearchBuilder
      end

      def local_filter_applied?
        false
      end
    end
  end
end
