--thread: le do serial e repassa à main

--[[
-- Receive values sent via thread:start
local min, max = 0, 100
 
for i = min, max do
    -- The Channel is used to handle communication between our main thread and
    -- this thread. On each iteration of the loop will push a message to it which
    -- we can then pop / receive in the main thread.
    love.thread.getChannel( 'info' ):push( i )
end
--]]

local serialib = require('serialib')

--serialib:openPort("/dev/cu.usbserial-14310", 'r')

local i = 0
while true do
  
  
  --[[
  serialib:read(1) -- ou 5, sei lá 
  if serialib:getMessage() ~= '' then
    love.thread.getChannel( 'info' ):push( serialib:getMessage() )
  end
  --]]
  
  love.thread.getChannel( 'info' ):push( i )
  i = i + 1 or 0
  
end