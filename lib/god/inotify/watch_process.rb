require 'yaml'

module God
  module Inotify
    class NameRequired < StandardError
    end
    class UnknownFilename < StandardError
    end
    class WatchProcess
      def initialize(opts={})
      end
      def watch(file)
        if file =~ /\.god$/
          # just load
        elsif file =~ /\.yml$/
          # parse and create watch
          process = YAML.load_file file
          raise NameRequired, "+name+ is a required attribute in file #{file}" if process['name'].nil?
        else
          raise UnknownFilename, "File #{file} is not supported. Should be .god or .yml"
        end
      end
      def unwatch(file)
        if file =~ /\.god$/
          # just unload this process
        elsif file =~ /\.yml$/
          # parse and unwatch this process
          process = YAML.load_file file
          raise NameRequired, "+name+ is a required attribute in file #{file}" if process['name'].nil?
        else
          raise UnknownFilename, "File #{file} is not supported. Should be .god or .yml"
        end
      end
    end
  end
end
