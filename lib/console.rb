require "sequel"
require "queue_classic"
require "irb"
require "task"

module Console
  extend Task
  include Ladder

  def self.main
    IRB.start
  end
end
