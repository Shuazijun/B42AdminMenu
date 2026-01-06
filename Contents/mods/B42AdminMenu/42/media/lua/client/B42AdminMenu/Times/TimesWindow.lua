---@class TimesWindow : ISCollapsableWindow
---@field IDs string|nil
---@field YearInput ISTextEntryBox
---@field MonthInput ISTextEntryBox
---@field DayInput ISTextEntryBox
---@field HourInput ISTextEntryBox
---@field MinuteInput ISTextEntryBox
---@field InpButton ISButton
---@field titleBarFont UIFont
TimesWindow = ISCollapsableWindow:derive("TimesWindow")

---@class TimeBox : ISPanel
---@field target TimesWindow
---@field func fun()|nil
---@field hscroll any
TimeBox = ISPanel:derive("TimeBox")

TimesWindow.IDs = nil

function CheckNumeric(value)
	if value == tostring(tonumber(value)) then
		if tostring(tonumber(value)) == "." then
			return false
		else
			return true
		end
	elseif value == "" then
		return true
	else
		return false
	end
end

function TimesWindow:initialise()
	ISCollapsableWindow.initialise(self);
	self:makeChildren()
end

function TimesWindow:SetTime()
	local time = getGameTime()
	local CM_timeYear = time:getYear()
	local CM_timeMonth = time:getMonth()
	local CM_timeDay = time:getDay()
	local CM_timeHour = time:getHour()
	local CM_timeMinute = time:getTimeOfDay()-time:getHour()

	--print (time:getHour())
	--print (time:getTimeOfDay())
	--print (CM_timeMinute)

	local Lastday_M = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

	local Y
	if self.YearInput:getText() == "" then
		---@type number|nil
		Y = tonumber(CM_timeYear)
	elseif CheckNumeric(self.YearInput:getText()) == false then
		---@type number|nil
		Y = nil
	else
		---@diagnostic disable-next-line: param-type-mismatch
		Y = math.floor(tonumber(self.YearInput:getText()))
	end

	local M
	if self.MonthInput:getText() == "" then
		---@diagnostic disable-next-line: need-check-nil
		M = tonumber(CM_timeMonth) + 1
	elseif CheckNumeric(self.MonthInput:getText()) == false then
		M = nil
	else
		---@diagnostic disable-next-line: param-type-mismatch
		M = math.floor(tonumber(self.MonthInput:getText()))
	end

	local D
	if self.DayInput:getText() == "" then
		---@diagnostic disable-next-line: need-check-nil
		D = tonumber(CM_timeDay) +1
	elseif CheckNumeric(self.DayInput:getText()) == false then
		D = nil
	else
		---@diagnostic disable-next-line: param-type-mismatch
		D = math.floor(tonumber(self.DayInput:getText()))
	end

	local H
	if self.HourInput:getText() == "" then
		---@type number|nil
		H = tonumber(CM_timeHour)
	elseif CheckNumeric(self.HourInput:getText()) == false then
		---@type number|nil
		H = nil
	else
		---@diagnostic disable-next-line: param-type-mismatch
		H = math.floor(tonumber(self.HourInput:getText()))
	end

	local MM
	if self.MinuteInput:getText() == "" then
		---@diagnostic disable-next-line: need-check-nil
		MM = tonumber(CM_timeMinute)
		-- having a issue that input window could not recognize 0 with first value (e.g. 02, 05)
	elseif CheckNumeric(self.MinuteInput:getText()) == false then
		MM = nil
	else
		---@diagnostic disable-next-line: need-check-nil
		MM = tonumber(self.MinuteInput:getText()) / 60
	end

	if Y ~= nil and M ~= nil and D ~= nil and H ~= nil and MM ~= nil then
		if (Y % 4 == 0) then
			if (Y % 100 == 0) then
				if (Y % 400 == 0) then
					Lastday_M[2] = 29
					--print ("leapyear - D")
				else
					Lastday_M[2] = 28
					--print ("Not leapyear - C")
				end
			else
				Lastday_M[2] = 29
				--print ("leapyear - B")
			end
		else
			Lastday_M[2] = 28
			--print ("Not leapyear - A")
		end

		if Y < 1993 then
			if Y <= 0 then
				getPlayer():Say(getText("UI_CMRB_Message_TimeCannotChange"))
			else
				getPlayer():Say(getText("UI_CMRB_Message_TimeCannotUndo"))
				--print ("Year is less than 1993")
			end
		elseif Y <= 1993 and M < 7 then
			getPlayer():Say(getText("UI_CMRB_Message_TimeCannotUndo"))
			--print ("Year is 1993 but month is less than 7")
		elseif Y <=  1993 and M <= 7 and D < 9 then
			getPlayer():Say(getText("UI_CMRB_Message_TimeCannotUndo"))
			--print ("Year is 1993 and month is 7 but day is less than 7")
		else

			if M <= 0 or M > 12 then
				getPlayer():Say(getText("UI_CMRB_Message_TimeCannotChange"))
			elseif D <= 0 or D > 31 then
				getPlayer():Say(getText("UI_CMRB_Message_TimeCannotChange"))
			elseif H <= 0 or H > 24 then
				getPlayer():Say(getText("UI_CMRB_Message_TimeCannotChange"))
			elseif MM < 0 or MM > 1 then
				getPlayer():Say(getText("UI_CMRB_Message_TimeCannotChange"))
			else
				if D > Lastday_M[M] then
					getPlayer():Say(getText("UI_CMRB_Message_DateInvalid"))
					--print ("Input date is invalid, correct valid one")
					D = Lastday_M[M]
				end
				--print (M)
				time:setYear(math.floor(Y))
				time:setMonth(math.floor(M-1))
				---@diagnostic disable-next-line: need-check-nil
				time:setDay(math.floor(D-1))
				local P = H + MM
				time:setTimeOfDay(P)
				---@type string|integer
				local PrintMinute = math.floor(MM * 60)

				if PrintMinute == 0 then
				PrintMinute = "00"
				end
				if PrintMinute == 1 then
				PrintMinute = "01"
				end
				if PrintMinute == 2 then
				PrintMinute = "02"
				end
				if PrintMinute == 3 then
				PrintMinute = "03"
				end
				if PrintMinute == 4 then
				PrintMinute = "04"
				end
				if PrintMinute == 5 then
				PrintMinute = "05"
				end
				if PrintMinute == 6 then
				PrintMinute = "06"
				end
				if PrintMinute == 7 then
				PrintMinute = "07"
				end
				if PrintMinute == 8 then
				PrintMinute = "08"
				end
				if PrintMinute == 9 then
				PrintMinute = "09"
				end

				getPlayer():Say(getText("UI_CMRB_Message_TimeChange_1") .. Y .. "/" .. M .. "/" .. D .. " , " .. H .. getText("UI_CMRB_Message_TimeChange_2") .. PrintMinute .. " .")
			end
		end
		else
		getPlayer():Say(getText("UI_CMRB_Message_TimeCannotChange"))
	end

   --print (Y, M, D, H)
   --print (CM_timeYear, CM_timeMonth, CM_timeDay)
