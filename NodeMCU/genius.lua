--[[
READ-ME:
Um breve jogo de genius, implementado em NodeMCU. O jogo vai ficando mais dificil enquanto você ganha, 
e quando perde reseta a dificuldade de uma nota. Quando você acerta, a luz verde pisca algumas vezes rápidom, 
quando você perde, a luz vermelha

--]]



local led1 = 3
local led2 = 6
local sw1 = 1
local sw2 = 2

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);

gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)

local tempoaceso = 200000
local seqrodada = {}
local tamseq = 1

local function coolBlink(button_number)
    --blinks a couple of times
    gpio.write(3*button_number, gpio.HIGH)
    tmr.delay(3*tempoaceso)
    gpio.write(3*button_number, gpio.LOW)
    tmr.delay(1*tempoaceso)

    gpio.write(3*button_number, gpio.HIGH)
    tmr.delay(3*tempoaceso)
    gpio.write(3*button_number, gpio.LOW)
    tmr.delay(1*tempoaceso)

    gpio.write(3*button_number, gpio.HIGH)
    tmr.delay(1*tempoaceso)
    gpio.write(3*button_number, gpio.LOW)
    tmr.delay(1*tempoaceso)

    gpio.write(3*button_number, gpio.HIGH)
    tmr.delay(1*tempoaceso)
    gpio.write(3*button_number, gpio.LOW)
    tmr.delay(1*tempoaceso)

    gpio.write(3*button_number, gpio.HIGH)
    tmr.delay(1*tempoaceso)
    gpio.write(3*button_number, gpio.LOW)
    tmr.delay(1*tempoaceso)
end

--função para o tratamento da segunda interação com o programa
--(o joguinho de genius)
local currButton = 1
local function genius(button_number)
   
    if button_number == seqrodada[currButton] then
        --acertou!
        print("acertou!", button_number, seqrodada[currButton])
        
        --acende a luz pra dizer que tu acertou bem
        gpio.write(3*seqrodada[currButton], gpio.HIGH)
        tmr.delay(3*tempoaceso)
        gpio.write(3*seqrodada[currButton], gpio.LOW)
        tmr.delay(2*tempoaceso)

        if currButton == tamseq then
            --ganhou o jogo!            
            --desativa callbacks
            gpio.trig(sw1)
            gpio.trig(sw2)

            coolBlink(2)

            --reseta o jogo, mais dificil
            currButton = 1
            tamseq = tamseq + 1
            gpio.trig(sw1, "down", cbchave1)            
            
        end
        currButton = currButton + 1
        
        
        return
        
    else
        print("errou!", button_number, seqrodada[currButton])
        --desativa callbacks
        gpio.trig(sw1)
        gpio.trig(sw2)

        coolBlink(1)

        --reseta o jogo, do 1
        currButton = 1
        tamseq = 1
        gpio.trig(sw1, "down", cbchave1)    
    
    end

end

--a callback da segunda parte, para o primeiro botão e o segundo botão
local function cbchave2_1(_, contador)
    print("botão 1")
    genius(1)
end

local function cbchave2_2(_, contador)
    print("botão 2")
    genius(2)
end

function geraseq (semente)
  print ("veja a sequencia:")
  tmr.delay(2*tempoaceso)
  print ("(" .. tamseq .. " itens)")
  math.randomseed(semente)
  for i = 1,tamseq do
    seqrodada[i] = math.floor(math.random(1.5,2.5))
    print(seqrodada[i])
    gpio.write(3*seqrodada[i], gpio.HIGH)
    tmr.delay(3*tempoaceso)
    gpio.write(3*seqrodada[i], gpio.LOW)
    tmr.delay(2*tempoaceso)
    
  end
  print ("agora (seria) sua vez:")
  
  --associa callbacks para a segunda parte da execução
  gpio.trig(sw1, "down", cbchave2_1)
  gpio.trig(sw2, "down", cbchave2_2)
  --agora é só esperar a resposta do player, tratada pelas callbacks. Essa função acabou
  
end

function cbchave1 (_,contador)
  -- corta tratamento de interrupções
  -- (passa a ignorar chave)
  gpio.trig(sw1)
  -- chama função que trata chave
  geraseq (contador)
end

gpio.trig(sw1, "down", cbchave1)

