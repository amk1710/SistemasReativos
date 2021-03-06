local playerModule = require("player")
local blipModule = require("blip")
local songPlayer = require("songPlayer")

local songName = "Megalovania"

local hitTolerance = 1.2

local mov_speed = 2
love.window.setMode(800, 800)
local width, height = love.graphics.getDimensions( )

local directions = {
  right={x = 0, y = height/2, dir = {1, 0}},
  left={x = width, y = height/2, dir = {-1, 0}},
  down={x = width/2, y = 0, dir = {0, 1}},
  up={x = width/2, y = height, dir = {0, -1}},
}
local directionsMap = {"right", "down", "left", "up"}

local timeStart
local lastTime = 0
local music = love.audio.newSource(songName .. ".mp3", "static")
local projectiles = {}
local currentProjectile = 1
local nextProjectile = 1
local musicStart = 0

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
  listabls = {}
  timeStart = love.timer.getTime()
  
  love.graphics.setBackgroundColor( 0.5, 0, 0, 1)
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
end

function love.update(dt)
  now = love.timer.getTime() - timeStart
  
--  if not (musicStart == 0) and now > musicStart + 1 and not music:isPlaying() then
--    love.audio.play(music)
--  end
  player.update(dt)
  for i = 1,#listabls do
    if now > listabls[i].getInactiveUntil(timeStart) then
      listabls[i].update(dt)
    end
  end
  
  if currentProjectile < #projectiles and ((now > projectiles[currentProjectile].time and projectiles[currentProjectile].time > lastTime)) then
    while projectiles[currentProjectile].time < now do
      --rand = math.random(4)
      rand = (projectiles[currentProjectile].note.midi % 4) + 1
      
      local speed = 2/width
      
      if musicStart == 0 then musicStart = now end
      listabls[#listabls+1] = blipModule.newblip(speed, directions[directionsMap[rand]], player, projectiles[currentProjectile].note)
      currentProjectile = currentProjectile + 1
      if currentProjectile > #projectiles then break end
    end
  end
  
  lastTime = now
end

function love.keypressed(key)
  local pressTime = love.timer.getTime() - timeStart - musicStart
  
  while(pressTime - projectiles[nextProjectile].time > 0) do
    nextProjectile = nextProjectile + 1
  end
  
  local projectileDir
  if (nextProjectile <= #listabls) then
    projectileDir = listabls[nextProjectile].getMovementDir()
  else
    return 
  end
  
  print(nextProjectile)
  if (math.abs(pressTime - projectiles[nextProjectile].time) < hitTolerance) then
    if (key == "right" and projectileDir[1] == -1) or
       (key == "up" and projectileDir[2] == 1) or
       (key == "down" and projectileDir[2] == -1) or
       (key == "left" and projectileDir[1] == 1) then
      print("Hit!")
      listabls[nextProjectile].setHit(false)
      listabls[nextProjectile].play()
      nextProjectile = nextProjectile + 1
    else
      print("Error!")
    end
  end
end
  
