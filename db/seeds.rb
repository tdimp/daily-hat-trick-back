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

puts "Seeding NHL Team Data..."
get_nhl_teams()