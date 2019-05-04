local blipModule = {}

local midi = require("luamidi")

function blipModule.newblip (vel, direction, player, note)
  local x, y = direction.x, direction.y
  local movementDir = direction.dir
  
  local inactiveUntil = 0
  local playerPosition = player.getPosition()
  
  local hit = true
  
  local wait = function (segundos) 
    inactiveUntil = love.timer.getTime() + segundos
    coroutine.yield()
  end
  
  local function up()
    while true do
      if hit then      
        x = x+10*movementDir[1]
        y = y+10*movementDir[2]
        if math.abs(x - playerPosition.x) < 20 and math.abs(y - playerPosition.y) < 20 then
          midi.noteOn(0, note.midi, 50, 1)
          hit = false
        end
      end
      wait(vel)
    end
  end
  
  return {
    update = coroutine.wrap(up),
    draw = function ()
      if hit then
        love.graphics.rectangle("line", x, y, 10, 10)
      end
    end,
    
    getInactiveUntil = function (timeStart) return inactiveUntil - timeStart end
    
  }
end

return blipModule