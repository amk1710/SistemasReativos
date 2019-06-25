local width, height = 800, 600

local bubbleMod = require("bubble")

local readInterval = 0.25
local bubble = 0

--função auxiliar para centralizar os parametros de criação de uma bolha
local function newBubble()
  return bubbleMod.newBubble(20, width/2, height/2, 0, 0.2, 0.99, 0.05)
end

local thread -- Our thread object.

local function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function love.load()
  
  local threadCode = readAll("thread.lua")
  
  thread = love.thread.newThread( threadCode )
  thread:start( 99, 1000 )
  
  
  love.window.setMode(width, height)
  
  
  bubble = newBubble()

end

function love.update(dt)
  local now = love.timer.getTime()
  
  -- Make sure no errors occured, in the thread
  local error = thread:getError()
  assert( not error, error )
  
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
  
  -- Get the info channel and pop the next message from it.
  local info = love.thread.getChannel( 'info' ):pop()
  if info then
      love.graphics.print( info, 10, 10 )
  end
  
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