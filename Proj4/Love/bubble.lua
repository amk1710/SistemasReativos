
--bubble.lua: implementa o comportamento de uma bolha

local bubbleModule = {}

local difficultyLevels = 
{
    {startingTime = 0, randomWalkCoefficient = 0},
    {startingTime = 10, randomWalkCoefficient = 0.2},
    {startingTime = 20, randomWalkCoefficient = 0.4},
    {startingTime = 30, randomWalkCoefficient = 0.6},
    {startingTime = 40, randomWalkCoefficient = 0.8},
    {startingTime = 50, randomWalkCoefficient = 1.0},
    {startingTime = 60, randomWalkCoefficient = 1.5}
    
}

local pop = love.audio.newSource("pop.wav", "static")

bubbleModule.newBubble = function(radius, positionX, positionY, gravityX, gravityY, dragCoefficient, randomWalkCoefficient, useDynamicDifficulty)
  
  local radius = radius or 5
  local posX = positionX or 0
  local posY = positionY or 0
  local gravX = gravityX or 0
  local gravY = gravityY or 0
  local dragCoefficient = dragCoefficient or 0.5
  local randomWalkCoefficient = randomWalkCoefficient or 0.1
  if useDynamicDifficulty then randomWalkCoefficient = difficultyLevels[1].randomWalkCoefficient end
  local useDynamicDifficulty = useDynamicDifficulty or false
  
  local img = love.graphics.newImage("BubbleSimple.png")
  local img_w, img_h = img:getWidth(), img:getHeight()
  
  --os fatores de escala da imagem, para compensar o fato de ela ser muito maior do que é necessário
  --consideramos como valor desejado para a largura e altura final da imagem radius*2
  -- img_w * sx = radius*2
  local sx, sy = radius * 2 / img_w, radius * 2 / img_h
  
  --local popSound = love.audio.newSource("pop.wav", "static")
  
  local speedX = 0
  local speedY = 0
  
  local dtCount = 0
  local dtInterval = 0.2
  
  local bubble = {}
  
  local startingTime = love.timer.getTime()
  local currentDifficulty = 1
  
  bubble.update = function(dt)
    
    --atualiza coeficiente randomico, baseado no tempo que já passou
    if useDynamicDifficulty and difficultyLevels[currentDifficulty + 1] ~= nil and love.timer.getTime() - startingTime > difficultyLevels[currentDifficulty + 1].startingTime then
      currentDifficulty = currentDifficulty + 1
      randomWalkCoefficient = difficultyLevels[currentDifficulty].randomWalkCoefficient
    end
    
    --atualiza velocidade instantânea
    speedX = speedX*dragCoefficient + dt*gravityX
    speedY = speedY*dragCoefficient + dt*gravityY
    
    dtCount = dtCount + dt
    if dtCount > dtInterval then
      dtCount = 0
      local rx = math.random(-1, 1)
      local ry = math.random(-1, 1)
      speedX = speedX + rx*randomWalkCoefficient
      speedY = speedY + ry*randomWalkCoefficient      
    end
    
    --atualiza posicao
    posX = posX + speedX
    posY = posY + speedY
    
    --checa colisão?
  end
  
  bubble.draw = function()
      
      love.graphics.draw(img, posX, posY, 0, sx, sy, img_w/2, img_h/2)
      
      if useDynamicDifficulty then
        local str = "Difficulty: " .. currentDifficulty --..", "..randomWalkCoefficient
        love.graphics.print( str, 50, 50, 0, 1, 1)
        love.graphics.print( "Time: " .. string.format("%.2f", love.timer.getTime() - startingTime), 50, 70, 0, 1, 1)
      end
      
  end
  
  bubble.addSpeed = function (deltaX, deltaY)
    speedX = speedX + deltaX
    speedY = speedY + deltaY
  end
  
  bubble.pop = function()
    love.audio.play(pop)
    print("Time: " .. string.format("%.2f", love.timer.getTime() - startingTime))
  end
  
  bubble.checkOutOfBounds = function(minx, miny, maxx, maxy)
    if posX - radius < minx or
       posX + radius > maxx or
       posY - radius < miny or
       posY + radius > maxy then
         
         bubble.pop()
         return true
    else
      return false
    end
  end
  
  return bubble
  
end


return bubbleModule