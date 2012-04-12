require "irb"
require "task"

module Console
  extend Task
  include Ranked

  def self.main
    IRB.start
  end
end
