local success, mapData = pcall(require, "B42AdminMenu/Teleport/maplocations")
if success and mapData then
	return mapData
end
return nil