end

function TimesWindow:makeChildren()

	self.YearInput = ISTextEntryBox:new("", 0, self:titleBarHeight()+20, self:getWidth() / 5, self:getHeight() / 5);
	self.YearInput:initialise();
	self.YearInput:instantiate();
	self.YearInput:setMultipleLine(false)
	self.YearInput.javaObject:setMaxLines(1);
	self:addChild(self.YearInput); -- to center, set border pixel and multiply by border pixel / 2

	self.MonthInput = ISTextEntryBox:new("", self:getWidth() / 5, self:titleBarHeight()+20, self:getWidth() / 5, self:getHeight() / 5);
	self.MonthInput:initialise();
	self.MonthInput:instantiate();
	self.MonthInput:setMultipleLine(false)
	self.MonthInput.javaObject:setMaxLines(1);
	self:addChild(self.MonthInput); -- to center, set border pixel and multiply by border pixel / 2

	self.DayInput = ISTextEntryBox:new("", (self:getWidth() / 5) * 2, self:titleBarHeight()+20, self:getWidth() / 5, self:getHeight() / 5);
	self.DayInput:initialise();
	self.DayInput:instantiate();
	self.DayInput:setMultipleLine(false)
	self.DayInput.javaObject:setMaxLines(1);
	self:addChild(self.DayInput); -- to center, set border pixel and multiply by border pixel / 2

	self.HourInput = ISTextEntryBox:new("", (self:getWidth() / 5) * 3, self:titleBarHeight()+20, self:getWidth() / 5, self:getHeight() / 5);
	self.HourInput:initialise();
	self.HourInput:instantiate();
	self.HourInput:setMultipleLine(false)
	self.HourInput.javaObject:setMaxLines(1);
	self:addChild(self.HourInput); -- to center, set border pixel and multiply by border pixel / 2

	self.MinuteInput = ISTextEntryBox:new("", (self:getWidth() / 5) * 4, self:titleBarHeight()+20, self:getWidth() / 5, self:getHeight() / 5);
	self.MinuteInput:initialise();
	self.MinuteInput:instantiate();
	self.MinuteInput:setMultipleLine(false)
	self.MinuteInput.javaObject:setMaxLines(1);
	self:addChild(self.MinuteInput); -- to center, set border pixel and multiply by border pixel / 2

	self.InpButton = ISButton:new(0, self.YearInput:getHeight() + self:titleBarHeight()+20, self:getWidth(), self:getHeight() / 2, getText("UI_CMRB_Window_Set"), self, self.SetTime); 
	self.InpButton:initialise();
	self.InpButton:instantiate();
	self.InpButton.borderColor = {r=0.4, g=0.4, b=0.4, a=1.0};
	self:addChild(self.InpButton);

	--self:setHeight(self:getHeight() - (self:titleBarHeight() / 2)) 
end

