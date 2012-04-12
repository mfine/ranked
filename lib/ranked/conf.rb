require "ladder/error"

module Ladder
  module Conf

    def self.env
      [:lock_id, :database_url, :schedule_limit, :schedule_sleep, :heroku_username, :heroku_password, :sso_salt, :port]
    end

    def self.method_missing(m, *args)
      super unless env.include?(m)
      ENV[m.upcase.to_s] || raise(MissingConf, m.to_s)
    end

  end
end
