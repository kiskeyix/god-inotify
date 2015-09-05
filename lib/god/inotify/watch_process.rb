module God
  module Inotify
    class NameRequired < StandardError
    end
    class WatchProcess
      def initialize(opts={})
        @name = opts[:name]
        raise NameRequired, "+name+ is a required attribute" unless @name.nil?
      end
    end
  end
end
