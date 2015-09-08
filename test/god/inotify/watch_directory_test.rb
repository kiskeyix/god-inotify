require 'test_helper'
class GodTest
  def watch(file)
    file
  end
  def unwatch(file)
    file
  end
end
class God::Inotify::WatchDirectoryTest < Minitest::Spec
  it "must be able to instantiate object" do
    God::Inotify::WatchDirectory.new.is_a?(God::Inotify::WatchDirectory).must_equal true
  end
  it "must be able to handle adding files to directory" do
    tmp_root = "/tmp/test-rootfs#{$$}/"
    begin
      FileUtils.mkdir_p "#{tmp_root}/etc/god/processes"
      FileUtils.mkdir_p "#{tmp_root}/etc/god/conf.d"
      g = ::GodTest.new
      wd = God::Inotify::WatchDirectory.new root: tmp_root, god: g
      wd.root.must_equal tmp_root
      wd.watch_directories # setup watches
      events = []
      thr = Thread.new { events = wd.process }
      FileUtils.touch "#{tmp_root}/etc/god/processes/foo.yml"
      thr.join
      events.first.name.must_equal "foo.yml"
    ensure
      FileUtils.rm_rf tmp_root
    end
  end
end
