local songPlayerModule = {}

local open = io.open
local json = require("json")
local midi = require("luamidi")


local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end


function songPlayerModule.getProjectiles(filepath)
  local file = read_file(filepath);
  local song = json.decode(file)  
  local projectiles = {}
  for track = 1,#song.tracks do
    if song.tracks[track].instrumentFamily == "piano" then
      for note = 1, #song.tracks[track].notes do
        if(#projectiles == 0 or song.tracks[track].notes[note].time+1 ~= projectiles[#projectiles].time) then
          projectiles[#projectiles+1] = {
            time = song.tracks[track].notes[note].time+1,
            note = song.tracks[track].notes[note]
          }
          
        end
      end
    end
  end
  return projectiles
end

return songPlayerModule