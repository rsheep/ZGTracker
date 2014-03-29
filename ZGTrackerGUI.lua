ZGT_UI = {
	LOCK = false,
	SCALE = 1,
	WIDTH = 130,
	HEIGHT = 27,
	BGALPHA = .71,
	BG_TEXTURE_FILE = "Interface\\ChatFrame\\ChatFrameBackground",
	FONT_FILE = "Fonts\\ARIALN.TTF",
}

local ZGT_UI_DEBUG = false

local function ZGT_D(text)
	local header = "|cffCC5555[ZGT] "
	if ZGT_UI_DEBUG then
		DEFAULT_CHAT_FRAME:AddMessage(header .. "|cffffffff" .. text)
	end
end

local GUI_Frame = nil

local function GUI_About(parent)
	local ZGT_TITLE = GetAddOnMetadata("ZGTracker", "Title")
	local ZGT_VERSION = GetAddOnMetadata("ZGTracker", "Version")
	local ZGT_AUTHOR = GetAddOnMetadata("ZGTracker", "Author")
	local ZGT_WEBSITE = GetAddOnMetadata("ZGTracker", "X-Website")

	local frame = CreateFrame("Frame", "ZGT_GUI_About", parent)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("MEDIUM")
	frame:SetScale(ZGT_UI.SCALE)
	frame:SetWidth(155)
	frame:SetHeight(230)
	frame:SetPoint("TOPRIGHT", parent, "TOPLEFT", -3, 0)

	frame:SetBackdrop( {
		bgFile = ZGT_UI.BG_TEXTURE_FILE
	});
	frame:SetBackdropColor(.01, .01, .01, ZGT_UI.BGALPHA)

	local fs_title = frame:CreateFontString(nil, "ARTWORK")
	fs_title:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
	fs_title:SetFont(ZGT_UI.FONT_FILE, 10)
	fs_title:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_title:SetText(ZGT_TITLE)

	frame.fs_title = fs_title

	local frame_about = CreateFrame("Frame", nil, frame)
	frame_about:SetWidth(145)
	frame_about:SetHeight(38)
	frame_about:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -18)
	frame_about:SetBackdrop( {
		bgFile = ZGT_UI.BG_TEXTURE_FILE
	});
	frame_about:SetBackdropColor(.19, .19, .19, ZGT_UI.BGALPHA)

	local fs_about = frame_about:CreateFontString(nil, "ARTWORK")
	fs_about:SetPoint("TOPLEFT", frame_about, "TOPLEFT", 10, 4)
	fs_about:SetFont(ZGT_UI.FONT_FILE, 9)
	fs_about:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_about:SetText("|cff7777DDAbout|cffffffff")

	frame.fs_about = fs_about

	local fs_author = frame_about:CreateFontString(nil, "ARTWORK")
	fs_author:SetPoint("TOPLEFT", frame_about, "TOPLEFT", 3, -7)
	fs_author:SetFont(ZGT_UI.FONT_FILE, 9)
	fs_author:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_author:SetText("|cffCC5555Author:|cffffffff " .. ZGT_AUTHOR)

	frame.fs_author = fs_author

	local fs_version = frame_about:CreateFontString(nil, "ARTWORK")
	fs_version:SetPoint("TOPLEFT", frame_about, "TOPLEFT", 3, -17)
	fs_version:SetFont(ZGT_UI.FONT_FILE, 9)
	fs_version:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_version:SetText("|cffCC5555Version:|cffffffff " .. ZGT_VERSION)

	frame.fs_version = fs_version

	local fs_website = frame_about:CreateFontString(nil, "ARTWORK")
	fs_website:SetPoint("TOPLEFT", frame_about, "TOPLEFT", 3, -29)
	fs_website:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_website:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_website:SetText("|cff55CC55Website:|cffffffff " .. ZGT_WEBSITE)

	frame.fs_website = fs_website

	local frame_usage = CreateFrame("Frame", nil, frame)
	frame_usage:SetWidth(145)
	frame_usage:SetHeight(103)
	frame_usage:SetPoint("TOPLEFT", frame_about, "BOTTOMLEFT", 0, -5)
	frame_usage:SetBackdrop( {
		bgFile = ZGT_UI.BG_TEXTURE_FILE
	});
	frame_usage:SetBackdropColor(.19, .19, .19, ZGT_UI.BGALPHA)

	frame.frame_usage = frame_usage

	local fs_usage = frame_usage:CreateFontString(nil, "ARTWORK")
	fs_usage:SetPoint("TOPLEFT", frame_usage, "TOPLEFT", 10, 4)
	fs_usage:SetFont(ZGT_UI.FONT_FILE, 9)
	fs_usage:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage:SetText("|cff7777DDUsage|cffffffff")

	frame.fs_usage = fs_usage

	local t_about = CreateFrame("Button", nil, frame_usage)
	t_about:SetPoint("TOPLEFT", frame_usage, "TOPLEFT", 5, -7)
	t_about:SetWidth(11)
	t_about:SetHeight(11)
	t_about:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Normal")
	t_about:Disable()

	frame.t_about = t_about

	local fs_usage_about = frame_usage:CreateFontString(nil, "ARTWORK")
	fs_usage_about:SetPoint("LEFT", t_about, "RIGHT", 3, 0)
	fs_usage_about:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_about:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_about:SetText("Display this very window.")

	frame.fs_usage_about = fs_usage_about

	local t_close = CreateFrame("Button", nil, frame_usage)
	t_close:SetPoint("TOPLEFT", frame_usage, "TOPLEFT", 5, -21)
	t_close:SetWidth(11)
	t_close:SetHeight(11)
	t_close:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Close-Normal")
	t_close:Disable()

	frame.t_close = t_close

	local fs_usage_close = frame_usage:CreateFontString(nil, "ARTWORK")
	fs_usage_close:SetPoint("LEFT", t_close, "RIGHT", 3, -3)
	fs_usage_close:SetJustifyH("LEFT")
	fs_usage_close:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_close:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_close:SetText("Hide the ZGTracker window.\n Use '/zgt toggle' to show it again.")

	frame.fs_usage_close = fs_usage_close

	local t_detail = CreateFrame("Button", nil, frame_usage)
	t_detail:SetPoint("TOPLEFT", frame_usage, "TOPLEFT", 5, -39)
	t_detail:SetWidth(11)
	t_detail:SetHeight(11)
	t_detail:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Details-Normal")
	t_detail:Disable()

	frame.t_detail = t_detail

	local fs_usage_detail = frame_usage:CreateFontString(nil, "ARTWORK")
	fs_usage_detail:SetPoint("LEFT", t_detail, "RIGHT", 3, 0)
	fs_usage_detail:SetJustifyH("LEFT")
	fs_usage_detail:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_detail:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_detail:SetText("Show/Hide player's details.")

	frame.fs_usage_detail = fs_usage_detail

	local t_reset = CreateFrame("Button", nil, frame_usage)
	t_reset:SetPoint("TOPLEFT", frame_usage, "TOPLEFT", 5, -53)
	t_reset:SetWidth(11)
	t_reset:SetHeight(11)
	t_reset:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Flash-Normal")
	t_reset:Disable()

	frame.t_reset = t_reset

	local fs_usage_reset = frame_usage:CreateFontString(nil, "ARTWORK")
	fs_usage_reset:SetPoint("LEFT", t_reset, "RIGHT", 3, -3)
	fs_usage_reset:SetJustifyH("LEFT")
	fs_usage_reset:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_reset:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_reset:SetText("Let you reset collected data.\n Using '/zgt reset' has the same effect.")

	frame.fs_usage_reset = fs_usage_reset

	local fs_usage_announce = frame_usage:CreateFontString(nil, "ARTWORK")
	fs_usage_announce:SetPoint("TOPLEFT", frame_usage, "TOPLEFT", 3, -73)
	fs_usage_announce:SetJustifyH("LEFT")
	fs_usage_announce:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_announce:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_announce:SetText("|cffCC5555Announce|cffffffff: You can send announcements\n" ..
		" by clicking on the InfoLines.\n" ..
		"   |cff55CC55Alt+LeftClick|cffffffff: Announce using /say\n"..
		"   |cff55CC55Alt+RightClick|cffffffff: Announce to raid chat")

	frame.fs_usage_announce = fs_usage_announce

	local frame_usage_loot = CreateFrame("Frame", nil, frame)
	frame_usage_loot:SetWidth(145)
	frame_usage_loot:SetHeight(57)
	frame_usage_loot:SetPoint("TOPLEFT", frame_usage, "BOTTOMLEFT", 0, -5)
	frame_usage_loot:SetBackdrop( {
		bgFile = ZGT_UI.BG_TEXTURE_FILE
	});
	frame_usage_loot:SetBackdropColor(.19, .19, .19, ZGT_UI.BGALPHA)

	frame.frame_usage_loot = frame_usage_loot

	local fs_usage_loot = frame_usage_loot:CreateFontString(nil, "ARTWORK")
	fs_usage_loot:SetPoint("TOPLEFT", frame_usage_loot, "TOPLEFT", 10, 4)
	fs_usage_loot:SetJustifyH("LEFT")
	fs_usage_loot:SetFont(ZGT_UI.FONT_FILE, 9)
	fs_usage_loot:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_loot:SetText("|cff7777DDRoll-Automation Setting|cffffffff")

	frame.fs_usage_loot = fs_usage_loot

	local t_loot_no = CreateFrame("Button", nil, frame_usage_loot)
	t_loot_no:SetPoint("TOPLEFT", frame_usage_loot, "TOPLEFT", 5, -7)
	t_loot_no:SetWidth(11)
	t_loot_no:SetHeight(11)
	t_loot_no:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-No-Normal")
	t_loot_no:Disable()

	frame.t_loot_no = t_loot_no

	local fs_usage_loot_no = frame_usage_loot:CreateFontString(nil, "ARTWORK")
	fs_usage_loot_no:SetPoint("LEFT", t_loot_no, "RIGHT", 3, -0)
	fs_usage_loot_no:SetJustifyH("LEFT")
	fs_usage_loot_no:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_loot_no:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_loot_no:SetText("No Roll-Automation")

	frame.fs_usage_loot_no = fs_usage_loot_no

	local t_loot_need = CreateFrame("Button", nil, frame_usage_loot)
	t_loot_need:SetPoint("TOPLEFT", frame_usage_loot, "TOPLEFT", 5, -19)
	t_loot_need:SetWidth(11)
	t_loot_need:SetHeight(11)
	t_loot_need:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Need-Normal")
	t_loot_need:Disable()

	frame.t_loot_need = t_loot_need

	local fs_usage_loot_need = frame_usage_loot:CreateFontString(nil, "ARTWORK")
	fs_usage_loot_need:SetPoint("LEFT", t_loot_need, "RIGHT", 3, -0)
	fs_usage_loot_need:SetJustifyH("LEFT")
	fs_usage_loot_need:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_loot_need:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_loot_need:SetText("AutoRoll Need for Bijous/Coins")

	frame.fs_usage_loot_need = fs_usage_loot_need

	local t_loot_greed = CreateFrame("Button", nil, frame_usage_loot)
	t_loot_greed:SetPoint("TOPLEFT", frame_usage_loot, "TOPLEFT", 5, -31)
	t_loot_greed:SetWidth(11)
	t_loot_greed:SetHeight(11)
	t_loot_greed:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Greed-Normal")
	t_loot_greed:Disable()

	frame.t_loot_greed = t_loot_greed

	local fs_usage_loot_greed = frame_usage_loot:CreateFontString(nil, "ARTWORK")
	fs_usage_loot_greed:SetPoint("LEFT", t_loot_greed, "RIGHT", 3, -0)
	fs_usage_loot_greed:SetJustifyH("LEFT")
	fs_usage_loot_greed:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_loot_greed:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_loot_greed:SetText("AutoRoll Greed for Bijous/Coins")

	frame.fs_usage_loot_greed = fs_usage_loot_greed

	local t_loot_pass = CreateFrame("Button", nil, frame_usage_loot)
	t_loot_pass:SetPoint("TOPLEFT", frame_usage_loot, "TOPLEFT", 5, -43)
	t_loot_pass:SetWidth(11)
	t_loot_pass:SetHeight(11)
	t_loot_pass:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Pass-Normal")
	t_loot_pass:Disable()

	frame.t_loot_pass = t_loot_pass

	local fs_usage_loot_pass = frame_usage_loot:CreateFontString(nil, "ARTWORK")
	fs_usage_loot_pass:SetPoint("LEFT", t_loot_pass, "RIGHT", 3, -0)
	fs_usage_loot_pass:SetJustifyH("LEFT")
	fs_usage_loot_pass:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_usage_loot_pass:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_usage_loot_pass:SetText("AutoRoll Pass for Bijous/Coins")

	frame.fs_usage_loot_pass = fs_usage_loot_pass

	frame:Hide()

	return frame
