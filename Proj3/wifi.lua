
servidor = require("servidor")

wificonf = {  
  -- verificar ssid e senha  
  ssid = "morsemcu",  
  pwd = "morsemcu",  
  --ssid = "reativos",  
  --pwd = "morsemcu",  
  
  got_ip_cb = function (con)
                print ("meu IP, porta: ", con.IP, " ", con.port)
                servidor.open()
              end,
  save = false}

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
