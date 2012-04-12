require "json"
require "haml"
require "sinatra"
require "sinatra/google-auth"

module Ranked
  class Api < Sinatra::Base
    register Sinatra::GoogleAuth
    disable :show_exceptions, :dump_errors, :logging
    set :root, Dir.getwd
    set :public_folder, "public"
    set :views, "views"
    set :haml, format: :html5

    helpers do
      def data
        @data ||= JSON.parse(request.body.read)
      end
    end

    before do
      @user = session['user']
    end

    get "/" do
      authenticate
      haml :index
    end

    get "/players" do
      authenticate
      haml :players
    end

    get "/results" do
      authenticate
      haml :results
    end

    error do
      puts env['sinatra.error']
      500
    end
  end
end
