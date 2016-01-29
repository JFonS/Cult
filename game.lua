local Flux = require "lib/flux"
local Vector = require "lib/vector"
local Game = {} 
local jefe, musicSource, bpm, beat, halfBeat, localTime, beatIndex

function Game:init()
    jefe = {}
    jefe.img = love.graphics.newImage("images/jefe.png")
    jefe.pos = Vector(-100,-100)
    jefe.scale = Vector(0.4,0.4)

    musicSource = love.audio.newSource( "music/level1.wav", "static")
    musicSource:setLooping(true)
    bpm = (16) * 60 / (8)
    beat = bpm / 60
    halfBeat = beat/2

    print("BPM" .. bpm)
    localTime = 0.0

end

function jefeUp()
	Flux.to(jefe.pos, (beat/10),{y = jefe.pos.y + 20}):ease("quadin"):oncomplete(jefeDown)
end

function jefeDown()
	Flux.to(jefe.pos, (beat/2.5),{y = jefe.pos.y - 20}):ease("quadout"):oncomplete(jefeUp)
end


function Game:enter(previous) -- runs every time the state is entered
	love.audio.play(musicSource)
	jefeDown()
	beatIndex = 0
end

function Game:update(dt) -- runs every frame
	localTime = localTime + dt
	print( beat, halfBeat)
	local beatDist = math.abs(localTime % halfBeat) / halfBeat
	jefe.pos.y = -100 + beatDist * 50
    beatIndex = localTime * bpm * (1/60) * (1)
end

function Game:draw()
    love.graphics.draw(jefe.img, jefe.pos.x, jefe.pos.y)
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