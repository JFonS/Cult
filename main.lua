Flux = require "lib/flux"
Beholder = require "lib/beholder"
Camera = require "lib/camera"
Gamestate = require "lib/gamestate"


Game = require "game"
Menu = require "menu"
Intro = require "intro"
Kill = require "kill"

local fish = {}

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(Intro)
   -- Gamestate.switch(Game)

    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
end

function drawMouse() 
    love.graphics.draw(emitter,love.mouse.getX(), love.mouse.getY(),10,10)
end


function love.draw()

end

