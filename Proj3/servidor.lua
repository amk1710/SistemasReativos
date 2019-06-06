local morse = require("morse")
local servidor = {}

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
      end
      
    
    -- local buf = [[
    -- <html>
    -- <body>
    -- <h1><u>PUC Rio</u></h1>
    -- <h2><i>ESP8266 Web Server</i></h2>
    --         <p>Temperatura: $TEMP oC <a href="?pin=LERTEMP"><button><b>REFRESH</b></button></a>
    --         <p>PISCA LED 1: $STLED1  <a href="?pin=LIGA1"><button><b>ON</b></button></a>
    --                             <a href="?pin=DESLIGA1"><button><b>OFF</b></button></a></p>
    --         <p>PISCA LED 2: $STLED2  <a href="?pin=LIGA2"><button><b>ON</b></button></a>
    --                             <a href="?pin=DESLIGA2"><button><b>OFF</b></button></a></p>
    -- </body>
    -- </html>
    -- ]]
    
    
      --buf = string.gsub(buf, "$(%w+)", vals)
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
    end
    
    port, addr = srv:getaddr()
    print(addr, port)
    print("servidor inicializado.")

end

return servidor
