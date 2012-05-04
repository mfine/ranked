module Ranked
  class Player < Sequel::Model
    attr_accessor :rating

    def display_name
      name || user
    end
  end
end
