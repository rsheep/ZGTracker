local ZGT_FU_DEBUG = false

local function ZGT_D(text)
	local header = "|cffAA5555[ZGT FU] "
	if ZGT_FU_DEBUG then
		DEFAULT_CHAT_FRAME:AddMessage(header .. "|cffffffff" .. text)
	end
end

local ClassTextColor = {
	["UNKNOWN"]	= "|cffffffff",
	["DRUID"]	= "|cffff7d0a",
	["HUNTER"]	= "|cffabd473",
	["MAGE"]	= "|cff69ccf0",
	["PALADIN"]	= "|cfff58cba",
	["PRIEST"]	= "|cffffffff",
	["ROGUE"]	= "|cfffff569",
	["SHAMAN"]	= "|cfff58cba",
	["WARLOCK"]	= "|cff9482c9",
	["WARRIOR"]	= "|cffc79c6e",
	--["SHAMAN"]	= { {0.00, 0.86, 0.73 }, "Shaman"  }, -- TBC Shaman Color
}

if not IsAddOnLoaded("Fubar") then
	ZGT_D("Going Out? :(")
	return
end

local tablet = AceLibrary("Tablet-2.0")
ZGTFu = AceLibrary("AceAddon-2.0"):new("FuBarPlugin-2.0")
ZGTFu.hasIcon = "Interface\\AddOns\\ZGTracker\\Textures\\ZGT_FuBar"
--ZGTFu.hasNoText = true
ZGTFu.defaultPosition = "RIGHT"

-- using an AceOptions data table
local options = {
    type = 'group',
    args = {
    	zgt_labels_toggle = {
			order = 1,
		    type = "toggle",
            name = "Show Labels",
            desc = "Click to toggle labels Visibility",
            get = "Is_Labels",
            set = "Toggle_Labels",
		},
		zgt_bijou_toggle = {
			order = 2,
		    type = "toggle",
            name = "Show Bijous",
            desc = "Click to toggle Bijous Visibility",
            get = "Is_Bijou",
            set = "Toggle_Bijou",
		},
		zgt_coin_toggle = {
			order = 3,
		    type = "toggle",
            name = "Show Coins",
            desc = "Click to toggle Coins Visibility",
            get = "Is_Coin",
            set = "Toggle_Coin",
		},

		zgt_separator1 = {
			order = 4,
			type = "toggle",
			name = " ",
			desc = " ",
			get = function() end,
			set = function() end,
			disabled = true,
		},

		zgt_money_frame_toggle = {
			order = 5,
		    type = "toggle",
            name = "Money Frame",
            desc = "Click to toggle Money Frame Visibility",
            get = "Is_Money_Frame",
            set = "Toggle_Money_Frame",
		},

		zgt_separator2 = {
			order = 6,
			type = "toggle",
			name = " ",
			desc = " ",
			get = function() end,
			set = function() end,
			disabled = true,
		},

		zgt_loot_announce_toggle = {
			order = 7,
            type = "toggle",
            name = "AutoRoll Messages",
            desc = "Click to toggle AutoRoll Mesagges On/Off",
            get = "Is_AutoRoll_Message",
            set = "Toggle_AutoRoll_Message",
        },
		zgt_loot_spam_toggle = {
			order = 8,
            type = "toggle",
            name = "Loot Spam",
            desc = "Click to toggle Loot Spam suppression On/Off",
            get = "Is_Loot_Spam",
            set = "Toggle_Loot_Spam",
        },
		zgt_money_spam_toggle = {
			order = 9,
            type = "toggle",
            name = "Money Spam",
            desc = "Click to toggle Money Spam suppression On/Off",
            get = "Is_Money_Spam",
            set = "Toggle_Money_Spam",
        },
		
    }
}
ZGTFu.OnMenuRequest = options

function ZGTFu:OnInitialize()
	self.title = "ZGTracker"
	self.hasIcon = "Interface\\AddOns\\ZGTracker\\Textures\\ZGT_FuBar.tga"
	self.cannotHideText = true
	self.overrideMenu = false
	self.hideMenuTitle  = true
	self.defaultPosition = "RIGHT"
	self.defaultMinimapPosition = 180
	self.independentProfile = false
	if not ZGTrackerSV["ZGTFu"] then
		ZGTrackerSV["ZGTFu"] = {}
	end
