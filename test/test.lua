local b45 = require("base45")

local function b45_test (data, b45data)
   print("Testing: \"" .. data .. "\" == \"" .. b45data .. "\"")
   assert(b45.encode(data) == b45data)
   assert(b45.decode(b45data) == data)
   assert(b45.encode(b45.decode(b45data)) == b45data)
   assert(b45.decode(b45.encode(data)) == data)
   assert(b45.encode(b45.decode(b45data)) == b45.encode(data))
   assert(b45.decode(b45.encode(data)) == b45.decode(b45data))
end

local test_arr = {
   {
      data = "base-45",
      enc_data = "UJCLQE7W581"
   },
   {
      data = "ietf!",
      enc_data = "QED8WEX0"
   },
   {
      data = "AB",
      enc_data = "BB8"
   },
   {
      data = "Hello!!",
      enc_data = "%69 VD92EX0"
   }
}

for _, v in pairs(test_arr) do
   b45_test(v.data, v.enc_data)
end

print("Success!")


