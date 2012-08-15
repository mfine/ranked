require "elo"

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

      active_ids = Player.active_ids
      ladder.map { |i| Player[i] }.select { |r| active_ids.include? r.id }
    end

    def self.elo
      Elo.configure do |config|
        config.default_k_factor = 15
        config.use_FIDE_settings = false
      end
      players = {}
      Result.order(:at).each do |r|
        players[r.winner_id] = Elo::Player.new unless players[r.winner_id]
        players[r.loser_id] = Elo::Player.new unless players[r.loser_id]
        players[r.winner_id].wins_from players[r.loser_id]
      end

      active_ids = Player.active_ids
      players.sort_by { |id, player| player.rating }.reverse.map { |id, player| p = Player[id]; p.rating = player.rating; p }.select { |r| active_ids.include? r.id }
    end

  end
end
