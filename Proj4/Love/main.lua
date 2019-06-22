--local serialib = require('serialib')
--local serialReader = require('serialReader')

local width, height = 800, 600

local bubbleMod = require("bubble")

local readInterval = 0.25
local bubble = 0

--função auxiliar para centralizar os parametros de criação de uma bolha
local function newBubble()
  return bubbleMod.newBubble(20, width/2, height/2, 0, 0.2, 0.99, 0.05)
end

function love.load()
  --serialib:openPort("/dev/cu.usbserial-14310", 'r')
  --sr = serialReader.init(readInterval)
  love.window.setMode(width, height)
  
  
  bubble = newBubble()

end

function love.update(dt)
  local now = love.timer.getTime()
  
  --[[
  if now - sr.getInactiveUntil() > readInterval then
    sr.update()
  end
  ]]--
  
  bubble.update(dt)
  
  if bubble.checkOutOfBounds(0, 0, width, height) then
    bubble = newBubble()
  end
  
end

function love.draw()
  --sr.draw()
  bubble.draw()
end

function love.keypressed(key)
  if(key == "escape") then
    love.quit();
  end
  
  if(key == "up") then
    bubble.addSpeed(0, -1)
  end
  
  if(key == "down") then
    bubble.addSpeed(0, 1)
  end
  
  if(key == "right") then
    bubble.addSpeed(1, 0)
  end
  
  if(key == "left") then
    bubble.addSpeed(-1, 0)
  end
  
  
end