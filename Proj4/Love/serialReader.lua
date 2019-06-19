local serialib = require("serialib")

local serialReader = {}

function serialReader.init (checkTime)
  local inactiveUntil = 0
  local checkTime = checkTime
  
  local wait = function (checkTime) 
    inactiveUntil = love.timer.getTime() + checkTime
    coroutine.yield()
  end
  
  local function printSerial()
    while true do
      serialib:read(5) 
      if serialib:getMessage() ~= '' then
        print(serialib:getMessage())
      end
      wait(checkTime)
    end
  end
  
  return {
    update = coroutine.wrap(printSerial),
    
    draw = function ()
      love.graphics.print(serialib:getMessage());
    end,
    
    getInactiveUntil = function () return inactiveUntil end
    
  }
end

return serialReader