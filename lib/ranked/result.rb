module Ranked
  class Result < Sequel::Model
    plugin :optimistic_locking
    plugin :timestamps

  end
end
