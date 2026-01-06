-- Removes original DoTickCheats registration just in case
Events.OnGameBoot.Add(function()
	if Events.OnPlayerUpdate.Remove then
		Events.OnPlayerUpdate.Remove(CheatCoreCM.DoTickCheats)
	end
end)
