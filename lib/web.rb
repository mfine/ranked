require "unicorn"
require "task"

require "ladder/api"

module Web
  extend Task
  include Ranked

  def self.server
    @server ||= Unicorn::HttpServer.new(Api, listeners: ["0.0.0.0:#{Conf.port}"], worker_processes: 1, timeout: 30)
  end

  def self.main
    Log.notice port: Conf.port
    server.start.join
  end
end
