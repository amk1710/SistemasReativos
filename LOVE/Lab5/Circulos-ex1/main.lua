--exercício 01, círculos 

local TAM = 700
local status = 1
local quantos = 10
local dist = 0.5
local raio = 0.3

local raio_inicial = raio
local quantos_inicial = quantos

local function desenhacirculo(x,y,raio)
  love.graphics.setColor(0.6, 0.5, 0.3)
  love.graphics.circle("line", x, y, raio)   
end

local desenha

desenha = function (quantos, dist, raio)
    if raio > TAM/100000 then
      for i = 1, quantos do
        love.graphics.push()
        love.graphics.rotate(-i*(2*math.pi)/quantos)
        love.graphics.setLineWidth(TAM/100000)
        desenhacirculo (0, dist, raio)
        love.graphics.pop()
      end
      -- mudar: atualizar quantos e raio e chamar recursivamente!
    end
  end
  
  

desenha_aux = 
  function ()
    if raio > TAM/100000 then
      for i = 1, quantos do
        love.graphics.push()
        love.graphics.rotate(-i*(2*math.pi)/quantos)
        love.graphics.setLineWidth(TAM/100000)
        desenhacirculo (0, dist, raio)
        love.graphics.pop()
        
      end      
    
      coroutine.yield()
      raio = (3/4)*raio
      quantos = (4/3)*quantos
      desenha_aux()
    else
      raio = raio_inicial
      quantos = quantos_inicial
      desenha_aux()
      -- mudar: atualizar quantos e raio e chamar recursivamente!
    end
  end
  
desenha_co = coroutine.create(desenha_aux)

function love.load ()
  love.window.setTitle("circulos")
  love.window.setMode(TAM,TAM)
  love.graphics.setBackgroundColor(255,255,255)
  
  coroutine.resume(desenha_co)
end

function love.update (dt)
  love.timer.sleep(0.5)
    
  
end

function love.draw ()
  -- sistema normalizado [0,1]
  love.graphics.push()
  love.graphics.translate(TAM/2,TAM/2)
  love.graphics.scale(TAM/2,-TAM/2)
  --desenha (quantos, dist, raio)
  coroutine.resume(desenha_co)--, quantos, dist, raio)
  love.graphics.pop()
end