
local b45 = require("base45")

local str = "Hello friend!"
print(b45.encode(str))

local b45str = "0B9GPCT-DSUE QE/3EK4444EZEDU1D$FFR2"
print(b45.decode(b45str))

