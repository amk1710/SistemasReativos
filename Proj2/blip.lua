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
  
  local wait = function (segundos) 
    inactiveUntil = love.timer.getTime() + segundos
    coroutine.yield()
  end
  
  local function up()
    while true do
      if hit then      
        x = x+10*movementDir[1]
        y = y+10*movementDir[2]
        if math.abs(x - (playerPosition.x+10)) < 20 and math.abs(y - (playerPosition.y+10)) < 20 then
          midi.noteOn(0, note.midi, 50, 1)
          hit = false
        end
      end
      wait(vel)
    end
  end
  
  img = love.graphics.newImage("MusicalNote.png")
  animation = newAnimation(img, 32, 32, 10)
  
  return {
    update = coroutine.wrap(up),
    draw = function ()
      if hit then
        --love.graphics.rectangle("line", x, y, 10, 10)
        love.graphics.draw(animation.spriteSheet, x, y)
      end
    end,
    
    getInactiveUntil = function (timeStart) return inactiveUntil - timeStart end
    
  }
end

return blipModule