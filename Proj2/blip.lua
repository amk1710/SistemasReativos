local blipModule = {}

function blipModule.newblip (vel, direction, player)
  local x, y = direction.x, direction.y
  local movementDir = direction.dir
  
  local inactiveUntil = 0
  local playerPosition = player.getPosition()
  
  local active = true
  
  local wait = function (segundos) 
    inactiveUntil = love.timer.getTime() + segundos
    coroutine.yield()
  end
  
  local function up()
    while true do
      if active then      
        x = x+10*movementDir[1]
        y = y+10*movementDir[2]
        
        print(math.abs(x - playerPosition.x))
        print(math.abs(y - playerPosition.y))
        if math.abs(x - playerPosition.x) < 20 and math.abs(y - playerPosition.y) < 20 then
          active = false
        end
      end
      wait(vel)
    end
  end
  
  return {
    update = coroutine.wrap(up),
    draw = function ()
      if active then
        love.graphics.rectangle("line", x, y, 10, 10)
      end
    end,
    
    getInactiveUntil = function () return inactiveUntil end
    
  }
end

return blipModule