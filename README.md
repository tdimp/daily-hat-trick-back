# Daily Hat Trick Back End (front end repo [here](https://github.com/tdimp/phase5-frontend))

Daily Hat Trick is a full-stack hockey stats tracking app where users can create teams of NHL players and track basic and advanced statistics for each player. Users can browse all NHL players by last name, or view each NHL team's roster. Rosters and statistics are updated multiple times per day, so users can be assured that the statistics they are seeing are up-to-date. The app does not currently support live stats updates, so users will have to check the morning following NHL games to see those stats added to the players' totals.

Once the back end is up and running, a user can create an account and start creating teams! The UI is intuitive and simple to use. What are you waiting for? Start winning your fantasy hockey matchups today!

This serves as the back end API and database for Daily Hat Trick. Ruby v 2.7.4; Rails v 7.0.4;

In the project directory, run 

### `bundle install`

Downloads and installs the app's dependencies.

### `sudo service postgresql start`

### `rails db:create db:migrate db:seed`

Starts the PostgreSQL database necessary for Daily Hat Trick
Creates the database, runs the migrations, and seeds the database with NHL data from the [NHL Stats API](https://gitlab.com/dword4/nhlapi/-/blob/master/stats-api.md)

# IMPORTANT:

Seeding the database will take a few minutes. Please check the console for any errors while seeding. Sometimes the API encounters an issue and seeding will need to be restarted. If this happens after data has already been seeded, kill the server with CTRL+C and run `rails db:reset`.

If seeding is completed successfully, you will see the `Done seeding!` confirmation message in the console and can start the server.

### $rails s

Starts the server. Once the server is up and running, make sure the front end is up and running as well. From there, you can use Daily Hat Trick's full functionality!

## SCHEDULED JOBS

Daily Hat Trick has scheduled jobs that are set to run after certain intervals of time. These are necessary to ensure that player stats and NHL lineups stay current. You might encounter server logs related to these jobs. The code for the jobs can be found in `/config/initializers/scheduler.rb`