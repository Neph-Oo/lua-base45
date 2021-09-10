
# Lua-base45 

Lua base45 encoder/decoder for lua5.1+ and luajit, based on draft-faltstrom-base45 from IETF.  
 
More: https://datatracker.ietf.org/doc/draft-faltstrom-base45/  


## Install 

Via LuaRocks :

`luarocks install base45`  

Or just copy base45.lua in your project directory tree.


## Usage 

Example:
```lua
local b45 = require("base45")

local str = "Hello World!"
print(b45.encode(str))

local b45str = "0B9GPCT-DSUE QE/3EK4444EZEDU1D$FFR2"
print(b45.decode(b45str))
```

