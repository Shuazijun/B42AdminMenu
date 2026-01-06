local dataContent = require("CheatMenuPhoenix/Teleport/maplocations_raw")
if type(dataContent) == "string" then
	local func = loadstring("return " .. dataContent)
	if func then
		return func()
	end
end
return dataContent
