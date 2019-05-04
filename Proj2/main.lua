local playerModule = require("player")
local blipModule = require("blip")
--local midi = require("luamidi")
--local json = require("json")
local songPlayer = require("songPlayer")

local songName = "SpearOfJustice"

local mov_speed = 2
local width, height = love.graphics.getDimensions( )
local directions = {
  right={x = 0, y = height/2, dir = {1, 0}},
  left={x = width-5, y = height/2, dir = {-1, 0}},
  down={x = width/2, y = 0, dir = {0, 1}},
  up={x = width/2, y = height-5, dir = {0, -1}},
}
local directionsMap = {"right", "left", "down", "up"}

local timeStart
local lastTime = 0
local music = love.audio.newSource(songName .. ".mp3", "static")
local projectiles = {}
local currentProjectile = 1

function love.keypressed(key)
  if key == 'a' then
    pos = player.try()
    for i in ipairs(listabls) do
      local hit = listabls[i].affected(pos)
      if hit then
        table.remove(listabls, i) -- esse blip "morre" 
        return -- assumo que apenas um blip morre
      end
    end
  end
end

function love.load()
  player =  playerModule.newplayer(width, height)
  projectiles = songPlayer.getProjectiles(songName .. ".json")
  print(projectiles)
  listabls = {}
  timeStart = love.timer.getTime()
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
end

function love.update(dt)
  now = love.timer.getTime() - timeStart
  
  if now > 1 and lastTime < 1 then
    love.audio.play(music)
  end
  player.update(dt)
  for i = 1,#listabls do
    if now > listabls[i].getInactiveUntil(timeStart) then
      listabls[i].update()
    end
  end
  
  if currentProjectile < #projectiles and now > projectiles[currentProjectile] and projectiles[currentProjectile] > lastTime then
    while projectiles[currentProjectile] < now do
      rand = math.random(4)
      local speed = 1/(2*(projectiles[currentProjectile]-now))
      if rand == 1 or rand == 2 then
        speed = width*speed
      else
        speed = height*speed
      end
      listabls[#listabls+1] = blipModule.newblip(speed, directions[directionsMap[rand]], player)
      currentProjectile = currentProjectile + 1
      if currentProjectile > #projectiles then break end
    end
  end
  
  lastTime = now
end

function love.keypressed(key)
  player.keypressed(key)
end
  
