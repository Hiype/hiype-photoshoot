# FiveM/QBCore photoshoot script
Standalone/QBCore script for taking screenshots by using custom cameras and some cool animations.

**For now QBCore HUD is disabled server-wide when taking screenshots, once the HUD can be hidden without disabling the resource, will fix this problem**

## Features
* Very customizable, to the point where you can make photoshoot studios anywhere
* Put cameras anywhere
* Screenshots uploaded straight to Imgur
* Links saved in MySQL database

## Requirements (QBCore already includes these)
* Screenshot-basic
* Oxmysql
* As recent game build as possible - **sv_enforceGameBuild 2372** in server.cfg

## Setup
1. Clone the repository
2. Add this script to your server.cfg file -> ensure hiype-photoshoot

## Instructions
Find the camera blip on the map and enter the elevator.
![Map](https://i.imgur.com/gKrcjOq.png)

![Entrance](https://i.imgur.com/evfM7ud.png)

Once there, go up the elevator and press E to start a photoshoot.

![Photoshoot](https://i.imgur.com/VCN54oD.png)

From there you can change between cameras that you have set up in config.lua file and take a screenshot without any hud elements in the way.