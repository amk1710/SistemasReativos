--script que organiza a paleta(das quatro direções!), indicando feedback visual ao ato de apertar a tecla

local paleta = {}

local squareSize = 10
local img_w, img_h = 32, 32
local activeTime = 0.15

local buttons = {}

local function newButton(path_idleImg, path_pressedImg, cx, cy)
  local button = {}
  local img = love.graphics.newImage(path_idleImg)
  button.idleImg = img
  local img2 = love.graphics.newImage(path_pressedImg)
  button.pressedImg = img2
  button.framesLeft = 0
  button.cx = cx
  button.cy = cy
  
  return button
  
end


function paleta.load()
  --carrega os spritesheets das quatro direções
  local width, height = love.graphics.getDimensions( )
  print("widht:", width, "height:", height)
  local cx, cy = width / 2, height / 2
  local offset = 32 --offset do centro, para o desenho

  
  
  buttons.up = newButton("button_0_idle.png", "button_0_pressed.png", cx, cy - offset)
  buttons.down = newButton("button_1_idle.png", "button_1_pressed.png", cx, cy + offset)
  buttons.left = newButton("button_2_idle.png", "button_2_pressed.png", cx - offset, cy)
  buttons.right = newButton("button_3_idle.png", "button_3_pressed.png", cx + offset, cy)

  
end

function paleta.draw()
  --anda com a animação de cada direção
  for dir, button in pairs(buttons) do
    if button.framesLeft > 0 then
      love.graphics.draw(button.pressedImg, button.cx, button.cy, 0, 1, 1, img_w / 2, img_h / 2)
    else
      love.graphics.draw(button.idleImg, button.cx, button.cy, 0, 1, 1, img_w / 2, img_h / 2)
    end
  end
  
end

function paleta.update(dt)
  for _, button in pairs(buttons) do
    button.framesLeft = math.max(0, button.framesLeft - dt) --tudo bem que agora framesLeft não é mais exatamente contado em frames... mas não vou renomear agora
  end
end

function paleta.refreshInput(direction)
    if buttons[direction] ~= nil then buttons[direction].framesLeft = activeTime end
end

return paleta