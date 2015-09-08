require 'rb-inotify'

module God
  module Inotify
    class WatchDirectory
      attr_accessor :root
      def initialize(opts={})
        @notifier = INotify::Notifier.new
        @god = opts[:god]
        @root = opts[:root] || '/'
      end
      # configures notifier
      def watch_directories
        return unless @god.respond_to? :watch and
          @god.respond_to? :unwatch
        @notifier.watch File.join(@root,"etc","god","processes"), :create,
          :moved_to, :moved_from, :delete do |event|
          handle_event event
        end
        @notifier.watch File.join(@root,"etc","god","conf.d"), :create,
          :moved_to, :moved_from, :delete do |event|
          handle_event event
        end
      end
      # runs a loop to process all events on configured directories
      def run
        @notifier.run
      end
      # process all events for configured directories
      def process
        @notifier.process
      end
      def stop
        @notifier.stop
      end
      private
      def handle_event(event)
        if event.flags.include? :delete or
          event.flags == [:move_from, :move]
          @god.unwatch event.absolute_name
        else
          @god.watch event.absolute_name
        end
      end
    end
  end
end
