Flux = require "lib/flux"
Beholder = require "lib/beholder"
Camera = require "lib/camera"
Gamestate = require "lib/gamestate"


Game = require "game"
Menu = require "menu"
Intro = require "intro"

local fish = {}

function love.load()

    -- fireTexture = love.graphics.newImage("images/fire-particle.png")

    -- emitter = love.graphics.newParticleSystem(fireTexture,256)
    -- emitter:setDirection(-1.5)
    -- emitter:setAreaSpread("none",0,0)
    -- emitter:setEmissionRate(100)
    -- emitter:setEmitterLifetime(-1)
    -- emitter:setLinearAcceleration(0,-11,0,-24)
    -- emitter:setParticleLifetime(2,2)
    -- emitter:setRadialAcceleration(0,0)
    -- emitter:setRotation(0,0)
    -- emitter:setTangentialAcceleration(0,0)
    -- emitter:setSpeed(0,0)
    -- emitter:setSpin(0,0)
    -- emitter:setSpinVariation(1)
    -- emitter:setLinearDamping(0,0)
    -- emitter:setSpread(2.0999999046326)
    -- emitter:setRelativeRotation(false)
    -- emitter:setOffset(8,8)
    -- emitter:setSizes(1,0)
    -- emitter:setSizeVariation(0.20000000298023)
    -- emitter:setColors(255,134,62,255 )
    -- emitter:start()

    -- mouseParticles = love.graphics.newParticleSystem(fireTexture,256)
    -- mouseParticles:setEmissionRate(255)
    -- mouseParticles:setEmitterLifetime(-1)
    -- mouseParticles:setParticleLifetime(0.5)
    -- mouseParticles:setSizes(1.0,0.05)
    -- mouseParticles:start()
    -- mouseParticles:setDirection(1)
    -- mouseParticles:setSpeed(5,7)
    -- mouseParticles:setSpread(0.1)
    Gamestate.registerEvents()
    Gamestate.switch(Intro)

    love.mouse.setVisible(true)
    --love.mouse.setGrabbed(true)
end

function drawMouse() 
    love.graphics.draw(emitter,love.mouse.getX(), love.mouse.getY(),10,10)
end


function love.draw()

end