function TimesWindow:prerender()
	local height = self:getHeight();
	local th = self:titleBarHeight()
	if self.isCollapsed then
		height = th;
	end
	if self.drawFrame then
		self:drawRect(0, 0, self:getWidth(), th, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
		self:drawTextureScaled(self.titlebarbkg, 2, 1, self:getWidth() - 4, th - 2, 1, 1, 1, 1);
		self:drawRectBorder(0, 0, self:getWidth(), th, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	end
	if self.background and not self.isCollapsed then
		local rh = self:resizeWidgetHeight()
		if not self.resizable or not self.resizeWidget:getIsVisible() then rh = 0 end
		self:drawRect(0, th, self:getWidth(), self.height - th - rh, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
	end

	if self.clearStentil then
		self:setStencilRect(0,0,self.width, height);
	end

	if self.title ~= nil and self.drawFrame then
		self:drawTextCentre(self.title, self:getWidth() / 2, 1, 1, 1, 1, 1, self.titleBarFont);
	end
		self:drawTextCentre(getText("UI_CMRB_TimeWindow_Years"), (self.YearInput.x + self.MonthInput.x) / 2, self:titleBarHeight()+2, 1, 1, 1, 1, UIFont.Small)
		self:drawTextCentre(getText("UI_CMRB_TimeWindow_Months"), (self.MonthInput.x + self.DayInput.x) / 2, self:titleBarHeight()+2, 1, 1, 1, 1, UIFont.Small)
		self:drawTextCentre(getText("UI_CMRB_TimeWindow_Days"), (self.DayInput.x + self.HourInput.x) / 2, self:titleBarHeight()+2, 1, 1, 1, 1, UIFont.Small)
		self:drawTextCentre(getText("UI_CMRB_TimeWindow_Hours"), (self.HourInput.x + self.MinuteInput.x) / 2, self:titleBarHeight()+2, 1, 1, 1, 1, UIFont.Small)
		self:drawTextCentre(getText("UI_CMRB_TimeWindow_Minutes"), (self.MinuteInput.x + self:getWidth()) / 2, self:titleBarHeight()+2, 1, 1, 1, 1, UIFont.Small)
end

function TimesWindow:destroy() -- pre-defined
	self:setVisible(false)
	self:removeFromUIManager()
	TimesWindow.IDs = nil
end

function TimesWindow:close() -- Works here
	self:setVisible(false)
	self:removeFromUIManager()
	TimesWindow.IDs = nil
end

---@param x number
---@param y number
---@param width number
---@param height number
---@return TimesWindow
function TimesWindow:new(x, y, width, height)
	local o = {}
	o = ISCollapsableWindow:new(x, y, width, height)
	setmetatable(o, self)
	self.__index = self
	---@type TimesWindow
	o = o ---@diagnostic disable-line: assign-type-mismatch
	o.title = getText("UI_CMRB_Utility_TimeWarpWindow")
	o.resizable = false
	o.pin = true;
	o.isCollapsed = false;
	o.x = x
	o.y = y
	o.width = width
	o.height = height
	TimesWindow.IDs = "TimeMachine"
	--o:noBackground();
	--o.clearStentil = false
	--o.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	return o;
end

function TimesWindow.makeWindow()
	local window = TimesWindow:new(100,100,370,100)
	-- Change the window's width, height << later job.
	window:initialise()
	window:addToUIManager()
end

function TimeBox:initialise()
	ISPanel.initialise(self);
	self:createChildren()
end

function TimeBox:createChildren()
	self:addScrollBars(true)
	self:setScrollWidth(1000)
	self.hscroll:setWidth(self.width - 1)
	--self.hscroll:setHeight(self.height)
	self.hscroll:setAlwaysOnTop(true)
	---@diagnostic disable-next-line: inject-field
	self.hscroll.target, self.hscroll.func = self.target, self.func

	function self.hscroll:onMouseMove(dx, dy)
		---@type ISScrollBar
		self = self
		if self.scrolling then
			local sw = self.parent:getScrollWidth()
			if sw > self.parent:getScrollAreaWidth() then
				local del = self:getWidth() / sw
				local boxheight = del * (self:getWidth()- (20 * 2))
				local dif = self:getWidth() - (20 * 2) - boxheight
				self.pos = self.pos + (dx / dif)
				if self.pos < 0 then
					self.pos = 0
				end
				if self.pos > 1 then
					self.pos = 1
				end
				self.parent:setXScroll(-(self.pos * (sw - self.parent:getScrollAreaWidth())))
			end
			---@diagnostic disable-next-line: undefined-field
			if self.func then
				---@diagnostic disable-next-line: undefined-field
				pcall(self.func)
			end
		end
	end
end

---@param x number
---@param y number
---@param width number
---@param height number
---@param target TimesWindow
---@param func fun()|nil
---@return TimeBox
function TimeBox:new(x, y, width, height, target, func)
	local o = {};
	o = ISPanel:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
	---@type TimeBox
	o = o ---@diagnostic disable-line: assign-type-mismatch
	o.x = x
	o.y = y
	o.width = width
	o.height = height
	o.target = target
	o.func = func
	--o:noBackground();
	--o.clearStentil = false
	--o.borderColor = {r=0.4, g=0.4, b=0.4, a=0.4};
	return o;
end
