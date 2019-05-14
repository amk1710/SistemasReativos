local blipModule = {}

local midi = require("luamidi")

-- referência de animação: https://love2d.org/wiki/Tutorial:Animation
function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    
    animation.quads = {};
    for y = 0, image:getHeight() - height, height do
      for x = 0, image:getWidth() - width, width do
        table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
      end
    end
 
    animation.duration = duration or 1
    animation.currentTime = 0
 
    return animation
end



function blipModule.newblip (vel, direction, player, note)
  local x, y = direction.x, direction.y
  local movementDir = direction.dir
  
  local inactiveUntil = 0
  local playerPosition = player.getPosition()
  
  local hit = true
  
  local img = love.graphics.newImage("anim.png")
  local animation = newAnimation(img, 32, 32, 0.2)
  
  local wait = function (segundos) 
    inactiveUntil = love.timer.getTime() + segundos
    coroutine.yield()
  end
  
  local function up(dt)
    while true do
      if hit then      
        x = x+10*movementDir[1]
        y = y+10*movementDir[2]
        if math.abs(x - (playerPosition.x+10)) < 20 and math.abs(y - (playerPosition.y+10)) < 20 then
          midi.noteOn(0, note.midi, 50, 1)
          hit = false
        end
        
        --[[animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
          animation.currentTime = animation.currentTime - animation.duration
        end
        --]]
        
        animation.currentTime = love.timer.getTime() % #animation.quads
        
        
      end
      wait(vel)
    end
  end
  
  return {
    update = coroutine.wrap(up),
    draw = function ()
      if hit then
        --love.graphics.rectangle("line", x, y, 10, 10)
        
        --o índice do frame de animação:
        --local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1    
        local spriteNum = (math.floor(love.timer.getTime() / animation.duration) % #animation.quads) + 1
        print("spriteNum", spriteNum)
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], x, y)
      end
    end,
    
    getInactiveUntil = function (timeStart) return inactiveUntil - timeStart end
    
  }
end

return blipModule