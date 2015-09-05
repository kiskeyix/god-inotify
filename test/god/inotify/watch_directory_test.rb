require 'test_helper'

class God::Inotify::WatchDirectoryTest < Minitest::Spec
  it "must be able to instantiate object" do
    God::Inotify::WatchDirectory.new.is_a?(God::Inotify::WatchDirectory).must_equal true
  end
end
