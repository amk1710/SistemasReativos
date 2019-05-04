local playerModule = {}

function playerModule.newplayer (width, height)
  local x, y = width/2 - 10, height/2 - 10
  local rotation = 0
  
  return {
    try = function ()
      return x
    end,
    update = function (dt)
  --    x = x + 0.5
  --    if x > width then
  --      x = 0
  --    end
    end,
    draw = function ()
      love.graphics.rectangle("line", x, y, 30, 30)
    end,
    keypressed = function (key)
      if love.keyboard.isDown("right") then 
        rotation = 0
      elseif love.keyboard.isDown("up") then 
        rotation = 90
      elseif love.keyboard.isDown("left") then 
        rotation = 180
      elseif love.keyboard.isDown("down") then 
        rotation = 270
      end
      print(rotation)
    end,
    getPosition = function () return {x = x, y = y} end
  }
end

return playerModule
