local morse = require("morse")
local servidor = {}
local mqtt_channel = "broadcast"

servidor.open = function()


    hex_to_char = function(x)
      print(string.char(tonumber(x, 16)))
      return string.char(tonumber(x, 16))
    end

    local unescape = function(url)

      return url:gsub("%%(%x%x)", hex_to_char)
    end

    srv = net.createServer(net.TCP)

    function receiver(sck, request)
      print("recebeu: " .. request)

      -- analisa pedido para encontrar valores enviados
      local _, _, method, path, vars = string.find(request, "([A-Z]+) ([^?]+)%?([^ ]+) HTTP");
      -- se nÃ£o conseguiu casar, tenta sem variÃ¡veis
      if(method == nil)then
        _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
      end

      local _GET = {}

      if (vars ~= nil)then
        for k, v in string.gmatch(vars, "(%w+)=(.+)&*") do
          _GET[k] = v
        end
      end

      local text  = _GET.text
      local returnString = "Mensagem não recebida"
      if(text ~= nil and string.len(text) > 0) then
        returnString = morse.encode(unescape(text))
        m:publish(mqtt_channel, returnString, 0, 1)
      end

      sck:send(returnString,
               function()  -- callback: fecha o socket qdo acabar de enviar resposta
                 print("respondeu")
                 sck:close()
               end)
    end

    if srv then
      srv:listen(80, function(conn)
          print("CONN")
          conn:on("receive", receiver)
        end)

        m = mqtt.Client("pedro", 120)
        -- conecta com servidor mqtt na máquina 'ipbroker' e porta 1883:
        m:connect("85.119.83.194", 1883, 0,
            -- callback em caso de sucesso
            function(client)
                print("mqtt connected")

                m:on("message",
                    function(client, topic, data)
                        --print(topic .. ": " .. data )

						--inicializa��o:
						local led1 = 3
						gpio.mode(led1, gpio.OUTPUT)
						pause_time = 0.2 --tempo de pausa em segundos

						for _, symbol in ipairs(data) do
							if symbol == "." then
								--acende por uma unidade de tempo
								gpio.write(led1, gpio.HIGH)
								tmr.delay(1*pause_time)
								gpio.write(led1, gpio.LOW)

							elseif symbol == "-"
								--acende por 3 unidade de tempo
								gpio.write(led1, gpio.HIGH)
								tmr.delay(3*pause_time)
								gpio.write(led1, gpio.LOW)
							else
								--se n�o for . ou -, pausa por 1 uma unidade de tempo
								tmr.delay(1*pause_time)

							end
						end

                    end
                )

                m:subscribe(mqtt_channel, 0,
                    -- fç chamada qdo inscrição ok:
                    function (client)
                        print("subscribe success")
                    end,
                    --fç chamada em caso de falha:
                    function(client, reason)
                        print("subscription failed reason: "..reason)
                    end
                )
            end,
            -- callback em caso de falha
            function(client, reason)
                print("connection failed reason: "..reason)
            end
        )
    end

    port, addr = srv:getaddr()
    print(addr, port)
    print("servidor inicializado.")

end

return servidor
