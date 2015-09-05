require 'test_helper'

class God::InotifyTest < Minitest::Spec
  it "should test if we have a version defined" do
    refute_nil ::God::Inotify::VERSION
  end
end
