module Ranked
  class Result < Sequel::Model

    def winner_user
      Player[winner_id].user
    end

    def loser_user
      Player[loser_id].user
    end
  end
end
