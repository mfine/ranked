require "json"
require "haml"
require "sinatra"
require "sinatra/google-auth"

require "ranked/ranking"
require "ranked/campfire"

module Ranked
  class Api < Sinatra::Base
    register Sinatra::GoogleAuth
    disable :logging
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
        unless @user.name
          @user.update(:name => session['name'])
        end
      end
    end

    def on_user(info)
      session["first_name"] = info.first_name
      session["last_name"] = info.last_name
      session["name"] = info.name
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
      if params[:winner_id].nil? || params[:winner_id] == ""
        redirect '/'
      elsif !Player[params[:winner_id]]
        return 422
      end
      result = Result.create(:winner_id => params[:winner_id], :loser_id => @user.id, :at => Time.now)
      Campfire.say ":vs: #{result.winner.display_name} just beat #{result.loser.display_name}"
      redirect "/?posted=1"
    end

    error do
      puts env['sinatra.error']
      500
    end
  end
end
