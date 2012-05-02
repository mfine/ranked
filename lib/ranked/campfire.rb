module Ranked
  module Campfire

    def self.say(msg)
      `curl --silent -H 'Content-Type: application/json' -d '{\"message\": {\"body\": \"#{msg}\"}}' #{Conf.campfire_url} > /dev/null` if Conf.campfire_url
    rescue MissingConf
      Log.notice("not logging to campfire because CAMPFIRE_URL is not set")
    end

    def self.say_result(result)
      say(":vs: #{result.winner.display_name} just beat #{result.loser.display_name}")
    end

  end
end
