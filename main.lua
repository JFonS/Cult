Flux = require "lib/flux"
Beholder = require "lib/beholder"
Camera = require "lib/camera"
Gamestate = require "lib/gamestate"


Game = require "game"
Menu = require "menu"
Intro = require "intro"
Kill = require "kill"
--Game2 = require "game2"

Score = 0

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(Intro)
    --Gamestate.switch(Game)

    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push('quit') 
  end
end