end

local function GUI_ShowLooter(toggle)
	if toggle then
		local count = 0
		for k, v in pairs(ZGTrackerSV.lootTable) do
			if v["frame"] > 0 then
				count = count + 1
				local frame = GUI_Frame.playerinfo[v["frame"]]
				if frame then
					frame.fs_name:SetText(k)
					frame.fs_bijou:SetText(v["bijou"])
					frame.fs_coin:SetText(v["coin"])
					frame:Show()
				end
			end
		end
		local height = (ZGT_UI.HEIGHT + 15) + count * 13
		GUI_Frame:SetHeight(height)
	else
		for k, v in pairs(ZGTrackerSV.lootTable) do
			if v["frame"] > 0 then
				GUI_Frame.playerinfo[v["frame"]]:Hide()
			end
		end
		local height = (ZGT_UI.HEIGHT + 15)
		GUI_Frame:SetHeight(height)
	end
end

local function GUI_InfoLine_New(parent, anchorframe, name, offset, tCol)
	name = name or ""

	local hwidth = ZGT_UI.WIDTH - 2 * 3
	local fs_bijou_offset = floor(hwidth/4 + 0.5) * 3 - floor(hwidth/4 + 0.5) * 2 + 5
	local fs_coin_offset = floor(hwidth/4 + 0.5) * 1 - floor(hwidth/4 + 0.5) + 5

	local frame = CreateFrame("Frame", nil, parent)
	--frame:SetFrameLevel(3)
	frame:EnableMouse(true)
	frame:SetWidth(hwidth)
	frame:SetHeight(11)
	frame:SetPoint("TOP", anchorframe, "BOTTOM", 0, -offset)

	frame:SetBackdrop( {
		bgFile = ZGT_UI.BG_TEXTURE_FILE
	});
	frame:SetBackdropColor(tCol[1], tCol[2], tCol[3], ZGT_UI.BGALPHA)

	local fs_name = frame:CreateFontString(nil, "ARTWORK")
	fs_name:SetPoint("LEFT", frame, "LEFT", 3, 0)
	fs_name:SetJustifyH("LEFT")
	fs_name:SetFont(ZGT_UI.FONT_FILE, 9)
	fs_name:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_name:SetText(name)

	frame.fs_name = fs_name

	local fs_bijou = frame:CreateFontString(nil, "ARTWORK")
	fs_bijou:SetPoint("RIGHT", frame, "RIGHT", -fs_bijou_offset, 0)
	fs_bijou:SetJustifyH("RIGHT")
	fs_bijou:SetFont(ZGT_UI.FONT_FILE, 9)
	fs_bijou:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_bijou:SetText("0")

	frame.fs_bijou = fs_bijou

	local fs_coin = frame:CreateFontString(nil, "ARTWORK")
	fs_coin:SetPoint("RIGHT", frame, "RIGHT", -fs_coin_offset, 0)
	fs_coin:SetJustifyH("RIGHT")
	fs_coin:SetFont(ZGT_UI.FONT_FILE, 9)
	fs_coin:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_coin:SetText("0")

	frame.fs_coin = fs_coin

	frame:SetScript("OnMouseDown", function()
		local channel = nil
		local announce = false
		if arg1 == "LeftButton" and IsAltKeyDown() then
			channel = "SAY"
			announce = true
		elseif arg1 == "RightButton" and IsAltKeyDown() then
			channel = "RAID"
			announce = true
		end
		if announce then
			local date = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
			local name = this.fs_name:GetText()
			local bijou = this.fs_bijou:GetText()
			local coin = this.fs_coin:GetText()
			local str = string.format("[ZGTracker]   dataset [%s]", date)
			SendChatMessage(str, channel)
			local str = string.format("  %s  Bijous: [%3s]   Coins: [%3s]", name, bijou, coin)
			SendChatMessage(str, channel)
		end
	end)

	return frame
