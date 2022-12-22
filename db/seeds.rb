# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'rest-client'

def api_key
  ENV['API_KEY']
end

def get_nhl_teams
  response = RestClient.get("#{api_key}/teams")
  parsed_response = JSON.parse(response)
  teams_array = parsed_response["teams"]

  teams_array.each do |t|
    NhlTeam.create(
      id: t["id"],
      name: t["name"],
      location_name: t["locationName"],
      team_name: t["teamName"]
    )
    response = RestClient.get("#{api_key}/teams/#{t["id"]}?expand=team.roster")
    parsed_response = JSON.parse(response)
    players = parsed_response["teams"][0]["roster"]["roster"]
    puts "Seeding roster data for #{t["name"]}..."
   
    players.each do |p|
      Player.create(
        id: p["person"]["id"],
        name: p["person"]["fullName"],
        position: p["position"]["abbreviation"],
        jersey_number: p["jerseyNumber"],
        nhl_team_id: t["id"]
      )
    end
  end
end

def get_player_stats
  current_season = "20222023"
  players = Player.all
  players.each do |p|
    response = RestClient.get("#{api_key}/people/#{p.id}/stats?stats=statsSingleSeason&season=#{current_season}")
    parsed_response = JSON.parse(response)
    #p parsed_response["stats"][0]["splits"][0] != nil ? parsed_response["stats"][0]["splits"][0]["stat"] : "No stats found for #{p["person"]["fullName"]}"
    if parsed_response["stats"][0]["splits"][0] == nil 
      p "#{p.name} does not have stats for the current season"
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
end

puts "Seeding NHL Team and Roster Data..."
get_nhl_teams()

puts "Seeding Player Stats..."
get_player_stats()