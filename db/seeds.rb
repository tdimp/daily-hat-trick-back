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
  response = RestClient.get("#{base_url}/team")
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
        full_name: "#{p['firstName']["default"]} #{p['lastName']["default"]}",
        position: p["positionCode"],
        jersey_number: p["sweaterNumber"],
        nhl_team_id: t["id"]
      )
    end
  end
end

def get_player_stats(base_url, current_season)
  p Time.now
  # summary endpoint
  response = RestClient.get("#{base_url}/skater/summary?limit=-1&cayenneExp=seasonId=#{current_season}%20and%20gameTypeId=2")
  parsed_response = JSON.parse(response)
  skaters = parsed_response["data"]

  skaters.each do |skater|
    SkaterStat.create(
      player_id: skater["playerId"],
      goals: skater["goals"],
      assists: skater["assists"],
      points: skater["points"],
      plus_minus: skater["plusMinus"],
      time_on_ice_per_game: skater["timeOnIcePerGame"],
      shots: skater["shots"],
      game_winning_goals: skater["gameWinningGoals"],
      shot_pct: skater["shotPct"],
      faceoff_pct: skater["faceOffWinPct"],
      games: skater["gamesPlayed"],
      pim: skater["penaltyMinutes"],
      power_play_goals: skater["ppGoals"],
      power_play_points: skater["ppPoints"]
      short_handed_points: skater["shPoints"],
    )
  end

  # scoringpergame endpoint
  response = RestClient.get("#{base_url}/skater/scoringpergame?limit=-1&cayenneExp=seasonId=#{current_season}%20and%20gameTypeId=2")
  parsed_response = JSON.parse(response)
  skaters = parsed_response["data"]

  skaters.each do |skater|
    SkaterStat.find_or_create_by(player_id: skater["playerId"]).update(
      hits: skater["hits"],
      blocked: skater["blockedShots"]
    )
  end

  # timeonice endpoint
   response = RestClient.get("#{base_url}/skater/timeonice?limit=-1&cayenneExp=seasonId=#{current_season}%20and%20gameTypeId=2")
   parsed_response = JSON.parse(response)
   skaters = parsed_response["data"]
 
   skaters.each do |skater|
     SkaterStat.find_or_create_by(player_id: skater["playerId"]).update(
       time_on_ice: skater["timeOnIce"],
       power_play_time_on_ice: skater["ppTimeOnIce"],
       even_time_on_ice_per_game: skater["evTimeOnIcePerGame"],
       short_handed_time_on_ice_per_game: skater["shTimeOnIcePerGame"],
       power_play_time_on_ice_per_game: skater["ppTimeOnIcePerGame"]
     )
   end
  
   response = RestClient.get("#{base_url}/goalie/summary?limit=-1&cayenneExp=seasonId=#{current_season}%20and%20gameTypeId=2")
   parsed_response = JSON.parse(response)
   goalies = parsed_response["data"]
 
   goalies.each do |goalie|
     GoalieStat.create(
       player_id: goalie["playerId"],
       ot: goalie["otLosses"],
       shutouts: goalie["shutouts"],
       wins: goalie["wins"],
       losses: goalie["losses"],
       saves: goalie["saves"],
       save_percentage: goalie["savePct"],
       time_on_ice: goalie["timeOnIce"],
       goals_against_average: goalie["goalsAgainstAverage"],
       games: goalie["gamesPlayed"],
       games_started: goalie["gamesStarted"],
       shots_against: goalie["shotsAgainst"],
       goals_against: goalie["goalsAgainst"]
     )
   end

   response = RestClient.get("#{base_url}/goalie/savesByStrength?limit=-1&cayenneExp=seasonId=#{current_season}%20and%20gameTypeId=2")
   parsed_response = JSON.parse(response)
   goalies = parsed_response["data"]
 
   goalies.each do |goalie|
     GoalieStat.find_or_create_by(player_id: goalie["playerId"]).update(
      power_play_save_percentage: goalie["powerPlaySavePercentage"],
      short_handed_save_percentage: goalie["shortHandedSavePercentage"],
      even_strength_save_percentage: goalie["evenStrengthSavePercentage"]
     )
   end
  p Time.now
end

puts "Seeding NHL Team Data..."
get_nhl_teams(BASE_URL, NHL_TEAMS)

puts "Seeding NHL Roster Data..."
get_nhl_rosters(SPECIFIC_URL, CURRENT_SEASON)

puts "Seeding Player Stats..."
get_player_stats(BASE_URL, CURRENT_SEASON)

user_1 = User.create(username: "testuser", password_digest: BCrypt::Password.create("password"), email: "testuser")

team_1 = user_1.teams.create(name: "Test Team")

players = Player.where('full_name': ['Auston Matthews', 'Ivan Barbashev', 'Ryan Nugent-Hopkins', 'Jamie Benn', 'Mitchell Marner', 'Adrian Kempe', 'Erik Karlsson', 'Hampus Lindholm', 'Kris Letang', 'Adam Larsson', 'Elias Lindholm', 'Zach Hyman', 'Viktor Arvidsson', 'Phillipp Grubauer', 'Vitek Vanecek', 'Stuart Skinner'])

team_1.players << players

puts "Done seeding!"