require 'rest-client'

s = Rufus::Scheduler.singleton

s.every '12h' do
  nhl_teams = NhlTeam.all
  nhl_teams.each do |t|
    response = RestClient.get("https://statsapi.web.nhl.com/api/v1/teams/#{t.id}?expand=team.roster")
    parsed_response = JSON.parse(response)
    players = parsed_response["teams"][0]["roster"]["roster"]
    puts "Seeding roster data for #{t["name"]}..."
   
    players.each do |p|
      Player.find_or_create_by(id: p["person"]["id"]).update(
        id: p["person"]["id"],
        first_name: p["person"]["fullName"].split.first,
        last_name: p["person"]["fullName"].split.last,
        full_name: p["person"]["fullName"],
        position: p["position"]["abbreviation"],
        jersey_number: p["jerseyNumber"],
        nhl_team_id: t["id"],
      )
    end
  end
end

s.every '6h' do
  response = RestClient.get('https://statsapi.web.nhl.com/api/v1/schedule')
  parsed_response = JSON.parse(response)
  games_today = parsed_response['totalItems']
  current_season = '20222023'

  if games_today.to_int > 0
    @teams = []
    games = parsed_response['dates'][0]['games']
    games.each do |g|
      @teams << g['teams']['away']['team']['id']
      @teams << g['teams']['home']['team']['id']
    end

    new_teams = NhlTeam.find(@teams)
    new_teams.each do |t|
      players = t.players
      players.each do |p|
        response = RestClient.get("https://statsapi.web.nhl.com/api/v1/people/#{p.id}/stats?stats=statsSingleSeason&season=#{current_season}")
        parsed_response = JSON.parse(response)
        #p parsed_response["stats"][0]["splits"][0] != nil ? parsed_response["stats"][0]["splits"][0]["stat"] : "No stats found for #{p["person"]["fullName"]}"
        if parsed_response["stats"][0]["splits"][0] == nil 
          p "#{p.full_name} does not have stats for the current season"
        elsif p.position == "G"
          player_stat = parsed_response["stats"][0]["splits"][0]["stat"] 
          GoalieStat.find_or_create_by(player_id: p.id).update(
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
          SkaterStat.find_or_create_by(player_id: p.id).update(
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
  end
end