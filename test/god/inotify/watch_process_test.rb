require 'test_helper'
require 'tempfile'

class God::Inotify::WatchProcessTest < Minitest::Spec
  before do
    @tmp_yml = Tempfile.new('foo.yml')
  end
  it "must be able to instantiate object" do
    God::Inotify::WatchProcess.new.is_a?(God::Inotify::WatchProcess).must_equal true
  end
  it "must raise exception when +name+ is missing known extension" do
    gw = God::Inotify::WatchProcess.new
    lambda { gw.watch @tmp_yml }.must_raise God::Inotify::UnknownFilename
  end
  it "must raise exception when +name+ is missing" do
    begin
      gw = God::Inotify::WatchProcess.new
      path = @tmp_yml.path + ".yml"
      @tmp_yml.close
      @tmp_yml.unlink
      File.open(path,"wb") do |fd|
        fd.puts "---"
      end
      lambda { gw.watch path }.must_raise God::Inotify::NameRequired
    ensure
      File.unlink path
    end
  end
  after do
    @tmp_yml.close
    @tmp_yml.unlink
  end
end
