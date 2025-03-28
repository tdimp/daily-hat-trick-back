# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'rest-client'

# api_key uses dotenv gem to avoid pushing API keys to GitHub. It is not needed for this project since the NHL API
# does not require an API key.
# def api_key
#   ENV['API_KEY']
# end

# New NHL API docs here: https://gitlab.com/dword4/nhlapi/-/blob/master/new-api.md?ref_type=heads
# TODO: rewrite seeds.rb to use new API endpoints.

CURRENT_SEASON = "20242025"
BASE_URL = "https://api.nhle.com/stats/rest/en"
SPECIFIC_URL = "https://api-web.nhle.com/v1"
NHL_TEAMS = [
  "MTL",
  "BUF",
  "NYI",
  "SJS",
  "CBJ",
  "PIT",
  "FLA",
  "CAR",
  "VGK",
  "DAL",
  "WPG",
  "TBL",
  "UTA",
  "NSH",
  "NJD",
  "OTT",
  "COL",
  "SEA",
  "WSH",
  "ANA",
  "LAK",
  "VAN",
  "MIN",
  "TOR",
  "NYR",
  "EDM",
  "CGY",
  "BOS",
  "STL",
  "CHI",
  "DET",
  "PHI"
]

def get_nhl_teams(base_url, nhl_teams)
  response = RestClient.get(base_url)
  parsed_response = JSON.parse(response)
  teams_array = parsed_response["data"]

  teams_array.each do |t|
    if nhl_teams.include?(t["rawTricode"])
      NhlTeam.create(
        id: t["id"],
        name: t["fullName"],
        tricode: t["rawTricode"]
      )
    end
  end
end

def get_nhl_rosters(base_url, current_season)
  NhlTeam.all.each do |t|
    response = RestClient.get("#{base_url}/roster/#{t['tricode']}/#{current_season}")
    parsed_response = JSON.parse(response)
    players = parsed_response["forwards"] + parsed_response["defensemen"] + parsed_response["goalies"]
    puts "Seeding roster data for #{t["name"]}..."
   
    players.each do |p|
      Player.create(
        id: p["id"],
        first_name: p["firstName"]["default"],
        last_name: p["lastName"]["default"],
        full_name: "#{p['firstName']} #{p['lastName']}",
        position: p["positionCode"],
        jersey_number: p["sweaterNumber"],
        nhl_team_id: t["id"]
      )
    end
  end
end

def get_player_stats
  p Time.now
  current_season = CURRENT_SEASON
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
get_nhl_teams("https://api.nhle.com/stats/rest/en/team", NHL_TEAMS)

puts "Seeding NHL Roster Data..."
get_nhl_rosters(SPECIFIC_URL, CURRENT_SEASON)

# puts "Seeding Player Stats..."
# get_player_stats()

# user_1 = User.create(username: "testuser", password_digest: BCrypt::Password.create("password"), email: "testuser")

# team_1 = user_1.teams.create(name: "Test Team")

# players = Player.where('full_name': ['Auston Matthews', 'Ivan Barbashev', 'Ryan Nugent-Hopkins', 'Jamie Benn', 'Mitchell Marner', 'Adrian Kempe', 'Erik Karlsson', 'Hampus Lindholm', 'Kris Letang', 'Adam Larsson', 'Elias Lindholm', 'Zach Hyman', 'Viktor Arvidsson', 'Phillipp Grubauer', 'Vitek Vanecek', 'Stuart Skinner'])

# team_1.players << players

puts "Done seeding!"