#!/usr/bin/env ruby

$:.unshift(File.expand_path(File.join(File.dirname(File.dirname($0)), "lib")))

require "sequel"

require "ranked/log"
require "ranked/conf"
require "ranked/autoload"

include Ranked

if db = Sequel.connect(Conf.database_url)
  ok = db.test_connection
  Log.notice ok: ok
  if ok
    db.tables.each { |model| Sequel::Model(model) }
    p1 = Player.create user: "fine@heroku.com"
    p2 = Player.create user: "pedro@heroku.com"
    p3 = Player.create user: "blake@heroku.com"
    Result.create at: Time.now, winner_id: p1.id, loser_id: p2.id
    Result.create at: Time.now + 1000, winner_id: p1.id, loser_id: p3.id
    Result.create at: Time.now + 2000, winner_id: p2.id, loser_id: p3.id
  end
end    

    
