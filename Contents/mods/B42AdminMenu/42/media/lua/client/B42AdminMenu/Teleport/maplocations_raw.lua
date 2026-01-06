local success, mapData = pcall(require, "CheatMenuPhoenix/Teleport/maplocations")
if success and mapData then
	return mapData
end
return nil
