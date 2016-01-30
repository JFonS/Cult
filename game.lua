local Flux = require "lib/flux"
local Vector = require "lib/vector"
require "lib/swingers"

local Game = {} 
local jefe, musicSource, bpm, beat, halfBeat, localTime, beatIndex, beatSteps, minions, background
local handPositions = {}
handPositions.l =  Vector(250,love.graphics.getHeight()-100)
handPositions.r = Vector(love.graphics.getWidth() - 250,love.graphics.getHeight()-100)
handPositions.u =    Vector(love.graphics.getWidth()/2,350)
handPositions.d =  Vector(love.graphics.getWidth()/2,650)
handPositions.idle = Vector(love.graphics.getWidth()/2 - 100,love.graphics.getHeight()/2 + 350)

function Game:init()
    jefe = {}
    jefe.img = love.graphics.newImage("images/jefe.png")
    jefe.hand = {}
    jefe.hand.img = love.graphics.newImage("images/liderhand.png")

    minions = {}
    minions.img = love.graphics.newImage("images/minions.png")
    
    background = {}
    background.img = love.graphics.newImage("images/background.png")

    musicSource = love.audio.newSource( "music/level1.wav", "static")

    musicSource:setLooping(true)
    bpm = (16) * 60 / (8)
    beat = 60 / bpm 
    gameBeat = beat*2
    halfBeat = beat/2
    sequenceLen = 4
end

function Game:enter(previous)
	swingers.start()
	love.audio.rewind(musicSource)
	love.audio.play(musicSource)
	beatIndex = -1

	beatSteps = {
	{"l","r","u","d"},
	{"l","r","u","d"},
	{"r","l","r","u"}}
    

	jefe.originalPos = Vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2 + 150)
    jefe.pos = jefe.originalPos:clone()
    jefe.scale = Vector(0.7,0.7)

    jefe.hand.originalPos = handPositions.idle
    jefe.hand.pos = jefe.hand.originalPos:clone()
    jefe.hand.scale = Vector(0.7,0.7)

    minions.originalPos = Vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2 + 150)
    minions.pos = minions.originalPos:clone()
    minions.scale = Vector(1,1)
    localTime = 0.0
    completedLastMove = true
end

function hand_move(start, finish)
  Flux.to(jefe.hand.pos, gameBeat/5, handPositions[start]):after(gameBeat/5*3,handPositions[finish]):after(gameBeat/5*2,handPositions.idle)
  end

function Game:update(dt) -- runs every frame
	swingers.update()
	Flux.update(dt)
	localTime = localTime + dt

	local moveDist = 15
	local beatDist = math.abs(localTime % beat) 
	if beatDist < beat/5*4 then
		jefe.pos.y = jefe.originalPos.y - (beatDist / ((beat/5)*4)) * moveDist
		minions.pos.y = minions.originalPos.y - (beatDist / ((beat/5)*4)) * moveDist *0.4
	else
		jefe.pos.y = jefe.originalPos.y - (beat - (beat/5*4)) /(beat/5) * moveDist
		minions.pos.y = minions.originalPos.y - (beatDist / ((beat/5)*4)) * moveDist *0.4
	end
	
  
	local newIndex = math.floor(localTime * bpm * (1/60) * (0.5))
  
	local indexChanged = newIndex ~= beatIndex
  beatIndex = newIndex
  
  if (indexChanged and not completedLastMove) then lose() end
  local part = beatSteps[math.floor((beatIndex/2)/sequenceLen) + 1]
  local move = part[beatIndex%4 + 1]
  if (beatIndex % (sequenceLen*2) < sequenceLen)  then
    if indexChanged then
      if move == "l" then
        hand_move("r","l")
      elseif move == "r" then
        hand_move("l","r")
      elseif move == "u" then
        hand_move("d","u")
      elseif move == "d" then
        hand_move("u","d")
      end
    end
  else
    if indexChanged then 
      print("set to false") 
      completedLastMove = false 
    end
    if swingers.checkGesture() then
    	if move ~= swingers.getGesture() then
    		lose()
    	else
        completedLastMove = true
      end
    end  
  end

    
end

function lose() 
  Gamestate.switch(Menu)
end


function Game:draw()
  love.graphics.draw(background.img,0,-2800 + love.graphics.getHeight())
	love.graphics.draw(minions.img, minions.pos.x, minions.pos.y, 0, minions.scale.x,minions.scale.y, minions.img:getWidth()/2, minions.img:getHeight()/2)
    love.graphics.draw(jefe.img, jefe.pos.x, jefe.pos.y, 0, jefe.scale.x,jefe.scale.y, jefe.img:getWidth()/2, jefe.img:getHeight()/2)
    love.graphics.draw(jefe.hand.img, jefe.hand.pos.x, jefe.hand.pos.y, 0, jefe.hand.scale.x,jefe.hand.scale.y, jefe.hand.img:getWidth()/2, jefe.hand.img:getHeight()/2)
    
    	love.graphics.print("beatIndex: " .. math.floor(beatIndex),10,10)

	--drawMouse()
end

function Game:keyreleased(key)
    if key == 'up' then
        print("released up")
    elseif key == 'down' then
        print("released down")
    end
end

function Game:mousereleased(x,y, mouse_btn)
    print("mousereleased")
end

return Game