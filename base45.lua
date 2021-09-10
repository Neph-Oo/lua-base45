--[[
   Copyright © 2021 Neph <neph@crypt.lol>
   This program is free software. It comes without any warranty, to
   the extent permitted by applicable law. You can redistribute it
   and/or modify it under the terms of the Do What The Fuck You Want
   To Public License, Version 2, as published by Sam Hocevar. 
   See the LICENSE file for more details.
]]

--[[
   Based on draft-faltstrom-base45-07
   https://datatracker.ietf.org/doc/draft-faltstrom-base45/
]]

local m = {}


local alphabet = {
   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
   'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
   'U', 'V', 'W', 'X', 'Y', 'Z', ' ', '$', '%', '*',
   '+', '-', '.', '/', ':'
}



local function split_str (str)
   local bytes_array = {}

   local j = 0
   local k = 0
   for i = 1, string.len(str) do
      j = j + 1
      if j == 1 then
         k = k + 1
         bytes_array[k] = {}
      end
      bytes_array[k][j] = string.byte(str, i)
      if j >= 2 then j = 0 end
   end

   return bytes_array
end


local function _encode_base45 (str)
   local bytes_array = split_str(str)
   local b45str = ""
   local odd = string.len(str) % 2

   for i = 1, #bytes_array - odd do
      local n = bytes_array[i][1] * 256 + bytes_array[i][2]
      local a = n % 45
      local b = ((n - a) / 45) % 45
      local c = ((n - (a+b*45)) / (45*45)) % 45
      b45str = b45str .. alphabet[a+1] .. alphabet[b+1] .. alphabet[c+1]
   end

   if odd == 1 then
      local n = bytes_array[#bytes_array][1]
      local a = n % 45
      local b = (n - a) / 45
      b45str = b45str .. alphabet[a+1] .. alphabet[b+1]
   end

   return b45str
end


function m.encode (str)
   local ret, res = pcall(_encode_base45, str)
   if not ret then return false, res end
   return res
end





local function split_encoded_str (b45str)
   local bytes_array = {}
   local enc_alphabet = {}

   for k, v in ipairs(alphabet) do
      enc_alphabet[v] = k - 1
   end

   local k = 0
   local j = 0
   for i = 1, string.len(b45str) do
      j = j + 1
      if j == 1 then
         k = k + 1
         bytes_array[k] = {}
      end

      bytes_array[k][j] = enc_alphabet[string.sub(b45str, i, i)]
      
      if j >= 3 then j = 0 end
   end

   return bytes_array
end


local function b45_is_valid (b45str)
   local length = string.len(b45str)
   if length % 3 ~= 0 and length % 3 ~= 2 then
      return false
   end

   local valid_b45_char = {}
   for _, v in pairs(alphabet) do
      valid_b45_char[v] = true
   end

   for i = 1, length do
      if not valid_b45_char[string.sub(b45str, i, i)] then
         return false
      end
   end

   return true
end


local function _decode_base45 (b45str)
   local bytes_array = split_encoded_str(b45str)
   local str = ""

   if not b45_is_valid(b45str) then error("invalid base45 data (bad length or not base45)") end

   local length = string.len(b45str)
   local itt = length % 3 == 0 and length or length - (length % 3)
 
   for i = 1, itt / 3 do
      local n = bytes_array[i][1] + bytes_array[i][2] * 45 + bytes_array[i][3] * (45*45)
      local b = n % 256
      local a = (n - b) / 256
      if a > 255 then error("invalid base45 encoded data (byte out of range)") end

      str = str .. string.char(a) .. string.char(b)
   end

   if length ~= itt then
      local a = bytes_array[#bytes_array][1] + bytes_array[#bytes_array][2] * 45
      if a > 255 then error("invalid base45 encoded data (byte out of range)") end

      str = str .. string.char(a)
   end

   return str
end


function m.decode (b45str)
   local ret, res = pcall(_decode_base45, b45str)
   if not ret then return false, res end
   return res
end

return m

