module Ranked
  class Player < Sequel::Model
    def display_name
      name || user
    end
  end
end
