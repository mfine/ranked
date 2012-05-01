module Ranked
  module Campfire

    def self.say(msg)
      `curl --silent -u #{Conf.campfire_token}:X -H 'Content-Type: application/json' -d '{\"message\": {\"body\": \"#{msg}\"}}' https://blossom.campfirenow.com/room/500532/speak.json > /dev/null` if Conf.campfire_token
    end

  end
end
