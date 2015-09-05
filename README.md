# God::Inotify

God inotify provides a system for quickly adding watches to godrb.

It follows "convention over documentation" approach to make it very easy to add
watches to your system.

When it detects changes to /etc/god/process, it does 2 things:

1. defines watches for each YAML file in this directory
2. triggers god to reload watches

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'god-inotify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install god-inotify

## Usage

If you're added a watch to apache2
```
gem install god
gem install god-inotify

cat > /etc/god/process/apache.yml <<-EOF
name: "apache2"
EOF
```

The above YAML configuration created under _/etc/god/process/apache2.yml_ translates to
the following god watch:

```ruby
God.watch do |w|
  w.name = "apache2"
  w.interval = 30.seconds # default
  w.start = "service apache2 start"
  w.stop = "service apache2 stop"
  w.restart = "service apache2 restart"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "/var/run/apache2/apache2.pid"
  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
        c.notify = 'admin'
    end
  end
end
```

You may change any of the values above by using the following configurations

## Configuration Values

  * "name" (required): this is the name of the service your watching
  * "pid\_file": full path to the location of the PID file written by your service.
    Defaults to `"/var/run/#{name}/#{name}.pid"`
  * "interval": time to wait to poll for actions. See godrb.com
  * "start": start command. Defaults to "service #{name} start"
  * "stop": stop command. Defaults to "service #{name} stop"
  * "restart": restart command. Defaults to "service #{name} restart"
  * "start\_grace": time to wait for process to start. Defaults to `10.seconds`
  * "restart\_grace": time to wait for process to restart. Defaults to `10.seconds`
  * "behavior": behavior to use after action is taken. Defaults to `:clean_pid_file`
  * "notify": notification to use. Defaults to 'admin'


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test`
to run the tests. You can also run `bin/console` for an interactive prompt that will allow
you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kiskeyix/god-inotify.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

