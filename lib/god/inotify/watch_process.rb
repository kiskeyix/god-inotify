module God
  module Inotify
    class NameRequired < StandardError
    end
    class UnknownFilename < StandardError
    end
    class WatchProcess
      def initialize(opts={})
        @name = opts[:name]
        raise NameRequired, "+name+ is a required attribute" unless @name.nil?
      end
      def watch(file)
        if file =~ /\.god$/
          # just load
        elsif file =~ /\.yml$/
          # parse and create watch
        else
          raise UnknownFilename, "File #{file} is not supported. Should be .god or .yml"
        end
      end
      def unwatch(file)
        if file =~ /\.god$/
          # just unload this process
        elsif file =~ /\.yml$/
          # parse and unwatch this process
        else
          raise UnknownFilename, "File #{file} is not supported. Should be .god or .yml"
        end
      end
    end
  end
end
