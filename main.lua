Flux = require "lib/flux"
Beholder = require "lib/beholder"
Camera = require "lib/camera"
Gamestate = require "lib/gamestate"

Menu = require "menu"
Game = require "game"




local fish = {}

function love.load()
    cam = Camera(fish.x, fish.y)
    cam.smoother = Camera.smooth.damped(1)
    Gamestate.registerEvents()
    Gamestate.switch(Game)
end

function love.update(dt)
	Flux.update(dt)
end


function worldDraw()
	--love.graphics.draw(fish.image,fish.x,fish.y)
end

-- function love.draw()
-- 	love.graphics.setColor(128,128,128)
-- 	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
-- 	cam:draw(worldDraw)
-- end

