module Ranked
  class Result < Sequel::Model

    def winner_user
      Player[winner_id].user
    end

    def loser_user
      Player[loser_id].user
    end

    def oponent(player)
      [winner_user, loser_user].reject { |p| p == player.user }.first
    end

    def result(player)
      { winner_id => "win", loser_id  => "loss" }[player.id]
    end
  end
end
