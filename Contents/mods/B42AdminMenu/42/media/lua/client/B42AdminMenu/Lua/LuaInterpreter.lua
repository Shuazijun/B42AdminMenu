---@diagnostic disable: undefined-field

---@class ConfirmBox : ISRichTextPanel
---@field noButton ISButton
---@field yesButton ISButton

---@class ISUILuaWindow : ISCollapsableWindow
---@field LuaBar ISTextEntryBox
---@field pathBar ISTextEntryBox
---@field pathBox ISRichTextPanel
---@field goButton ISButton
---@field closeButton ISButton
---@field confirmBox ConfirmBox
---@field runButton ISButton
---@field exportButton ISButton
---@field importButton ISButton
---@field mode string?

ISUILuaWindow = ISCollapsableWindow:derive("ISUILuaWindow");

function ISUILuaWindow:initialise()
	ISCollapsableWindow:initialise();

	---@diagnostic disable-next-line: inject-field
	self.LuaBar = ISTextEntryBox:new("", 0, self:titleBarHeight(), self:getWidth() / 1.15, self:getHeight() + 1);
	self.LuaBar:initialise();
	self.LuaBar:instantiate();
	self.LuaBar:setMultipleLine(true)
	self.LuaBar.javaObject:setMaxLines(99999);
	self:addChild(self.LuaBar);

	local btnX = math.floor(self:getWidth() - (self:getWidth() - self.LuaBar:getWidth()))
	local btnWidth = math.floor(self:getWidth() - self.LuaBar:getWidth())
	local btnHeight = math.floor(self.LuaBar:getHeight() / 3)

	---@diagnostic disable-next-line: inject-field
	self.pathBar = ISTextEntryBox:new(getText("UI_CMRB_Lua_Filename"), 0, self.LuaBar:getHeight() + self:titleBarHeight(), self.LuaBar:getWidth(), self.LuaBar:getHeight() / 10);
	self.pathBar:initialise();
	self.pathBar:instantiate();
	self.pathBar:setMultipleLine(false)
	self.pathBar.javaObject:setMaxLines(1);
	self.pathBar.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	self.pathBar:setVisible(false);
	self:addChild(self.pathBar);

	local mod = getModInfoByID("B42AdminMenu")
	local destPath = ""
	if mod then
		destPath = mod:getDir().."\\user_lua\\"
	end

	---@diagnostic disable-next-line: inject-field
	self.pathBox = ISRichTextPanel:new(0, self.LuaBar:getHeight() + self.pathBar:getHeight() + self:titleBarHeight(), self.LuaBar:getWidth(), ((getCore():getScreenHeight() / 2.8) - 15) - (self.LuaBar:getHeight() + self.pathBar:getHeight()));
	self.pathBox.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	self.pathBox.marginTop = 4;
	self.pathBox.text = getText("UI_CMRB_Lua_ScrollDown") .. destPath
	self.pathBox:initialise();
	self.pathBox.autosetheight = false;
	self.pathBox:paginate();
	self.pathBox:setVisible(false);
	self:addChild(self.pathBox);

	---@diagnostic disable-next-line: inject-field
	self.goButton = ISButton:new(btnX, self.pathBar:getY(), btnWidth, self.pathBar:getHeight(), "Go", self, function() ISUILuaWindow.portLua() end);
	self.goButton:initialise();
	self.goButton:instantiate();
	self.goButton.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	self.goButton:setVisible(false);
	self:addChild(self.goButton);

	---@diagnostic disable-next-line: inject-field
	self.closeButton = ISButton:new(btnX, self.pathBox:getY(), btnWidth, self.pathBox:getHeight(), "Close", self, ISUILuaWindow.togglePathBar);
	self.closeButton:initialise();
	self.closeButton:instantiate();
	self.closeButton.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	self.closeButton:setVisible(false);
	self:addChild(self.closeButton);

	---@diagnostic disable-next-line: assign-type-mismatch, inject-field
	self.confirmBox = ISRichTextPanel:new(self.LuaBar:getWidth() / 6,self.LuaBar:getHeight() / 2.5,self.LuaBar:getWidth() / 1.5,self.LuaBar:getHeight() / 3);
	self.confirmBox.backgroundColor = {r=0, g=0, b=0, a=0.8};
	self.confirmBox.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
	self.confirmBox.text = getText("UI_CMRB_Lua_FileExists");

	self.confirmBox.noButton = ISButton:new(self.confirmBox:getWidth() / 16, self.confirmBox:getHeight() / 2.5, self.confirmBox:getWidth() / 2.5, self.confirmBox:getHeight() / 2, "NO", self, function() ISUILuaWindow.confirmBox:setVisible(false) end);
	self.confirmBox.noButton.borderColor = {r=0.4, g=0.4, b=0.4, a=0.6};
	self.confirmBox.yesButton = ISButton:new(self.confirmBox:getWidth() / 1.88, self.confirmBox:getHeight() / 2.5, self.confirmBox:getWidth() / 2.5, self.confirmBox:getHeight() / 2, "YES", self, function() ISUILuaWindow.portLua(nil,false,true); ISUILuaWindow.confirmBox:setVisible(false) end);
	self.confirmBox.yesButton.borderColor = {r=0.4, g=0.4, b=0.4, a=0.6};
	self.confirmBox:addChild(self.confirmBox.yesButton);
	self.confirmBox:addChild(self.confirmBox.noButton);

	self.confirmBox:initialise();
	self.confirmBox.autosetheight = false;
	self.confirmBox:paginate();
	self.confirmBox:setVisible(false);
	self:addChild(self.confirmBox);

	---@diagnostic disable-next-line: inject-field
	self.runButton = ISButton:new(btnX, self:titleBarHeight(), btnWidth, btnHeight, getText("UI_CMRB_Lua_Run"), self, ISUILuaWindow.runLua);
	self.runButton:initialise();
	self.runButton:instantiate();
	self.runButton.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	self:addChild(self.runButton);

	---@diagnostic disable-next-line: inject-field
	self.exportButton = ISButton:new(btnX, self.runButton:getHeight() + self:titleBarHeight(), btnWidth, btnHeight, getText("UI_CMRB_Lua_Export"), self, function() ISUILuaWindow.portLua("export", true) end);
	self.exportButton:initialise();
	self.exportButton:instantiate();
	self.exportButton.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	self:addChild(self.exportButton);

	---@diagnostic disable-next-line: inject-field
	self.importButton = ISButton:new(btnX, (self.runButton:getHeight() * 2) + self:titleBarHeight(), btnWidth, btnHeight, getText("UI_CMRB_Lua_Import"), self, function() ISUILuaWindow.portLua("import", true) end);
	self.importButton:initialise();
	self.importButton:instantiate();
	self.importButton.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	self:addChild(self.importButton);
