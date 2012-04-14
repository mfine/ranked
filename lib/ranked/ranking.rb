module Ranked
  module Ranking

    def self.ladder
      ladder = []
      Result.order(:at).each do |r|
        ladder.push(r.winner_id) unless ladder.include?(r.winner_id)
        ladder.push(r.loser_id) unless ladder.include?(r.loser_id)

        winner_index = ladder.index(r.winner_id)
        loser_index = ladder.index(r.loser_id)

        if winner_index > loser_index
          ladder.delete_at(winner_index)
          ladder = ladder.insert(loser_index, r.winner_id)
        end
      end

      ladder.map { |i| Player[i] }
    end
    
    def self.elo
      players = Hash.new(1200)
      games = Hash.new(0)
      Result.order(:at).each do |r|
        games[r.winner_id] += 1
        games[r.loser_id] += 1
        winner_rating = players[r.winner_id]
        loser_rating = players[r.loser_id]
        w_expected = 1.0 / (1.0 + 10 ** ((winner_rating - loser_rating) / 400))
        players[r.winner_id] = winner_rating +
          (games[r.winner_id] < 30 ? 30 : 15) * (1.0 - w_expected)
        players[r.loser_id] = loser_rating +
          (games[r.loser_id] < 30 ? 30 : 15) * (w_expected - 1.0)
      end
      
      players.sort { |a,b| b[1] <=> a[1] }.map { |id, rating| Player[id] }
    end

  end
end
