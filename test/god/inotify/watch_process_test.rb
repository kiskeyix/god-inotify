require 'test_helper'

class God::Inotify::WatchProcessTest < Minitest::Spec
  it "must be able to instantiate object" do
    God::Inotify::WatchProcess.new.is_a?(God::Inotify::WatchProcess).must_equal true
  end
end
