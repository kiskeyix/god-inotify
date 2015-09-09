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

To watch apache2 you can do the following

```terminal
gem install god
gem install god-inotify

mkdir -p /etc/god/conf.d
mkdir -p /etc/god/process

cat > /etc/god/master.god <<-EOF
God.load "/etc/god/conf.d/*.god"

God::Contacts::Email.defaults do |d|
  d.from_email = 'god@localhost'
  d.from_name = 'God'
  d.delivery_method = :sendmail
end
God.contact(:email) do |c|
  c.name = 'admin'
  c.to_email = 'webmaster@localhost'
end
EOF

cat > /etc/god/conf.d/god-inotify.god <<-EOF
require 'god-inotify'

# handle inotify events
Thread.new do
  gw = God::Inotify::WatchProcess.new
  ev = God::Inotify::WatchDirectory.new god: gw
  loop do
    ev.process
  end
end

EOF
```

Start god the way you normally would

```terminal
# start god
god -c /etc/god/master.god
```

Now you can freely add processes to watch by simply creating YAML
files in _/etc/god/process/_, e.g.:

```terminal
cat > /etc/god/process/apache2.yml <<-EOF
name: "apache2"
EOF
```

The above YAML configuration translates to
the following god watch:

```ruby
God.watch do |w|
  w.name = "apache2"
  w.interval = 30.seconds
  w.start = "service apache2 start"
  w.stop = "service apache2 start"
  w.restart = "service apache2 restart"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds

  w.pid_file = "/var/run/apache2/apache2.pid"
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
      c.notify = 'admin'
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
      c.notify = 'admin'
    end
  end
end
```

You may change any of the values above by using the following configurations

## Configuration Values

  * "name" (required): this is the name of the service your watching
  * "pid\_file": full path to the location of the PID file written by your service.
    Defaults to `/var/run/#{name}/#{name}.pid`
  * "interval": time to wait to poll for actions. See godrb.com
  * "start": start command. Defaults to `service #{name} start`
  * "stop": stop command. Defaults to `service #{name} stop`
  * "restart": restart command. Defaults to `service #{name} restart`
  * "start\_grace": time to wait for process to start. Defaults to `10.seconds`
  * "restart\_grace": time to wait for process to restart. Defaults to `10.seconds`
  * "behavior": behavior to use after action is taken. Defaults to `:clean_pid_file`
  * "notify": notification to use. Defaults to 'admin'

## Using god config files directly

If you'd rather have more control over the watch configuration, you can simply create
the .god files the way you normally would and god-inotify will restart/reload god for
you as needed.

```
vi redis.god # create your watch for redis
mv redis.god /etc/god/conf.d
```

That will automatically reload your watches and include `redis.god`.

# Development

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