end

local function GUI_InfoLine_Update(frame, name, bijou, coin)
	frame.fs_name:SetText(name)
	frame.fs_bijou:SetText(bijou)
	frame.fs_coin:SetText(coin)
end

local function GUI_TableHeaders(parent)
	local hwidth = ZGT_UI.WIDTH - 2 * 3
	local fs_bijou_offset = floor(hwidth/4 + 0.5) * 3 - floor(hwidth/4 + 0.5) * 2 + 2
	local fs_coin_offset = floor(hwidth/4 + 0.5) * 1 - floor(hwidth/4 + 0.5) + 2

	local frame = CreateFrame("Frame", nil, parent)
	frame:SetWidth(hwidth)
	frame:SetHeight(15)
	frame:SetPoint("TOP", parent, "TOP", 0, -10)

	local fs_date = frame:CreateFontString(nil, "ARTWORK")
	fs_date:SetPoint("LEFT", frame, "LEFT", 3, -3)
	fs_date:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_date:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_date:SetText(string.format("%s - %s", ZGTrackerSV.reset_cdate, ZGTrackerSV.reset_time))

	frame.fs_date = fs_date

	local fs_bijou = frame:CreateFontString(nil, "ARTWORK")
	fs_bijou:SetPoint("RIGHT", frame, "RIGHT", -fs_bijou_offset, -3)
	fs_bijou:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_bijou:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_bijou:SetText("Bijous")

	frame.fs_bijou = fs_bijou

	local fs_coin = frame:CreateFontString(nil, "ARTWORK")
	fs_coin:SetPoint("RIGHT", frame, "RIGHT", -fs_coin_offset, -3)
	fs_coin:SetFont(ZGT_UI.FONT_FILE, 7)
	fs_coin:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_coin:SetText("Coins")

	frame.fs_coin = fs_coin

	return frame
