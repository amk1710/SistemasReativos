local morse = {}

local dot = "."
local dash = "-"
local short_pause = " "
local medium_pause = "   " -- 3 espaços
local long_pause = "       " -- 7 espaços

morse.letters = {
   a = {dot, dash},
   b = {dash, dot, dot, dot},
   c = {dash, dot, dash, dot},
   d = {dash, dot, dot},
   e = {dot},
   f = {dot, dot, dash, dot},
   g = {dash, dash, dot},
   h = {dot, dot, dot, dot},
   i = {dot, dot},
   j = {dot, dash, dash, dash},
   k = {dash, dot, dash},
   l = {dot, dash, dot, dot},
   m = {dash, dash},
   n = {dash, dot},
   o = {dash, dash, dash},
   p = {dot, dash, dash, dot},
   q = {dash, dash, dot, dash},
   r = {dot, dash, dot},
   s = {dot, dot, dot},
   t = {dash},
   u = {dot, dot, dash},
   v = {dot, dot, dot, dash},
   w = {dot, dash, dash},
   x = {dash, dot, dot, dash},
   y = {dash, dot, dash, dash},
   z = {dash, dash, dot, dot},
   ['0'] = {dash, dash, dash, dash, dash},
   ['1'] = {dot, dash, dash, dash, dash},
   ['2'] = {dot, dot, dash, dash, dash},
   ['3'] = {dot, dot, dot, dash, dash},
   ['4'] = {dot, dot, dot, dot, dash},
   ['5'] = {dot, dot, dot, dot, dot},
   ['6'] = {dash, dot, dot, dot, dot},
   ['7'] = {dash, dash, dot, dot, dot},
   ['8'] = {dash, dash, dash, dot, dot},
   ['9'] = {dash, dash, dash, dash, dot},
   ['.'] = {dot, dash, dot, dash, dot, dash},
   [','] = {dash, dash, dot, dot, dash, dash},
   ['?'] = {dot, dot, dash, dash, dot, dot},
   ["'"] = {dot, dash, dash, dash, dash, dot},
   ['!'] = {dash, dot, dash, dot, dash, dash},
   ['/'] = {dash, dot, dot, dash, dot},
   ['('] = {dash, dot, dash, dash, dot},
   [')'] = {dash, dot, dash, dash, dot, dash},
   [':'] = {dash, dash, dash, dot, dot, dot},
   [';'] = {dash, dot, dash, dot, dash, dot},
   ['='] = {dash, dot, dot, dot, dash},
   ['+'] = {dot, dash, dot, dash, dot},
   ['-'] = {dash, dot, dot, dot, dot, dash},
   ['"'] = {dot, dash, dot, dot, dash, dot},
   ['@'] = {dot, dash, dash, dot, dash, dot},
}

morse.encode = function (text)

    local encoding = ""
    local first_word = true
    for word in string.gmatch(text, "%w+") do
        if first_word then
            first_word = false
        else
            encoding = encoding..long_pause
        end

        local first_letter = true

        for letter in string.gmatch(word, "%w") do

            if first_letter then
                first_letter = false
            else
                encoding = encoding..medium_pause
            end

            local first_symbol = true

            for k, symbol in ipairs(morse.letters[letter]) do
                if first_symbol then
                    first_symbol = false
                else
                    encoding = encoding..short_pause
                end

                encoding = encoding..symbol
            end
        end
    end

    return encoding
end

return morse