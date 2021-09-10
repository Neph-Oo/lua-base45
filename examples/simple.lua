local b45 = require("base45")

local str = "We <3 free software"
local b45_str = b45.encode(str)

print("Encoding string: \"" .. str .. "\"\nto base45: \"" .. b45_str .. "\"")
print("---")
print("Decoding base45: \"" .. b45_str .. "\"\nto string \"" .. b45.decode(b45_str) .. "\"")


