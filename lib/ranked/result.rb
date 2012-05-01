module Ranked
  class Result < Sequel::Model

    def loser
      @loser ||= Player[loser_id]
    end

    def winner
      @winner ||= Player[winner_id]
    end

    def winner_name
      winner.name
    end

    def loser_name
      loser.name
    end

    def opponent(player)
      [winner, loser].find { |p| p != player }.display_name
    end

    def result(player)
      { winner_id => "win", loser_id  => "loss" }[player.id]
    end
  end
end
