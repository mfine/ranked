require "ranked/error"

module Ranked
  module Conf

    def self.env
      [:database_url, :port, :campfire_url]
    end

    def self.method_missing(m, *args)
      super unless env.include?(m)
      ENV[m.upcase.to_s] || raise(MissingConf, m.to_s)
    end

  end
end
