local width, height = 600, 600

local bubbleMod = require("bubble")

local readInterval = 0.25
local bubble = 0

local songName = "M.O.O.N. - Crystals [Hotline Miami Soundtrack].mp3"
local music = love.audio.newSource(songName, "static")

--função auxiliar para centralizar os parametros de criação de uma bolha
local function newBubble()
  return bubbleMod.newBubble(20, width/2, height/2, 0, 0.2, 0.99, 0.5, true)
end

local thread -- Our thread object.

local function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function love.load()
  
--  local threadCode = readAll("thread.lua")
  music:setLooping(true)
  love.audio.play(music)
  thread = love.thread.newThread( "thread.lua" )
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
  
  -- Get the info channel and pop the next message from it.
  local command = love.thread.getChannel( 'info' ):pop()
  if command == 'r' then
    bubble.addSpeed(3, 0)
  elseif command == 'l' then
    bubble.addSpeed(-3, 0)
  elseif command == 'u' then
    bubble.addSpeed(0, -3)
  elseif command == 'd' then
    bubble.addSpeed(0, 3)
  end

  bubble.update(dt)
  
  if bubble.checkOutOfBounds(0, 0, width, height) then
    bubble.pop()
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
