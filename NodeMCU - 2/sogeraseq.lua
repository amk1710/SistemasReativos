wificonf = {
    -- verificar ssid e senha
    ssid = "Rafa",
    pwd = "rafagato",
    got_ip_cb = function (con)
        print ("meu IP: ", con.IP)

        m = mqtt.Client("clientid", 120)
        -- conecta com servidor mqtt na máquina 'ipbroker' e porta 1883:
        m:connect("test.mosquitto.org", 1883, 0,
            -- callback em caso de sucesso
            function(client) 
                print("connected")
                
                m:on("message",
                    function(client, topic, data)
                        print(topic .. ":" )
                        if data ~= nil then print(data) end
                    end
                )
                
                m:subscribe("alos", 0,
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
    end,
    save = false
}

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)