local serialib = {
  message = "";
  port = "";
  mode = "";
}

function serialib.openPort(self,port,mode) -- Name of PORT and a mode "r" for reading and "w" for writing
  local m = mode or "r"
  local p = assert(io.open(port,m),"The port "..port.." could not be found.");
  self.port = p;
  self.mode = m;
end

function serialib.closePort() -- Closes the port
  self.port:close();
end

function serialib.read(self,length) -- Read from the port, length specifies the length of the message 
  local l = length or 1
  self.message = self.port:read(l);
  self.port:flush();
end

function serialib.write(self,message) -- Writes to the port, message is the message being sent
  local m = message or "Hello World!"
  self.port:write(m.."\n");
  self.port:flush();
end

function serialib.getMessage(self)-- If the port is in reading mode, this function returns the message it received from the port
  if(self.mode == "r") then return self.message; else return "Not reading!" end
end

return serialib;