require "B42AdminMenu/Teleport/compassMain"
require "B42AdminMenu/CheatCore"

---@class compassCore
---@field categories table
---@field Wmod number
---@field Hmod number
---@field mainWindow any
---@field debug any
---@field locations table
---@field mapTbl any
compassCore = {}
compassCore.categories = {}
compassCore.Wmod = 0.70
compassCore.Hmod = 1

function compassCore.makeWindow()
	if compassCore.locations == nil then
		compassCore.processJson()
	end
	if compassCore.mainWindow == nil then
		local sw = getCore():getScreenWidth()
		local sh = getCore():getScreenHeight()
		local w = (sw / 3.8) * compassCore.Wmod <= sw and (sw / 3.8) * compassCore.Wmod or sw
		local h = (sh / 1.3) * compassCore.Hmod <= sh and (sh / 1.3) * compassCore.Hmod or sh
		local window = compassUI:new(50,50, w,h)
		window:setVisible(true)
		window:addToUIManager()
		local mt = getmetatable(compassCore.debug)
		compassCore.mainWindow = window
		setmetatable(compassCore.mainWindow, mt)
	else
		compassCore.mainWindow:setVisible(true)
	end
end

function compassCore.removeWindow()
	local window = compassCore.mainWindow
	window:setVisible(false)
	window:removeFromUIManager()
end

---@param num number
---@param percentage number
---@param subt boolean|nil
---@return number
function compassCore.scale(num,percentage, subt)
	if subt then
		return num - (num * percentage)
	else
		return num + (num * percentage)
	end
end

function compassCore.processJson(update)
	compassCore.locations = {}

	local success, mapData = pcall(require, "B42AdminMenu/Teleport/maplocations_raw")

	if not success or not mapData then
		print("ERROR -> Could not load maplocations_raw")
		return
	end

	compassCore.mapTbl = mapData
	local a = compassCore.mapTbl

	local inc = 0

	---@diagnostic disable-next-line: need-check-nil
	for i = 1,#a["areas"] do
		inc = inc+1
		---@diagnostic disable-next-line: need-check-nil
		local t = a["areas"][i]
		---@diagnostic disable-next-line: undefined-field
		compassCore.locations[t["name"]] = t
		---@diagnostic disable-next-line: undefined-field
		compassCore.locations[t["name"]]["pois"] = t["pois"]
	end

	setmetatable(compassCore.locations, { ["__index"] = {["size"] = inc + 1} })

	local success2, customData = pcall(require, "B42AdminMenu/Teleport/customlocations_raw")
	compassCore.locations["Custom"] = {}
	if success2 and customData then
		compassCore.locations["Custom"]["pois"] = customData
	else
		compassCore.locations["Custom"]["pois"] = {}
	end
end

function compassCore:updateCustom()
	local proxy = {}
	local locations = self.locations["Custom"]["pois"]

	for i = 1,#locations do
		local str = "{"
		for k,v in pairs(locations[i]) do
			str = str .. "['" .. k .. "'] = "  .. (type(v) == "string" and "'" .. v  .. "'" or v) .. ";"
		end
		str = str .. ( i == #locations and "}" or "}, ")
		table.insert(proxy, str)
	end
	local str = "{"
	for i = 1,#proxy do
		str = str .. proxy[i]
	end
	str = str .. "}"
	CheatCoreCM.writeFile({str}, "CheatMenuPX", "teleport_locations/customlocations.txt")
	--compassCore.sort()
end

function compassCore:addCustom()
	local custom = {["name"] = "Custom Location"; ["x"] = getPlayer():getX(); ["y"] = getPlayer():getY(); ["z"] = getPlayer():getZ()}
	table.insert(self.locations["Custom"]["pois"] --[[@as table]], custom)
	self:updateCustom()
end

--[[
Could not solve the sort algorithm, will figure out later.
function compassCore.sort()
	for k,v in pairs(compassCore.locations) do
		--print (k)
		for a,b in pairs(v) do
			--print (a, b)
			if tostring(a) == "pois" then
				for c,d in pairs (b) do
				--print (k, a, c)
					table.sort(compassCore.locations[k][a][c])

					for e, f in pairs (d) do
						print (e, f)
					end
				end
			end
		end
	end
end
--]]

--compassCore.processJson() //IS BREAKING NEEDS FIXING

--Events.OnLoad.Add(compassCore.makeWindow)