end

function ZGTFu:OnEnable()
	self:ShowIcon()
	self:SetIcon(true)
end


function ZGTFu:Is_Labels()
	return ZGTrackerSV["ZGTFu"].ShowLabels
end

function ZGTFu:Toggle_Labels()
	ZGTrackerSV["ZGTFu"].ShowLabels = not ZGTrackerSV["ZGTFu"].ShowLabels
	self:UpdateText()
end

function ZGTFu:Is_Coin()
	return ZGTrackerSV["ZGTFu"].ShowCoin
end

function ZGTFu:Toggle_Coin()
	ZGTrackerSV["ZGTFu"].ShowCoin = not ZGTrackerSV["ZGTFu"].ShowCoin
	self:UpdateText()
end

function ZGTFu:Is_Bijou()
	return ZGTrackerSV["ZGTFu"].ShowBijou
end

function ZGTFu:Toggle_Bijou()
	ZGTrackerSV["ZGTFu"].ShowBijou = not ZGTrackerSV["ZGTFu"].ShowBijou
	self:UpdateText()
end

function ZGTFu:Is_AutoRoll_Message()
	return ZGTrackerSV.auto_roll_message
end

function ZGTFu:Toggle_AutoRoll_Message()
	local option = getglobal("ZGT_GUI_Option")
	if self.Is_AutoRoll_Message() then
		ZGTrackerSV.auto_roll_message = false
		option.btn_auto_roll_message:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Off-Normal")
		option.btn_auto_roll_message:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Off-Pushed")
		option.btn_auto_roll_message:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Blue-Highlight")
	else
		ZGTrackerSV.auto_roll_message = true
		option.btn_auto_roll_message:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-On-Normal")
		option.btn_auto_roll_message:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-On-Pushed")
		option.btn_auto_roll_message:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Red-Highlight")				
	end
end

function ZGTFu:Is_Loot_Spam()
	return ZGTrackerSV.spam_loot
end

function ZGTFu:Toggle_Loot_Spam()
	local option = getglobal("ZGT_GUI_Option")
	if self.Is_Loot_Spam() then
		ZGTrackerSV.spam_loot = false
		option.btn_spam_loot:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Off-Normal")
		option.btn_spam_loot:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Off-Pushed")
		option.btn_spam_loot:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Blue-Highlight")
	else
		ZGTrackerSV.spam_loot = true
		option.btn_spam_loot:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-On-Normal")
		option.btn_spam_loot:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-On-Pushed")
		option.btn_spam_loot:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Red-Highlight")				
	end
end

function ZGTFu:Is_Money_Spam()
	return ZGTrackerSV.spam_money
end

function ZGTFu:Toggle_Money_Spam()
    local option = getglobal("ZGT_GUI_Option")
	if self.Is_Money_Spam() then
		ZGTrackerSV.spam_money = false
		option.btn_spam_money:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Off-Normal")
		option.btn_spam_money:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Off-Pushed")
		option.btn_spam_money:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Blue-Highlight")
	else
		ZGTrackerSV.spam_money = true
		option.btn_spam_money:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-On-Normal")
		option.btn_spam_money:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-On-Pushed")
		option.btn_spam_money:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Red-Highlight")
	end
end

function ZGTFu:Is_Money_Frame()
	return ZGTrackerSV.display_money
end

function ZGTFu:Toggle_Money_Frame()
	local frame = getglobal("ZGT_GUI")
	local option = getglobal("ZGT_GUI_Option")
	if self.Is_Money_Frame() then
		ZGTrackerSV.display_money = false
		option.btn_display_money:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Off-Normal")
		option.btn_display_money:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Off-Pushed")
		option.btn_display_money:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Blue-Highlight")
		frame.moneyframe:Hide()
		frame.optionframe:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -1)
	else
		ZGTrackerSV.display_money = true
		option.btn_display_money:SetNormalTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-On-Normal")
		option.btn_display_money:SetPushedTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-On-Pushed")
		option.btn_display_money:SetHighlightTexture("Interface\\AddOns\\ZGTracker\\Textures\\Buttons\\Button-Red-Highlight")
		frame.moneyframe:Show()
		frame.optionframe:SetPoint("TOPLEFT", frame.moneyframe, "BOTTOMLEFT", 0, -1)
	end
