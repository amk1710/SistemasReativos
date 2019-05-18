--script que organiza a paleta(das quatro direções!), indicando feedback visual ao ato de apertar a tecla

local paleta = {}

local width, height = love.graphics.getDimensions( )
local squareSize = 10
local cx, cy = width / 2, height / 2
local offset = 10

local framesLeft = {up = 0, down = 0, left = 0, right = 0}

local buttons = {}


function paleta.load()
  --carrega os spritesheets das quatro direções
  local img = love.graphics.newImage("anim.png")
  buttons.up = {}
  buttons.up.activated = img
  
end

function paleta.draw()
  --anda com a animação de cada direção
  for dir, value in pairs(framesLeft) do
    if value > 0 then
      love.graphics.rectangle("line", cx, cy, squareSize, squareSize)
      framesLeft[dir] = framesLeft[dir] - 1
    end
  end
  
end

function paleta.refreshInput(direction)
    framesLeft[direction] = 20
end

return paleta