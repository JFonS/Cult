--local Flux = require "lib/flux"
--local Vector = require "lib/vector"
--require "lib/swingers"

local Kill = {} 
--local musicSource, localTime, background, offset, titleImg
--local introTime = 8
--local titleTime = 5
--local things = {}
--local ready = false

function Intro:init()
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

  musicSource = love.audio.newSource( "music/level1.wav", "static")

  musicSource:setLooping(true)
end

function Intro:enter(previous)
  love.audio.rewind(musicSource)
  love.audio.play(musicSource)

  localTime = 0.0
  things.offset = 0
  things.titleAlpha = 0
  things.blackAlpha = 0

  maxOffset = 2800-love.graphics.getHeight()
  Flux.to(things,introTime,{offset=maxOffset}):ease("quadin")
  :after(titleTime,{titleAlpha = 255}):delay(0.5):oncomplete(function() ready = true end)
end

function Intro:update(dt) -- runs every frame
  Flux.update(dt)
  localTime = localTime + dt


end

local titleScale = 1.2
function Intro:draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(background.img,0,-things.offset)
  love.graphics.setColor(255,255,255,things.titleAlpha)
  love.graphics.draw(titleImg, (love.graphics.getWidth()-titleImg:getWidth()*titleScale)/2, (love.graphics.getHeight()-titleImg:getHeight()*titleScale)/2,0,titleScale,titleScale)
  love.graphics.setColor(0,0,0, things.blackAlpha)
  love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(),love.graphics.getHeight())
end

function Intro:keyreleased(key)
  if ready then
    Flux.to(things, 1.5, {blackAlpha = 255}):delay(0.2):oncomplete(function()
        musicSource:stop()
        Gamestate.switch(Game)
      end)
  end
end

return Intro