end

function ZGTFu:OnDataUpdate()
	self.reset_time = ZGTrackerSV.reset_time
	self.reset_cdate = ZGTrackerSV.reset_cdate
    self.coin_total = ZGTrackerSV.coin_total
	self.bijou_total = ZGTrackerSV.bijou_total
	self.copper_total = ZGTrackerSV.copper_total
	self.reputation_total = ZGTrackerSV.reputation_total
	self.lootTable = ZGTrackerSV.lootTable
	self.reset_cdate = ZGTrackerSV.reset_cdate
	self.reset_time = ZGTrackerSV.reset_time
end

function ZGTFu:OnTextUpdate()
	local coin_total = self.coin_total or ""
	local bijou_total = self.bijou_total or ""

	local white = "|cffffffff"
	local blue = "|c003355bb"
	local green = "|c0000bb33"
	local labelBijous = "Bijous"
	local labelCoins = "Coins"
	local textBijous = ""
	local textCoins = ""
	
	local separator = " -"
	
	local text = ""

	if self:Is_Labels() then
		textBijous = "  " .. blue .. labelBijous .. white .. ":" .. bijou_total
		textCoins = " " .. green .. labelCoins .. white .. ":" .. coin_total
	else
		textBijous = blue .. "  B" .. white .. ":" .. bijou_total
		textCoins = green .. " C" .. white .. ":" .. coin_total
	end

	if self:Is_Bijou() and self:Is_Coin() then
		text = textBijous .. " " .. textCoins
	elseif self:Is_Bijou() and not self:Is_Coin() then
		text = textBijous
	elseif not self:Is_Bijou() and self:Is_Coin() then
		text = textCoins
	end
	
	self:SetText(text)
end

