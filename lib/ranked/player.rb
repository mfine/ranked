require "digest/md5"

module Ranked
  class Player < Sequel::Model
    attr_accessor :rating

    def display_name
      name || user
    end

    def gravatar
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user)}.png?s=20&d=mm"
    end

    def self.active_ids
      recent = Ranked::Result.filter{at > Time.at(Time.now.to_i - 4*7*24*60*60)}.
        select_map([:winner_id, :loser_id]).
        flatten.
        uniq
    end

    def self.active
      filter(id: active_ids)
    end

    def self.inactive
      exclude(id: active_ids)
    end
  end
end
