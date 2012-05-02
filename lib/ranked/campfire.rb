module Ranked
  module Campfire

    def self.say(msg)
      `curl --silent -H 'Content-Type: application/json' -d '{\"message\": {\"body\": \"#{msg}\"}}' #{Conf.campfire_url} > /dev/null` if Conf.campfire_url
    end

  end
end
