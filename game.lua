local Flux = require "lib/flux"
local Vector = require "lib/vector"
require "lib/swingers"
require "lib/class"
require "lib/trailmesh"
require "lib/postshader"
require "lib/light"
require "lib/edit-distance"

local Game = {} 
local jefe, musicSource, bpm, beat, halfBeat, localTime, beatIndex, beatSteps, minions, background, fireImg, blueFireImg, mahand
local fps = 0
local handPositions = {}

handPositions.l =  Vector(250,love.graphics.getHeight()-100)
handPositions.r = Vector(love.graphics.getWidth() - 250,love.graphics.getHeight()-100)
handPositions.u =    Vector(love.graphics.getWidth()/2,300)
handPositions.d =  Vector(love.graphics.getWidth()/2,750)
handPositions.idle = Vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2 + 350)

function Game:init()
  jefe = {}
  jefe.img = love.graphics.newImage("images/jefe.png")
  jefe.scale = Vector(0.7,0.7)
  jefe.originalPos = Vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2 + 150)

  jefe.hand = {}
  jefe.hand.img = love.graphics.newImage("images/liderhand.png")
  jefe.hand.scale = Vector(0.7,0.7)
  jefe.hand.originalPos = handPositions.idle

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

  fireImg = love.graphics.newImage("images/fire.png")


  lightWorld = love.light.newWorld()
  lightWorld.setAmbientColor(128, 128, 128)

  mahand = {}
  mahand.img = love.graphics.newImage("images/mahand.png")
  mahand.scale = 0.7
  blueFireImg = love.graphics.newImage("images/blue-fire.png")
  local halfHandSize = Vector(jefe.hand.img:getWidth()/2,jefe.hand.img:getHeight()/2)
  mahand.pos = Vector(580, 450) * mahand.scale
  mahand.light = lightWorld.newLight(0, 0, 126, 175, 255, 800)
  mahand.trail = trailmesh:new(love.mouse.getX(),love.mouse.getY(),blueFireImg,10,0.2,.01)

  mahand.light.setGlowSize(0.0)

  handPositions.lights = {}

  handPositions.lights[1] = new_light(Vector(268,194))
  handPositions.lights[2] = new_light(Vector(402,202))
  handPositions.lights[3] = new_light(Vector(532,208))
end

function new_light(p)
  local halfHandSize = Vector(jefe.hand.img:getWidth()/2,jefe.hand.img:getHeight()/2)
  local t = {pos = (p - halfHandSize) * jefe.hand.scale.x , trail = trailmesh:new(0,0,fireImg,20,0.5,.01)} 
  print(t.pos.x,t.pos.y)
  t.light = lightWorld.newLight(jefe.hand.originalPos.x+t.pos.x, jefe.hand.originalPos.y+t.pos.y, 105, 103, 03, 600)
  return t
end


function Game:enter(previous)
  swingers.start()
  love.audio.rewind(musicSource)
  love.audio.play(musicSource)
  beatIndex = -1

  beatSteps = {
    {"l","r","c","u"},
    {"l","r","u","d"},
    {"r","l","r","u"}}



  jefe.pos = jefe.originalPos:clone()

  jefe.hand.originalPos = handPositions.idle
  jefe.hand.lightOn = false
  jefe.hand.pos = jefe.hand.originalPos:clone()

  minions.originalPos = Vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2 + 150)
  minions.pos = minions.originalPos:clone()
  minions.scale = Vector(1,1)
  localTime = 0.0
  completedLastMove = true
end

function new_lights()
  for _,light in pairs(handPositions.lights) do
    light.trail = trailmesh:new(jefe.hand.pos.x+light.pos.x+math.cos(localTime*32)*5*math.cos(localTime*2),  jefe.hand.pos.y+light.pos.y+math.sin(localTime*32)*5*math.sin(localTime*2),fireImg,20,0.5,.01)
  end
end

function hand_move(start, finish)
  Flux.to(jefe.hand.pos, gameBeat/6, handPositions[start])
  :oncomplete(function() 
      jefe.hand.lightOn = true
      new_lights()
    end)
  :after((gameBeat/6)*4,handPositions[finish])
  :oncomplete(function() jefe.hand.lightOn = false end)
  :after(gameBeat/7,handPositions.idle)
end

function hand_circle()

  local precision = 16
  local c = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
  local r = (handPositions.idle - c):len()/2

  local arcTime = (gameBeat - gameBeat/3)/(precision+0.05)

  local offset = math.pi/2
  local nx = c.x + r * math.cos(offset)
  local ny = c.y+200 + r * math.sin(offset)

  local lastween = Flux.to(jefe.hand.pos,gameBeat/6,{x=nx,y=ny})
  for i=0,precision do
    local a = ((2*math.pi)/precision)*i + offset
    local nx = c.x + r * math.cos(a)
    local ny = c.y+200 + r * math.sin(a)
    if i == 0 then 
      jefe.hand.lightOn = true
      new_lights()
    end
    lastween = lastween:after(arcTime,{x=nx,y=ny}) 
  end
  lastween:oncomplete(function()jefe.hand.lightOn = false end):after(jefe.hand.pos,gameBeat/6,{x=handPositions.idle.x,y=handPositions.idle.y}):oncomplete(function() print("lol")end)
