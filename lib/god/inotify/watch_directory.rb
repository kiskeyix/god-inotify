require 'rb-inotify'

module God
  module Inotify
    class WatchDirectory
      def initialize(opts={})
        @notifier = INotify::Notifier.new
        @god = opts[:god]
      end
      # runs a loop to watch over all configured directories for changes
      def watch_directories
        return unless @god.responds_to? :watch and @god.responds_to? :unwatch

        # parse YAML
        @notifier.watch "/etc/god/processes", :create,
          :moved_to, :moved_from, :delete do |event|
          case event.name
          when "delete"
            @god.unwatch do
            end
          else
            @god.watch do
            end
          end
        end

        # god native file format
        @notifier.watch "/etc/god/conf.d", :create,
          :moved_to, :moved_from, :delete do |event|
          case event.name
          when "delete"
            # TODO reload all?
            @god.unwatch do
            end
          else
            @god.watch do
            end
          end
        end
      end
      def run
        @notifier.run
      end
      def process
        @notifier.process
      end
      def stop
        @notifier.stop
      end
    end
  end
end
