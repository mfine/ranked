require "digest/md5"

module Ranked
  class Player < Sequel::Model
    attr_accessor :rating

    def display_name
      name || user
    end

    def gravatar
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user)}.png?s=32"
    end
  end
end