end

local function GUI_Header()
	local frame = CreateFrame("Frame", "ZGT_GUI")
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("MEDIUM")
	frame:SetScale(ZGT_UI.SCALE)
	frame:SetWidth(ZGT_UI.WIDTH)
	frame:SetHeight(ZGT_UI.HEIGHT)
	frame:SetPoint("TOPRIGHT", ZGTrackerSV.x_anchor, ZGTrackerSV.y_anchor)

	frame:SetBackdrop( {
		bgFile = ZGT_UI.BG_TEXTURE_FILE
	});
	frame:SetBackdropColor(.01, .01, .01, ZGT_UI.BGALPHA)

	if ZGT_UI.LOCK then
		frame:SetMovable(false)
		frame:RegisterForDrag()
	else
		frame:SetMovable(true)
		frame:RegisterForDrag("LeftButton")
	end

	local ZGT_TITLE = GetAddOnMetadata("ZGTracker", "Title")
	local fs_title = frame:CreateFontString(nil, "ARTWORK")
	fs_title:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
	fs_title:SetFont(ZGT_UI.FONT_FILE, 10)
	fs_title:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
	fs_title:SetText(ZGT_TITLE)

	frame.fs_title = fs_title

	local btn_about = CreateFrame("Button", nil, frame)
	btn_about:SetWidth(11)
	btn_about:SetHeight(11)
	btn_about:SetPoint("TOPLEFT", frame, "TOPLEFT", 50, -3)
	btn_about:RegisterForClicks("LeftButtonDown")
	btn_about:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Normal")
	btn_about:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Pushed")
	btn_about:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
	
	--
	-- Buttons
	--
	btn_about:SetScript("OnClick", function()
		if arg1 == "LeftButton" then
			local state = this:GetButtonState()
			local frame = getglobal("ZGT_GUI_About")
			if state == "NORMAL" then
				this:SetButtonState("PUSHED", 1)
				frame:Show()
			else
				this:SetButtonState("NORMAL")
				frame:Hide()
			end
		end
	end)

	frame.btn_about = btn_about

	--[[
	local btn_option = CreateFrame("Button", nil, frame)
	btn_option:SetWidth(11)
	btn_option:SetHeight(11)
	btn_option:SetPoint("TOPLEFT", frame, "TOPLEFT", 62, -3)
	btn_option:RegisterForClicks("LeftButtonDown")
	btn_option:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Option-Normal")
	btn_option:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Option-Pushed")
	--btn_option:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Option-Highlight")
	btn_option:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
	
	btn_option:SetScript("OnClick", function()

	end)

	frame.btn_option = btn_option
	]]

	local btn_loot = CreateFrame("Button", nil, frame)
	btn_loot:SetWidth(11)
	btn_loot:SetHeight(11)
	btn_loot:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -44, -3)
	btn_loot:RegisterForClicks("LeftButtonDown")

	if ZGTrackerSV.auto_roll == "no" then
		btn_loot:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-No-Normal")
		btn_loot:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-No-Pushed")
		btn_loot:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
	elseif ZGTrackerSV.auto_roll == "NEED" then
		btn_loot:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Need-Normal")
		btn_loot:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Need-Pushed")
		btn_loot:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
	elseif ZGTrackerSV.auto_roll == "GREED" then
		btn_loot:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Greed-Normal")
		btn_loot:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Green-Pushed")
		btn_loot:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
	elseif ZGTrackerSV.auto_roll == "PASS" then
		btn_loot:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Pass-Normal")
		btn_loot:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Pass-Pushed")
		btn_loot:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
	end

	btn_loot:SetScript("OnClick", function()
		if arg1 == "LeftButton" then
			if ZGTrackerSV.auto_roll == "no" then
				ZGTrackerSV.auto_roll = "NEED"
				this:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Need-Normal")
				this:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Need-Pushed")
				this:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
			elseif ZGTrackerSV.auto_roll == "NEED" then
				ZGTrackerSV.auto_roll = "GREED"
				this:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Greed-Normal")
				this:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Green-Pushed")
				this:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
			elseif ZGTrackerSV.auto_roll == "GREED" then
				ZGTrackerSV.auto_roll = "PASS"
				this:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Pass-Normal")
				this:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Pass-Pushed")
				this:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")
			elseif ZGTrackerSV.auto_roll == "PASS" then
				ZGTrackerSV.auto_roll = "no"
				this:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-No-Normal")
				this:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-No-Pushed")
				this:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-About-Highlight")				
			end
		end
	end)

	frame.btn_loot = btn_loot


	local btn_flash = CreateFrame("Button", nil, frame)
	btn_flash:SetWidth(11)
	btn_flash:SetHeight(11)
	btn_flash:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -27, -3)
	btn_flash:RegisterForClicks("LeftButtonDown")
	btn_flash:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Flash-Normal")
	btn_flash:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Flash-Pushed")
	--btn_flash:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Flash-Highlight")
	btn_flash:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Close-Highlight")
	
	btn_flash:SetScript("OnClick", function()
		if arg1 == "LeftButton" then
			if ZGT_RESET_CHECK then ZGT_RESET_CHECK = false end
			local resettime = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
			local dialog = StaticPopup_Show ("ZGT_RESET_DATA_DIALOG", resettime)
		end
	end)

	frame.btn_flash = btn_flash

	local btn_detail = CreateFrame("Button", nil, frame)
	btn_detail:SetWidth(11)
	btn_detail:SetHeight(11)
	btn_detail:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, -3)
	btn_detail:RegisterForClicks("LeftButtonDown")
	btn_detail:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Details-Normal")
	btn_detail:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Details-Pushed")
	btn_detail:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Close-Highlight")
	if ZGTrackerSV.details then
		btn_detail:SetButtonState("PUSHED", 1)
	else
		btn_detail:SetButtonState("NORMAL")
	end

	btn_detail:SetScript("OnClick", function()
		if arg1 == "LeftButton" then
			local state = this:GetButtonState()
			if state == "NORMAL" then
				this:SetButtonState("PUSHED", 1)
				ZGTrackerSV.details = true
			else
				this:SetButtonState("NORMAL")
				ZGTrackerSV.details = false
			end
			GUI_ShowLooter(ZGTrackerSV.details)
		end
	end)

	frame.btn_detail = btn_detail

	local btn_close = CreateFrame("Button", nil, frame)
	btn_close:SetWidth(11)
	btn_close:SetHeight(11)
	btn_close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)
	btn_close:RegisterForClicks("LeftButtonDown")
	btn_close:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Close-Normal")
	btn_close:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Close-Pushed")
	btn_close:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Close-Highlight")
	
	btn_close:SetScript("OnClick", function()
		if arg1 == "LeftButton" then
			local frame = this:GetParent()
			if frame:IsVisible() then
				frame:Hide()
			end
		end
	end)
	
	frame.btn_close = btn_close

	--
	-- Frame Events
	--
	frame:SetScript("OnMouseDown", function()
		if arg1 == "LeftButton" and not this.isMoving then
			if this:IsMovable() then
				--this:SetFrameStrata("TOOLTIP")
				this:SetFrameStrata("FULLSCREEN_DIALOG")
				--this:SetFrameStrata("FULLSCREEN")
				--this:SetFrameStrata("DIALOG")
				this:SetBackdropColor(.17, .01, .01, ZGT_UI.BGALPHA + 0.17)
				this.fs_title:SetTextColor(1, .71, .71, ZGT_UI.BGALPHA + 0.17)
				this:StartMoving()
				this.isMoving = true
			end
		end
	end)

	frame:SetScript("OnMouseUp", function()
		if arg1 == "LeftButton" and this.isMoving then
			this:StopMovingOrSizing()
			this:SetFrameStrata("MEDIUM")
			this:SetBackdropColor(.01, .01, .01, ZGT_UI.BGALPHA)
			this.fs_title:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
			this.isMoving = false
			local right = this:GetRight()
			local top = this:GetTop()
			ZGTrackerSV.x_anchor = floor(right + 0.5)
			ZGTrackerSV.y_anchor = floor(top + 0.5)
		end
	end)

	frame:SetScript("OnHide", function()
		if this.isMoving then
			this:StopMovingOrSizing()
			this:SetFrameStrata("MEDIUM")
			this:SetBackdropColor(.01, .01, .01, ZGT_UI.BGALPHA)
			this.fs_title:SetTextColor(1, 1, 1, ZGT_UI.BGALPHA)
			this.isMoving = false
			local right = this:GetRight()
			local top = this:GetTop()
			ZGTrackerSV.x_anchor = floor(right + 0.5)
			ZGTrackerSV.y_anchor = floor(top + 0.5)
		end
	end)

	frame:Show()

	return frame
