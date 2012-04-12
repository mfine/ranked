module Ladder
  class User < Sequel::Model
    plugin :optimistic_locking
    plugin :timestamps

  end
end
