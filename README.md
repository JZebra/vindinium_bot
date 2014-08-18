## Vindinium Bot -- Gizmo

This is a simple AI bot based off the code from http://vindinium.org/starters.

Much of the maze_solver code was adapted from the App academy curriculum, which is an implementation of the A* pathfinding algorithm.

###Bots

Currently, the only bot is a simple MinerBot that 

- ignores all heroes
- navigates to the nearest mine
- if hp < 60, navigates to the nearest tavern instead


###Functionality

The bot is not yet functional. There is a bug in the way that I'm returning a direction to vindinium.rb. I'm still testing the issue. 

### Usage ###

` bundle install`
` bundle exec ruby client.rb <key> <[training|arena]> <number-of-games|number-of-turns> [server-url]`