end

---@diagnostic disable-next-line: inject-field
function ISUILuaWindow.togglePathBar()
	if ISUILuaWindow.pathBar:getIsVisible() ~= true then
		ISUILuaWindow:setHeight(getCore():getScreenHeight() / 2.8)
		ISUILuaWindow.pathBar:setVisible(true)
		ISUILuaWindow.goButton:setVisible(true)
		ISUILuaWindow.pathBox:setVisible(true)
		ISUILuaWindow.closeButton:setVisible(true)
	else
		ISUILuaWindow:setHeight((getCore():getScreenHeight() / 3.5) + ISUILuaWindow:titleBarHeight())
		ISUILuaWindow.pathBar:setVisible(false)
		ISUILuaWindow.goButton:setVisible(false)
		ISUILuaWindow.pathBox:setVisible(false)
		ISUILuaWindow.closeButton:setVisible(false)
	end
end

---@diagnostic disable-next-line: inject-field
function ISUILuaWindow.portLua(mode, noStart, doNotCheck)
	if ISUILuaWindow.pathBar:getIsVisible() ~= true then
		ISUILuaWindow.togglePathBar()
	end

	if type(mode) == "string" then
		ISUILuaWindow["mode"] = mode
	end

	if noStart ~= true then
		local mod = getModInfoByID("B42AdminMenu")
		if not mod then
			print("[ADMIN MENU] Error -> Mod not found!")
			return false
		end
		local destPath = mod:getDir().."\\user_lua\\"..ISUILuaWindow.pathBar:getText() -- for the user to look at
		local destPath2 = "user_lua/" .. string.gsub(ISUILuaWindow.pathBar:getText(), ".lua", "") .. ".lua" -- for the game-relative path

		if ISUILuaWindow.mode == "export" then -- commence export actions
			local strTable = {}

			for i in string.gmatch(ISUILuaWindow.LuaBar:getText(),"[\n]*.+") do -- put each line of the lua bar's content into a separate table entry, so I can write them to a file later
			   strTable[#strTable+1] = i
			end
			if doNotCheck ~= true then
				if fileExists(destPath) then
					print("[ADMIN MENU] FILE "..destPath.." ALREADY EXISTS! Prompting user to overwrite.")
					ISUILuaWindow.confirmBox:setVisible(true)
					return false
				end
			end
			CheatCoreCM.writeFile(strTable, "CheatMenuPX", destPath2)
			print("[ADMIN MENU] File successfully written!")
		elseif ISUILuaWindow.mode == "import" then -- otherwise, commence import actions
			if fileExists(destPath) then -- check if the file exists first, to prevent errors and to prevent readFile from creating a new file
				local fileT = CheatCoreCM.readFile("CheatMenuPX", destPath2) -- CheatCoreCM.readFile returns table of file, line by line.
				ISUILuaWindow.LuaBar:clear() -- clear the lua interpreter first
				for i = 1,#fileT do
					ISUILuaWindow.LuaBar:setText(ISUILuaWindow.LuaBar:getText()..fileT[i].."\n")
				end
				print("[ADMIN MENU] File successfully imported!") -- inform user in console if successful
			else
				print("[ADMIN MENU] Error -> file does not exist!") -- or if unsuccessful.
			end
		end
	end
end

---@param x number
---@param y number
---@param width number
---@param height number
---@return ISUILuaWindow
function ISUILuaWindow:new(x, y, width, height)
	local o = {};
	o = ISCollapsableWindow:new(x, y, width, height);
	setmetatable(o, self);
	---@diagnostic disable-next-line: inject-field
	self.__index = self;
	o.title = getText("UI_CMRB_Lua_Interpreter");
	o.pin = true;
	o.resizable = false
	o:noBackground();
	o.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	---@type ISUILuaWindow
	return o;
end

---@diagnostic disable-next-line: inject-field
function ISUILuaWindow.runLua()
	local func = loadstring(ISUILuaWindow.LuaBar:getText())
	if func then
		func()
	end
end

---@diagnostic disable-next-line: inject-field
function ISUILuaWindow.SetupBar()
	---@diagnostic disable-next-line: undefined-field, param-type-mismatch
	ISUILuaWindow:setVisible(true)
	ISUILuaWindow.LuaBar:setEditable(true)
	ISUILuaWindow.LuaBar.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
end

function LuaWindowCreate()
	local x = math.floor(getCore():getScreenWidth() / 3)
	local y = math.floor(getCore():getScreenHeight() / 2)
	local w = math.floor(getCore():getScreenWidth() / 3)
	local h = math.floor(getCore():getScreenHeight() / 3.5)
	---@diagnostic disable-next-line: redundant-parameter
	ISUILuaWindow = ISUILuaWindow:new(x, y, w, h)
	ISUILuaWindow:initialise();
	ISUILuaWindow:addToUIManager();
	ISUILuaWindow:setVisible(false);
	ISUILuaWindow:setHeight(ISUILuaWindow:getHeight() + ISUILuaWindow:titleBarHeight())
end

Events.OnGameStart.Add(LuaWindowCreate);
