require "json"
require "haml"
require "sinatra"
require "sinatra/google-auth"

require "ranked/ranking"

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

      def link_class(path)
        return "active" if request.path_info == path
      end
    end

    before do
      if user = session['user']
        @user = Player.find_or_create(:user => user)
      end
    end

    get "/" do
      authenticate
      @players = Ranking.ladder
      haml :index
    end

    get "/players/:id" do |id|
      authenticate
      @player = Player.find(:id => id)
      @wins   = Result.filter(:winner_id => id).count
      @losses = Result.filter(:loser_id  => id).count
      @recent = Result.filter({:winner_id => id, :loser_id => id}.sql_or).limit(10)
      haml :player
    end

    get "/results" do
      authenticate
      @results = Result.all
      haml :results
    end

    post "/results" do
      Result.create(:winner_id => params[:winner_id], :loser_id => @user.id, :at => Time.now)
      redirect "/?posted=1"
    end

    error do
      puts env['sinatra.error']
      500
    end
  end
end
