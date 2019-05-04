local playerModule = require("player")
local blipModule = require("blip")
local midi = require "luamidi"

midi.noteOn(0, 60, {50, 100, 50}, 1)
love.timer.sleep(1)
midi.noteOn(0, 60, {50, 100, 50}, 1)
local mov_speed = 2
local width, height = love.graphics.getDimensions( )
local directions = {
    right={x = 0, y = height/2, dir = {1, 0}},
    left={x = width-5, y = height/2, dir = {-1, 0}},
    down={x = width/2, y = 0, dir = {0, 1}},
    up={x = width/2, y = height-5, dir = {0, -1}},
  }


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
  listabls = {}
--  for i = 1, 5 do
--    listabls[i] = newblip(i, )
--  end
  
  i = 0
  for key, value in pairs(directions) do
    listabls[i] = blipModule.newblip(0.1, value, player)
    i = i + 1
  end
  listabls[i] = blipModule.newblip(0.1, directions.right, player)
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
end

function love.update(dt)
  now = love.timer.getTime()
  player.update(dt)
  for i = 1,#listabls do
    if now > listabls[i].getInactiveUntil() then
      listabls[i].update()
    end
  end
end

function love.keypressed(key)
  player.keypressed(key)
end
  
