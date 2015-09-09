require 'god'
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
          God.watch do |w|
            w.name = process["name"]
            w.start = process["start"].nil? ? "service #{process["name"]} start" : process["start"]
            w.stop = process["stop"].nil? ? "service #{process["name"]} stop" : process["stop"]
            w.restart = process["restart"].nil? ? "service #{process["name"]} restart" : process["restart"]
            w.pid_file = process["pid_file"].nil? ? "/var/run/#{process["name"]}/#{process["name"]}.pid" : process["pid_file"]
            w.interval = process["interval"].nil? ? 30.seconds : process["interval"]
            w.start_grace = 10.seconds
            w.restart_grace = 10.seconds

            # clean PID file if needed
            w.behavior(:clean_pid_file)

            # determine the state on startup
            w.transition(:init, { true => :up, false => :start }) do |on|
              on.condition(:process_running) do |c|
                c.running = true
              end
            end

            # determine when process has finished starting
            w.transition([:start, :restart], :up) do |on|
              on.condition(:process_running) do |c|
                c.running = true
              end

              # failsafe
              on.condition(:tries) do |c|
                c.times = 5
                c.transition = :start
              end
            end

            # start if process is not running
            w.transition(:up, :start) do |on|
              on.condition(:process_exits) do |c|
                c.notify = process["notify"].nil? ? 'admin' : process["notify"]
              end
            end

            # lifecycle
            w.lifecycle do |on|
              on.condition(:flapping) do |c|
                c.to_state = [:start, :restart]
                c.times = 5
                c.within = 5.minute
                c.transition = :unmonitored
                c.retry_in = 10.minutes
                c.retry_times = 5
                c.retry_within = 2.hours
                c.notify = process["notify"].nil? ? 'admin' : process["notify"]
              end
            end
          end
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
          w = God.watches[process["name"]]
          God.unwatch w
        else
          raise UnknownFilename, "File #{file} is not supported. Should be .god or .yml"
        end
      end
    end
  end
end
