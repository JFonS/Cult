local Flux = require "lib/flux"
local Vector = require "lib/vector"
require "lib/swingers"

local Game = {} 
local jefe, musicSource, bpm, beat, halfBeat, localTime, beatIndex, beatSteps, minions
local handPositions = {}
handPositions.l =  Vector(150,love.graphics.getHeight()/2)
handPositions.r = Vector(450,love.graphics.getHeight()/2)
handPositions.u =    Vector(love.graphics.getWidth()/2,250)
handPositions.d =  Vector(love.graphics.getWidth()/2,550)

function Game:init()
    jefe = {}
    jefe.img = love.graphics.newImage("images/jefe.png")
    jefe.hand = {}
    jefe.hand.img = love.graphics.newImage("images/liderhand.png")

    minions = {}
    minions.img = love.graphics.newImage("images/minions.png")

    musicSource = love.audio.newSource( "music/level1.wav", "static")

    musicSource:setLooping(true)
    bpm = (16) * 60 / (8)
    beat = 60 / bpm 
    halfBeat = beat/2
    sequenceLen = 4
end

function Game:enter(previous)
	swingers.start()
	love.audio.rewind(musicSource)
	love.audio.play(musicSource)
	beatIndex = 0

	beatSteps = {
	{"l","r","u","d"},
	{"l","r","d","u"},
	{"none","none","none","none"}}
    

	jefe.originalPos = Vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2 + 150)
    jefe.pos = jefe.originalPos:clone()
    jefe.scale = Vector(0.7,0.7)

    jefe.hand.originalPos = Vector(love.graphics.getWidth()/2 - 100,love.graphics.getHeight()/2 + 350)
    jefe.hand.pos = jefe.hand.originalPos:clone()
    jefe.hand.scale = Vector(0.7,0.7)

    minions.originalPos = Vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2 + 150)
    minions.pos = minions.originalPos:clone()
    minions.scale = Vector(1,1)
    localTime = 0.0
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
	

	local newIndex = math.floor(localTime * bpm * (1/60) * (0.5)) + 1
	local indexChanged = newIndex ~= beatIndex
    beatIndex = newIndex

    if (beatIndex-1 % sequenceLen*2 < sequenceLen) and indexChanged then
    	Flux.to(jefe.hand.pos, beat/5, handPositions.l)
    else

    end

    if swingers.checkGesture() then
    	if beatSteps[beatIndex] ~= swingers.getGesture() then
    		Gamestate.switch(Menu)
    	end
    end
end

function Game:draw()
	love.graphics.draw(minions.img, minions.pos.x, minions.pos.y, 0, minions.scale.x,minions.scale.y, minions.img:getWidth()/2, minions.img:getHeight()/2)
    love.graphics.draw(jefe.img, jefe.pos.x, jefe.pos.y, 0, jefe.scale.x,jefe.scale.y, jefe.img:getWidth()/2, jefe.img:getHeight()/2)
    love.graphics.draw(jefe.hand.img, jefe.hand.pos.x, jefe.hand.pos.y, 0, jefe.hand.scale.x,jefe.hand.scale.y, jefe.hand.img:getWidth()/2, jefe.hand.img:getHeight()/2)
    
    if beatSteps[beatIndex] ~= nil then
    	love.graphics.print("beatIndex: " .. math.floor(beatIndex),10,10)
	end
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