require "sequel"

require "ladder/log"
require "ladder/conf"
require "ladder/autoload"

module Task
  include Ladder

  def db
    @db ||= Sequel.connect(Conf.database_url)
  end

  def run
    Log.notice event: "run"
    ok = db.test_connection
    Log.notice ok: ok
    if ok
      db.tables.each { |model| Sequel::Model(model) }
      main
    end
  end
end
