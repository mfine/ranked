module Ranked
  class Result < Sequel::Model

    def winner_name
      Player[winner_id].name
    end

    def loser_name
      Player[loser_id].name
    end

    def oponent(player)
      [winner_name, loser_name].reject { |p| p == player.name }.first
    end

    def result(player)
      { winner_id => "win", loser_id  => "loss" }[player.id]
    end
  end
end
