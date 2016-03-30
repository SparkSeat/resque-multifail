module Resque
  module Plugins
    # Plugin for clearing failures after a successful run
    module Multifail
      def after_perform(*args)
        Resque::Failure::Multifail.clear_failures('class' => self, 'args' => args)
      end
    end
  end
end
