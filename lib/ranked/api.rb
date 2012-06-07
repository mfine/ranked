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

    def on_user(info)
      session['first_name'] = info.first_name
      session['last_name'] = info.last_name
      session['name'] = info.name
    end

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
        @user.update(:name => session['name']) unless @user.name
      end
    end

    get "/" do
      authenticate
      @players = Ranking.ladder
      haml :index
    end

    get "/scumbag" do
      authenticate
      @players = Ranking.ladder
      haml :scumbag
    end

    get "/elo" do
      authenticate
      @players = Ranking.elo
      haml :elo
    end

    get "/players/:id" do |id|
      authenticate
      @player = Player.find(:id => id)
      @wins   = Result.filter(:winner_id => id).count
      @losses = Result.filter(:loser_id  => id).count
      @recent = Result.filter({:winner_id => id, :loser_id => id}.sql_or).reverse_order(:at).all
      haml :player
    end

    get "/results" do
      authenticate
      @results = Result.reverse_order(:at).all
      haml :results
    end

    post "/results" do
      if !params[:winner_id] || params[:winner_id] == "" || !Player[params[:winner_id]] || !params[:loser_id] || params[:loser_id] == "" || !Player[params[:loser_id]] || (params[:winner_id].to_i != @user.id && params[:loser_id].to_i != @user.id)
        redirect "/"
      else
        @result = Result.create(:winner_id => params[:winner_id], :loser_id => params[:loser_id], :at => Time.now)
        Campfire.say_result(@result)
        Log.notice event: "result", winner: @result.winner.display_name, loser: @result.loser.display_name
        Ranking.ladder.each_with_index { |player, i| Log.notice event: "ladder", player: player.display_name, rank: i+1 }
        Ranking.elo.each_with_index { |player, i| Log.notice event: "elo", player: player.display_name, rank: i+1, rating: player.rating }
        redirect "/?posted=1"
      end
    end

    error do
      puts env['sinatra.error']
      500
    end
  end
end
