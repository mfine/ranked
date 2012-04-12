module Ranked
  class Event < Sequel::Model
    plugin :optimistic_locking
    plugin :timestamps

  end
end