end

local function GetFrame_InfoLine(name)
	-- search for name
	ZGT_D("   -- [GetFrame] LooterCount: " .. ZGTrackerSV.looter_count)
	for i = 1, ZGTrackerSV.looter_count - 1 do
		local frame = GUI_Frame.playerinfo[i]
		local str = frame.fs_name:GetText()
		if str == name then
			ZGT_D("   -- [GetFrame] name found!")
			return frame
		end
	end

	return GUI_Frame.playerinfo[ZGTrackerSV.looter_count]
end

function ZGT_GUI_Add(index)
	if index == 0 then
		tCol = {.31, .01, .01} -- RED
		GUI_Frame.summaryinfo = GUI_InfoLine_New(GUI_Frame, GUI_Frame.tableheader, "Summary", 3, tCol)
	else
		if GUI_Frame.playerinfo[index] then
			ZGT_D("  -- [ZGT_GUI_Add] frame " .. index .. " exist. Clearing values.")
			GUI_Frame.playerinfo[index].fs_name:SetText("bogus" .. index)
			GUI_Frame.playerinfo[index].fs_bijou:SetText("0")
			GUI_Frame.playerinfo[index].fs_coin:SetText("0")
		else
			ZGT_D("  -- [ZGT_GUI_Add] frame " .. index .. " does NOT exist. Creating a new one.")
			local anchor_frame = nil
			if index == 1 then
				anchor_frame = GUI_Frame.summaryinfo
			else
				anchor_frame = GUI_Frame.playerinfo[index - 1]
			end

			local tCol = {}
			if (index - math.floor(index/2)*2) == 0 then
				tCol = {.01, .31, .11} -- GREEN
			else
				tCol = {.01, .11, .31} -- BLUE
			end

			GUI_Frame.playerinfo[index] = GUI_InfoLine_New(GUI_Frame, anchor_frame, "bogus" .. index, 2, tCol)
		end
		if ZGTrackerSV.details then
			GUI_Frame.playerinfo[index]:Show()
			local height = (ZGT_UI.HEIGHT + 15) + ZGTrackerSV.looter_count * 13
			GUI_Frame:SetHeight(height)
		else
			GUI_Frame.playerinfo[index]:Hide()
		end
	end
