local Flux = require "lib/flux"

local Kill = {} 
local localTime
local imgactual
local musicSource
local things = {}

function Kill:init()
  background = {}
  background.img = {}

  background.img[1] = love.graphics.newImage("images/Glitch/1.png")
  background.img[2] = love.graphics.newImage("images/Glitch/2.png")
  background.img[3] = love.graphics.newImage("images/Glitch/3.png")
  background.img[4] = love.graphics.newImage("images/Glitch/4.png")
  background.img[5] = love.graphics.newImage("images/Glitch/5.png")
  background.img[6] = love.graphics.newImage("images/Glitch/6.png")

  background.title = love.graphics.newImage("images/Glitch/title.png")


  titleImg = love.graphics.newImage("images/title.png")

  musicSource = love.audio.newSource( "music/rnoise2.mp3")

  musicSource:setLooping(true)

end

function Kill:enter(previous)

  localTime = 0.0
  imgactual = math.random(6)
  things.blackAlpha = 0
  love.audio.play(musicSource)
end

function Kill:update(dt) -- runs every frame
  localTime = localTime + dt
  Flux.update(dt)
  if localTime > 0.05 then
    localTime = 0.0
    imgactual = math.random(6)
  end

end


function Kill:draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(background.img[imgactual],0,0)
  love.graphics.draw(background.title,240,20)
  love.graphics.setNewFont("fonts/Zombie_Holocaust.ttf",80)
  love.graphics.print("Score ",50, 600, 0, 1, 1, 1)
  love.graphics.setNewFont("fonts/Gypsy_Curse.ttf", 80)
  love.graphics.print(": "..Score, 230, 600, 0, 1, 1, 1)
 love.graphics.setColor(0,0,0, things.blackAlpha)
  love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(),love.graphics.getHeight())
end

function Kill:keyreleased(key)
  game()
end

function Kill:mousereleased(key)
  game()
end

function game()
  Flux.to(things, 1.5, {blackAlpha = 255}):delay(0.2):oncomplete(function()
      musicSource:stop()
      Score = 0
      Gamestate.switch(Game)
    end)
end

return Kill
