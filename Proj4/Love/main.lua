local serialib = require('serialib')

function love.load()
  serialib:openPort("/dev/tty.usbserial-14110", 'r')
end

function love.update(dt)
  serialib:read(20)
  print(serialib:getMessage())
end

function love.draw()
-- love.graphics.print(serialib:getMessage());
end

function love.keypressed(key)
  if(key == "escape") then
    love.quit();
  end
end