end

function ZGT_GUI_Update(name)
	ZGT_D("   -- [ZGT_GUI_Update] LooterCount: " .. ZGTrackerSV.looter_count)
	if name == nil then
		ZGT_D("   -- [ZGT_GUI_Update] Summary")
		local frame = GUI_Frame.summaryinfo
		GUI_InfoLine_Update(frame, "Summary", ZGTrackerSV.bijou_total, ZGTrackerSV.coin_total)
	else
		ZGT_D("   -- [ZGT_GUI_Update] " .. name)
		local frame = GetFrame_InfoLine(name)
		GUI_InfoLine_Update(frame, name, ZGTrackerSV.lootTable[name]["bijou"], ZGTrackerSV.lootTable[name]["coin"])
	end
end

function ZGT_GUI_Reset()
	local frame = GUI_Frame.tableheader
	frame.fs_date:SetText(string.format("%s - %s", ZGTrackerSV.reset_cdate, ZGTrackerSV.reset_time))

	local frame = GUI_Frame.summaryinfo
	frame.fs_bijou:SetText("0")
	frame.fs_coin:SetText("0")

	ZGT_D("  -- Count: " .. ZGTrackerSV.looter_count)
	for i = 1, ZGTrackerSV.looter_count do
		local frame = GUI_Frame.playerinfo[i]
		if frame then
			if frame:IsVisible() then
				ZGT_D("  -- Hiding playerinfo[" .. i .. "]")
				frame:Hide()
				frame:GetParent():SetHeight(frame:GetParent():GetHeight() - 13)
			end
			frame.fs_name:SetText("bogus" .. i)
			frame.fs_bijou:SetText("0")
			frame.fs_coin:SetText("0")
		else
			ZGT_D("  -- reaced the end. i: " .. i)
			break
		end
	end
end

function ZGT_GUI_Init()
	local tCol = {}

	if GUI_Frame then
		if GUI_Frame.GetFrameType then
			GUI_Frame:SetParent(nil)
		end
		GUI_Frame = {}
	end

	GUI_Frame =	GUI_Header()

	GUI_Frame.aboutframe = GUI_About(GUI_Frame)

	GUI_Frame.tableheader = GUI_TableHeaders(GUI_Frame)

	-- summary line!
	ZGT_GUI_Add(0)
 	GUI_Frame:SetHeight(GUI_Frame:GetHeight() + 15) -- should be 55 now!
	ZGT_GUI_Update()

	GUI_Frame.playerinfo = {}

	ZGT_D("Initial GUI filling...")
	for i = 1, ZGTrackerSV.looter_count do
		ZGT_GUI_Add(i)
		ZGT_GUI_Update(looter)
	end
	ZGT_D("...done")

	GUI_ShowLooter(ZGTrackerSV.details)

	return true
end
