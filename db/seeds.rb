# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'rest-client'

def api_key
  ENV['API_KEY']
end

def get_nhl_teams
  current_season = "20222023"
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
      response = RestClient.get("#{api_key}/people/#{p["person"]["id"]}/stats?stats=statsSingleSeason&season=#{current_season}")
      parsed_response = JSON.parse(response)
      #p parsed_response["stats"][0]["splits"][0] != nil ? parsed_response["stats"][0]["splits"][0]["stat"] : "No stats found for #{p["person"]["fullName"]}"
      Player.create(
        id: p["person"]["id"],
        name: p["person"]["fullName"],
        position: p["position"]["abbreviation"],
        jersey_number: p["jerseyNumber"],
        nhl_team_id: t["id"]
      )
      if parsed_response["stats"][0]["splits"][0] == nil 
        p "Player does not have stats for the current season"
      elsif p["position"]["abbreviation"] == "G" 
        GoalieStat.create(
          player_id: p["person"]["id"],
          time_on_ice: parsed_response["stats"][0]["splits"][0]["stat"]["timeOnIce"],
          # TODO: Rest of stats data
        )
      else
        SkaterStat.create(
          player_id: p["person"]["id"],
          time_on_ice: parsed_response["stats"][0]["splits"][0]["stat"]["timeOnIce"],
          # TODO: Rest of stats data
        )
      end
    end
  end

  
end

puts "Seeding NHL Team Data..."
get_nhl_teams()