function ZGTFu:OnTooltipUpdate()
	self:UpdateData()

	local playername = UnitName('player')
	local gold = math.floor(self.copper_total / 10000)
	local silver = math.floor((self.copper_total - (gold * 10000)) / 100)
	local copper = self.copper_total - (gold * 10000) - (silver * 100)
	local moneystring = nil
	if gold > 0 then
		moneystring = "|Cffffffff" .. tostring(gold) .. " |Cffeeee33G " .. 
					"|Cffffffff" .. tostring(silver) .. " |CffbbbbbbS " .. 
					"|Cffffffff" .. tostring(copper) .. " |Cffc79c6eC"
	elseif gold == 0 and silver > 0 then
		moneystring = "|Cffffffff" .. tostring(silver) .. " |CffbbbbbbS " .. 
					"|Cffffffff" .. tostring(copper) .. " |Cffc79c6eC"
	else
		moneystring = "|Cffffffff" .. tostring(copper) .. " |Cffc79c6eC"
	end


	tablet:SetHint("\n\n  |cffffffffLeftClick|r:" ..
				"\n Toggle ZGTracker Frame." ..
				"\n\n  |cffffffffAlt + LeftClick|r:" ..
				"\n RaidAnnounce Bijous/Coins." ..
				"\n\n  |cffffffffAlt + Ctrl + LeftClick|r:" ..
				"\n RaidAnnounce Money and Reputation.")
    -- as a rule, if you have an OnClick or OnDoubleClick or OnMouseUp or 
    -- OnMouseDown, you should set a hint.
    local cat = tablet:AddCategory(
        --"text", "|cffaabb00DataSet|r:   " .. self.reset_cdate .. " - " .. self.reset_time,
        "text", "DataSet:",
        "textR", .71,
        "textG", .31,
        "textB", .31,
        "child_size", 9,
        "child_size2", 9,
        "child_size3", 9,
        "columns", 3,
        "text2", self.reset_cdate,
        "size2", 10,
        "text2R", 1,
        "text2G", 1,
        "text2B", 1,
        "text3", self.reset_time,
        "size3", 10,
        "text3R", 1,
        "text3G", 1,
        "text3B", 1
    )
	cat:AddLine(
    	"text", " ",
    	"textR", 1,
    	"textG", 1,
    	"textB", 0
    )
	cat:AddLine(
        "text", "", --"Bijous&Coins",
    	"text2", "Bijous",
    	"size2", 12,
        "text2R", 1,
        "text2G", 1,
        "text2B", 0,
        "text3", "Coins",
        "size3", 12,
        "text3R", 1,
        "text3G", 1,
        "text3B", 0
    )
    cat:AddLine(
    	"text", "Summary: ",
    	"size", 12,
    	"textR", .71,
    	"textG", .31,
    	"textB", .31,
	   	"text2", tostring(self.bijou_total),
   		"text2R", 1,
    	"text2G", 1,
    	"text2B", 1,
    	"text3", tostring(self.coin_total),
    	"text3R", 1,
    	"text3G", 1,
    	"text3B", 1
    )
    cat:AddLine(
    	"text", ClassTextColor[self.lootTable[playername]["class"]] .. playername .. "|cffffffff: ",
    	"textR", 1,
    	"textG", 1,
    	"textB", 0,
	   	"text2", tostring(self.lootTable[playername]["bijou"]),
   		"text2R", 1,
    	"text2G", 1,
    	"text2B", 1,
    	"text3", tostring(self.lootTable[playername]["coin"]),
    	"text3R", 1,
    	"text3G", 1,
    	"text3B", 1
    )
    for k,v in pairs(self.lootTable) do
    	if k ~= playername then
    		cat:AddLine(
		    	"text", ClassTextColor[v["class"]] .. k .. "|cffffffff: ",
		    	"textR", 1,
		    	"textG", 1,
		    	"textB", 0,
			   	"text2", tostring(v["bijou"]),
		   		"text2R", 1,
		    	"text2G", 1,
		    	"text2B", 1,
		    	"text3", tostring(v["coin"]),
		    	"text3R", 1,
		    	"text3G", 1,
		    	"text3B", 1
		    )
    	end
    end
    cat:AddLine(
    	"text", " ",
    	"textR", 1,
    	"textG", 1,
    	"textB", 0
    )

    local cat = tablet:AddCategory(
        "text", "", --"Bijous&Coins",
        "child_size", 10,
        "child_size2", 10,
        "columns", 2
    ) 
    cat:AddLine(
    	--"text", "Reputation:  |cffffffff" .. tostring(self.reputation_total),
    	"text", "Reputation:",
    	"size", 12,
    	"textR", .71,
    	"textG", .31,
    	"textB", .31,
    	"text2", tostring(self.reputation_total),
    	"size2", 10,
   		"text2R", 1,
    	"text2G", 1,
    	"text2B", 1
    )
    cat:AddLine(
    	"text", "Money:",
    	"size", 12,
    	"textR", .71,
    	"textG", .31,
    	"textB", .31,
    	"text2", moneystring,
    	"size2", 10,
   		"text2R", 1,
    	"text2G", 1,
    	"text2B", 1
    )
end

function ZGTFu:OnClick(button)
    local date = self.reset_cdate .. " - " .. self.reset_time
	local channel = "RAID"

	if button == "LeftButton" and IsAltKeyDown() and IsControlKeyDown() then
		local gold = math.floor(self.copper_total / 10000)
		local silver = math.floor((self.copper_total - (gold * 10000)) / 100)
		local copper = self.copper_total - (gold * 10000) - (silver * 100)

		local str = string.format("[ZGTracker]   dataset [%s]", date)
		SendChatMessage(str, channel)
		local str = string.format("  Zandalar Tribe reputation earned: %s", self.reputation_total)
		SendChatMessage(str, channel)
		local str = string.format("  %s golds, %s silver, %s copper   Looted", gold, silver, copper)
		SendChatMessage(str, channel)
	elseif button == "LeftButton" and IsAltKeyDown() then
		local str = string.format("[ZGTracker]   dataset [%s]", date)
		SendChatMessage(str, channel)
		local str = string.format("  %s  Bijous: [%3s]   Coins: [%3s]", "Summary", self.bijou_total, self.coin_total)
		SendChatMessage(str, channel)
	elseif button == "LeftButton" then
		local frame = getglobal("ZGT_GUI")
	    if frame:IsVisible() then
	        frame:Hide()
		else
	        frame:Show()
	    end
	end
end

function ZGTFu:OnDoubleClick(button)
end