end

function update_trails(dt) 
  for i,light in pairs(handPositions.lights) do
    light.trail.x, light.trail.y = jefe.hand.pos.x+light.pos.x+math.cos(localTime*32)*5*math.cos(localTime*2),  jefe.hand.pos.y+light.pos.y+math.sin(localTime*32)*5*math.sin(localTime*2)
    light.trail:update(dt)
    light.light.setPosition(jefe.hand.pos.x+light.pos.x, jefe.hand.pos.x+light.pos.x)
    light.light.setRange(math.sin(40*localTime%(math.cos(localTime*i)*24.645))*30+650)
  end
  mahand.trail.x = love.mouse.getX()
  mahand.trail.y = love.mouse.getY()
  mahand.trail:update(dt)
end



function Game:update(dt) -- runs every frame
  swingers.update()
  Flux.update(dt)
  localTime = localTime + dt

  mahand.light.setPosition(love.mouse.getX(), love.mouse.getY())
  mahand.light.setRange(math.sin(40*localTime%(math.cos(localTime)*21.45))*20+200)

  local moveDist = 15
  local beatDist = math.abs(localTime % beat) 
  if beatDist < beat/5*4 then
    jefe.pos.y = jefe.originalPos.y - (beatDist / ((beat/5)*4)) * moveDist
    minions.pos.y = minions.originalPos.y - (beatDist / ((beat/5)*4)) * moveDist *0.4
  else
    jefe.pos.y = jefe.originalPos.y - (beat - (beat/5*4)) /(beat/5) * moveDist
    minions.pos.y = minions.originalPos.y - (beatDist / ((beat/5)*4)) * moveDist *0.4
  end

  update_trails(dt)

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
      elseif move == "c" then
        hand_circle()
      end
    end
  else
    if indexChanged then 
      swingers.start()
      completedLastMove = move == "none"
    end

    if swingers.checkGesture() then
      if move == "c" then
        if EditDistance({"w","nw","n","ne","e","se","s","sw","s"}, swingers.getExtGesture(),4) >= 4 then
          lose()
        else
          completedLastMove = true
        end
      else
        if move ~= swingers.getGesture() then
          lose()
        else
          completedLastMove = true
        end
      end
    end  
  end


end

function lose() 
 -- Gamestate.switch(Menu)
  love.audio.stop(musicSource)
  Gamestate.switch(Kill)
end


function Game:draw()

  lightWorld.update()
  love.postshader.setBuffer("render")

  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(background.img,0,-2800 + love.graphics.getHeight())

  love.graphics.draw(minions.img, minions.pos.x, minions.pos.y, 0, minions.scale.x,minions.scale.y, minions.img:getWidth()/2, minions.img:getHeight()/2)
  love.graphics.draw(jefe.img, jefe.pos.x, jefe.pos.y, 0, jefe.scale.x,jefe.scale.y, jefe.img:getWidth()/2, jefe.img:getHeight()/2)
  love.graphics.draw(jefe.hand.img, jefe.hand.pos.x, jefe.hand.pos.y, 0, jefe.hand.scale.x,jefe.hand.scale.y, jefe.hand.img:getWidth()/2, jefe.hand.img:getHeight()/2-100)


  local fireBlendMode = "additive"
  if ( jefe.hand.lightOn) then
    love.graphics.setBlendMode(fireBlendMode)
    handPositions.lights[1].trail:draw()
    handPositions.lights[2].trail:draw()
    handPositions.lights[3].trail:draw()
  end




  love.graphics.setBlendMode(fireBlendMode)
  mahand.trail:draw()
  love.graphics.setBlendMode("alpha")

  lightWorld.drawShadow()
  lightWorld.drawShine()
  lightWorld.drawPixelShadow()
  lightWorld.drawGlow()

  love.graphics.setBlendMode("alpha")
  love.graphics.draw(mahand.img, love.mouse.getX() - mahand.pos.x, love.mouse.getY() - mahand.pos.y, 0, mahand.scale,mahand.scale)

  love.postshader.draw()
end

function Game:keyreleased(key)
  if key == 'up' then
    print("released up")
  elseif key == 'down' then
    print("released down")
  end
end

function Game:mousepressed(x,y, mouse_btn)
  if mouse_btn == "l" then
    mahand.trail = trailmesh:new(love.mouse.getX(),love.mouse.getY(),blueFireImg,20,0.6,.01)
  end
end

function Game:mousereleased(x,y, mouse_btn)
  if mouse_btn == "l" then
    mahand.trail = trailmesh:new(love.mouse.getX(),love.mouse.getY(),blueFireImg,10,0.01,.01)
  end
end

return Game