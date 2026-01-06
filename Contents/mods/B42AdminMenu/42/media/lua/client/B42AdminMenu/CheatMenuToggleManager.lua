Events.OnPlayerUpdate.Add(function(player)
	if not player or not instanceof(player, "IsoPlayer") then return end
	if player:isDead() then return end

	local data = player:getModData()
	if not data then return end

	local body = player:getBodyDamage()
	local stats = player:getStats()

	if data.IsGod and body and stats then
		body:RestoreToFullHealth()
		stats:reset(CharacterStat.FATIGUE)
		stats:reset(CharacterStat.HUNGER)
		stats:reset(CharacterStat.THIRST)
		stats:reset(CharacterStat.ENDURANCE)
		-- print("[Cheat Health] God Mode active -> Player fully healed.")
	end

	if data.IsImmortal and body then
		local health = body:getHealth()
		if health > 0 and health < 0.9 then
			player:setHealth(1.0)
			print("[Cheat Health] Prevent Death override -> Restored to full before danger.")
		end
	end
end)

function ToggleGodMode()
	local pdata = getPlayer():getModData()
	pdata.IsGod = not pdata.IsGod
	print("[CheatMenu] God Mode toggled -> " .. tostring(pdata.IsGod))
end

function TogglePreventDeath()
	local pdata = getPlayer():getModData()
	pdata.IsImmortal = not pdata.IsImmortal
	print("[CheatMenu] Prevent Death toggled -> " .. tostring(pdata.IsImmortal))
end