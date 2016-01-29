local Flux = require "lib/flux"
local Vector = require "lib/vector"
local Game = {} 
local jefe, musicSource, bpm, beat, halfBeat, localTime, beatIndex

function Game:init()
    jefe = {}
    jefe.img = love.graphics.newImage("images/jefe.png")
    jefe.originalPos = Vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2 + 150)
    jefe.pos = jefe.originalPos:clone()
    jefe.scale = Vector(0.6,0.6)

    musicSource = love.audio.newSource( "music/level1.wav", "static")
    musicSource:setLooping(true)
    bpm = (16) * 60 / (8)
    beat = 60 / bpm 
    halfBeat = beat/2

    localTime = 0.0

end

function Game:enter(previous) 
	love.audio.play(musicSource)
	beatIndex = 0
end

function Game:update(dt) -- runs every frame
	localTime = localTime + dt
	local moveDist = 15
	local beatDist = math.abs(localTime % beat) 
	if beatDist < beat/5*4 then
		jefe.pos.y = jefe.originalPos.y - (beatDist / ((beat/5)*4)) * moveDist
	else
		jefe.pos.y = jefe.originalPos.y - (beat - (beat/5*4)) /(beat/5) * moveDist
	end
	
    beatIndex = localTime * bpm * (1/60) * (1)
end

function Game:draw()

    love.graphics.draw(jefe.img, jefe.pos.x, jefe.pos.y, 0, jefe.scale.x,jefe.scale.y, jefe.img:getWidth()/2, jefe.img:getHeight()/2)
    love.graphics.print("beatIndex: " .. math.floor(beatIndex),10,10)
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