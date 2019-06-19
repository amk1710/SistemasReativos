local serialib = require('serialib')
local serialReader = require('serialReader')

local readInterval = 0.25

function love.load()
  serialib:openPort("/dev/cu.usbserial-14310", 'r')
  
  sr = serialReader.init(readInterval)
end

function love.update(dt)
  local now = love.timer.getTime()
  
  if now - sr.getInactiveUntil() > readInterval then
    sr.update()
  end
end

function love.draw()
  sr.draw()
end

function love.keypressed(key)
  if(key == "escape") then
    love.quit();
  end
end