# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'rest-client'

# api_key uses dotenv gem to avoid pushing API keys to GitHub. It is not needed for this project since the NHL API
# does not require an API key.
# def api_key
#   ENV['API_KEY']
# end

def get_nhl_teams
  response = RestClient.get("https://statsapi.web.nhl.com/api/v1/teams")
  parsed_response = JSON.parse(response)
  teams_array = parsed_response["teams"]

  teams_array.each do |t|
    NhlTeam.create(
      id: t["id"],
      name: t["name"],
      location_name: t["locationName"],
      team_name: t["teamName"]
    )
  end
end

def get_nhl_rosters
  nhl_teams = NhlTeam.all
  nhl_teams.each do |t|
    response = RestClient.get("https://statsapi.web.nhl.com/api/v1/teams/#{t.id}?expand=team.roster")
    parsed_response = JSON.parse(response)
    players = parsed_response["teams"][0]["roster"]["roster"]
    puts "Seeding roster data for #{t["name"]}..."
   
    players.each do |p|
      Player.create(
        id: p["person"]["id"],
        first_name: p["person"]["fullName"].split.first,
        last_name: p["person"]["fullName"].split.last,
        full_name: p["person"]["fullName"],
        position: p["position"]["abbreviation"],
        jersey_number: p["jerseyNumber"],
        nhl_team_id: t["id"]
      )
    end
  end
end

def get_player_stats
  p Time.now
  current_season = "20232024"
  players = Player.all
  players.each do |p|
    response = RestClient.get("https://statsapi.web.nhl.com/api/v1/people/#{p.id}/stats?stats=statsSingleSeason&season=#{current_season}")
    parsed_response = JSON.parse(response)
    #p parsed_response["stats"][0]["splits"][0] != nil ? parsed_response["stats"][0]["splits"][0]["stat"] : "No stats found for #{p["person"]["fullName"]}"
    if parsed_response["stats"][0]["splits"][0] == nil 
      p "#{p.full_name} does not have stats for the current season"
    elsif p.position == "G"
      player_stat = parsed_response["stats"][0]["splits"][0]["stat"] 
      GoalieStat.create(
        player_id: p.id,
        time_on_ice: player_stat["timeOnIce"],
        ot: player_stat["ot"],
        shutouts: player_stat["shutouts"],
        wins: player_stat["wins"],
        losses: player_stat["losses"],
        saves: player_stat["saves"],
        save_percentage: player_stat["savePercentage"],
        goals_against_average: player_stat["goalAgainstAverage"],
        short_handed_save_percentage: player_stat["powerPlaySavePercentage"],
        power_play_save_percentage: player_stat["shortHandedSavePercentage"],
        even_strength_save_percentage: player_stat["evenStrengthSavePercentage"],
        games: player_stat["games"],
        games_started: player_stat["gamesStarted"],
        shots_against: player_stat["shotsAgainst"],
        goals_against: player_stat["goalsAgainst"],
        time_on_ice_per_game: player_stat["timeOnIcePerGame"],
      )
    else
      player_stat = parsed_response["stats"][0]["splits"][0]["stat"] 
      SkaterStat.create(
        player_id: p.id,
        time_on_ice: player_stat["timeOnIce"],
        assists: player_stat["assists"],
        goals: player_stat["goals"],
        pim: player_stat["pim"],
        shots: player_stat["shots"],
        games: player_stat["games"],
        hits: player_stat["hits"],
        power_play_goals: player_stat["powerPlayGoals"],
        power_play_points: player_stat["powerPlayPoints"],
        power_play_time_on_ice: player_stat["powerPlayTimeOnIce"],
        faceoff_pct: player_stat["faceOffPct"],
        shot_pct: player_stat["shotPct"],
        game_winning_goals: player_stat["gameWinningGoals"],
        short_handed_goals: player_stat["shortHandedGoals"],
        short_handed_points: player_stat["shortHandedPoints"],
        blocked: player_stat["blocked"],
        plus_minus: player_stat["plusMinus"],
        points: player_stat["points"],
        time_on_ice_per_game: player_stat["timeOnIcePerGame"],
        even_time_on_ice_per_game: player_stat["evenTimeOnIcePerGame"],
        short_handed_time_on_ice_per_game: player_stat["shortHandedTimeOnIcePerGame"],
        power_play_time_on_ice_per_game: player_stat["powerPlayTimeOnIcePerGame"],
      )
    end

  end
  p Time.now
end

puts "Seeding NHL Team Data..."
get_nhl_teams()

puts "Seeding NHL Roster Data..."
get_nhl_rosters()

puts "Seeding Player Stats..."
get_player_stats()

user_1 = User.create(username: "testuser", password_digest: BCrypt::Password.create("password"), email: "testuser")

team_1 = user_1.teams.create(name: "Test Team")

players = Player.find(8471214, 8480012, 8477447, 8471685, 8475314, 8479314, 8477503, 8478469, 8478407, 8477986, 8477932, 8478873, 8474053, 8477330, 8471218, 8479973, 8475311, 8480280, 8478872)

team_1.players << players

puts "Done seeding!"