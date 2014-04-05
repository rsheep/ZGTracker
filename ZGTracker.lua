ZGTrackerSV = {
	lootTable = {
		--["Name"] = {
		--	["coin"] = 0
		--	["bijou"] = 0
		--	["frame"] = x
		--  ["class"] = "STRING"
		--},
	},
	bijou_total = 0,
	coin_total = 0,
	looter_count = 0,
	reset_time = "N/A",
	reset_date = "N/A",
	reset_cdate = "N/A",
	reset_epoch = 0,
	details = "raid", -- summary/self/raid
	auto_roll = "no",
	auto_roll_message = true,
	x_anchor = 200,
	y_anchor = 50,
	copper_total = 0,
	reputation_total = 0,
	display_reputation = true,
	display_money = true,
	spam_loot = false,
	spam_money = false,
	ZGTFu = {
		ShowLabels = true,
		ShowCoin = true,
		ShowBijou = true,
	},
}

local ZGT_VERSION = 0.095
local ZGT_DEBUG = false

local ZGT_RESET_CHECK = true

local Original_ChatFrame_OnEvent = ChatFrame_OnEvent

local function ZGT_D(text)
	local header = "|cffCC5555[ZGT] "
	if ZGT_DEBUG then
		DEFAULT_CHAT_FRAME:AddMessage(header .. "|cffffffff" .. text)
	end
end

local function ZGT_STATUS(text, head)
	local ZGT_TITLE = GetAddOnMetadata("ZGTracker", "Title")
	local header = "|cff00eeeeZGTracker: "
	local header = ZGT_TITLE .. ": "
	if head then
		header = "|cff00eeee" .. head
	end

	DEFAULT_CHAT_FRAME:AddMessage(header .. "|cffffffff" .. text)
end



local function ZGT_ChatFrame_OnEvent(event)
	if event == "CHAT_MSG_LOOT" then
		local _, _, loot_coin = string.find(arg1 , "(%[.+Coin%])")
		local _, _, loot_bijou = string.find(arg1 , "(%[.+Bijou%])") 

		if loot_coin or loot_bijou then
			local msgtype = nil
			local name = nil
			local selected = string.find(arg1, "(ha%a+%sselected)")
			local passed = string.find(arg1, "(passed%son:)")
			local _, _, roll = string.find(arg1, "(%a+)%sRoll%s-%s")

			if selected or passed then 
				msgtype = 'SELECT'
				_, _, name = string.find(arg1, "^(%a+)")
			elseif roll then
				msgtype = 'ROLL'
				_, _, name = string.find(arg1, "by%s(%a+)")
				if name == UnitName('player') then
					local _, _, link = string.find(arg1, "(\124%x+\124Hitem:.-\124h.-\124h\124r)")
					local _, _, value = string.find(arg1, "(%d+)")
					if ZGTrackerSV.auto_roll_message then
						ZGT_STATUS("  |cff0e9900AutoRoll  [|r|cfffe1111" .. roll .. "|r|cff0e9900]:|r|cffffffff " .. value .. "|r  on " .. link)
					end
				end
			else
				msgtype = 'other'
			end

			if msgtype == 'SELECT' or msgtype == 'ROLL' and ZGTrackerSV.spam_loot then
				return
			end
		end
	elseif event == "CHAT_MSG_MONEY" then
		if ZGTrackerSV.spam_money then
			return
		end
	end

	Original_ChatFrame_OnEvent(event)
end



local function ZGT_InstanceCheck()
	local zg = false

	if IsInInstance() then
		local zone = GetZoneText()
		local zoneR = GetRealZoneText()
		if zone == "Zul'Gurub" or zoneR == "Zul'Gurub" then
			zg = true		
		end
	end

	return zg
end

local function ZGT_GetClass(looter)
	local num = GetNumRaidMembers()

	for i = 1, num do
		local membername = UnitName("raid" .. i)
		if membername == looter then
			local _, class = UnitClass("raid" ..i)
			return class
		end
	end
end

local function ZGT_PrintChat_Help()
	ZGT_STATUS("Keep track of looted Bijous/Coins inside Zul'Gurub.")
	ZGT_STATUS("/zgtracker /zgt {toggle | reset | loot | help | about}", "Usage: ")
	ZGT_STATUS("Toggle ZGTracker GUI on/off", " - toggle: ")
	ZGT_STATUS("Reset Bijous/Coing counters", " - reset: ")
	ZGT_STATUS("Print Bijous/Coins counters", " - print {all | name}: ")
	ZGT_STATUS("Announce Bijous/Coins counters", " - raidannounce | ra {name}: ")
	ZGT_STATUS("Display this help", " - help: ")
	ZGT_STATUS("Print out addon info", " - about: ")
end

local function ZGT_PrintChat_About()
	local ZGT_TITLE = GetAddOnMetadata("ZGTracker", "Title")
	local ZGT_VERSION = GetAddOnMetadata("ZGTracker", "Version")
	local ZGT_AUTHOR = GetAddOnMetadata("ZGTracker", "Author")
	local ZGT_WEBSITE = GetAddOnMetadata("ZGTracker", "X-Website")
	ZGT_STATUS("Keep track of looted Bijous/Coins inside Zul'Gurub.", ZGT_TITLE .. " - ")
	ZGT_STATUS(ZGT_AUTHOR, " - Author: ")
	ZGT_STATUS(ZGT_VERSION, " - Version: ")
	ZGT_STATUS("[" .. ZGT_WEBSITE .. "]", " - Website: ")
end

local function ZGT_ResetData()
	local localdate = date("%A %d %B %Y")
	local localcdate = date("%d/%m/%y")
	local localtime = date("%H:%M")
	local epoch = time()
	
	ZGTrackerSV.copper_total = 0
	ZGTrackerSV.bijou_total = 0
	ZGTrackerSV.coin_total = 0
	ZGTrackerSV.reputation_total = 0
	ZGTrackerSV.looter_count = 0

	
	ZGTrackerSV.reset_date = localdate
	ZGTrackerSV.reset_cdate = localcdate
	ZGTrackerSV.reset_time = localtime
	ZGTrackerSV.reset_epoch = epoch
	

	ZGTrackerSV.lootTable = {}

	ZGTrackerSV.looter_count = ZGTrackerSV.looter_count + 1
	
	local looter = UnitName('player')
	local _, class = UnitClass('player')
	ZGTrackerSV.lootTable[looter] = {}
	ZGTrackerSV.lootTable[looter]["coin"] = 0
	ZGTrackerSV.lootTable[looter]["bijou"] = 0
	ZGTrackerSV.lootTable[looter]["frame"] = ZGTrackerSV.looter_count
	ZGTrackerSV.lootTable[looter]["class"] = class

	ZGT_GUI_Reset()

	ZGT_STATUS("Loot-Data Reset Successfull. [ " .. localcdate .. " - " .. localtime.. " ]")
end

local function ZGT_AutoRoll(id)
	-- Blizzard uses 0 to pass, 1 to Need an item, 2 to Greed an item
	local roll_value = nil
	if ZGTrackerSV.auto_roll == "Need" then
		roll_value = 1
	elseif ZGTrackerSV.auto_roll == "Greed" then
		roll_value = 2
	elseif ZGTrackerSV.auto_roll == "Pass" then
		roll_value = 0
	end

	if ZGTrackerSV.auto_roll ~= "no" then
		local _, name, _, quality = GetLootRollItemInfo(id);
		if string.find(name ,"Hakkari Bijou") or string.find(name ,"Coin") then
			RollOnLoot(id, roll_value)
			return
		end	
	end	
end

local function ZGT_ScanLootMSG(msg)
	local w = {}

	for s in string.gfind(msg, "[^%s]+") do
		table.insert(w, s)
	end

	local loottype, looter, class = nil, nil, nil
	if w[2] == "won:" or w[2] == "receive" or w[2] == "receives" then
		if (string.find(msg,"Coin")) then
			loottype = "coin"
		elseif (string.find(msg,"Bijou")) then
			loottype = "bijou"
		else
			loottype = "other"
			return loottype--, looter
		end

		if loottype == "coin" or loottype == "bijou" then
			_, _, looter = string.find(msg, "(%a+)")
			if looter == "You" then
				looter = UnitName('player')
			end
		end
	end

	class = ZGT_GetClass(looter)

	if ZGT_RESET_CHECK then
		ZGT_RESET_CHECK = false

		local timediff = time() - ZGTrackerSV.reset_epoch

		if (ZGTrackerSV.bijou_total or ZGTrackerSV.coin_total) and 
				(ZGTrackerSV.bijou_total > 0 or ZGTrackerSV.coin_total > 0) and
				timediff > 14400 then
			local resettime = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
			local dialog = StaticPopup_Show ("ZGT_RESET_DATA_DIALOG", resettime)
			if dialog then
				dialog.data = loottype
				dialog.data2 = looter
				dialog.data3 = class
			end
			ZGT_STATUS("Friendly Reminder! Use '/zgt reset' at raid start to wipe Loot-Dataset!")
		end
	end

	return loottype, looter, class
end

local function ZGT_AddLoot(loottype, looter, class)
	ZGTrackerSV.coin_total = ZGTrackerSV.coin_total or 0
	ZGTrackerSV.bijou_total = ZGTrackerSV.bijou_total or 0
	ZGTrackerSV.looter_count = ZGTrackerSV.looter_count or 0

	if ZGTrackerSV and loottype and looter then
		if loottype == "coin" then
			ZGTrackerSV.coin_total = ZGTrackerSV.coin_total + 1
		elseif loottype == "bijou" then
			ZGTrackerSV.bijou_total = ZGTrackerSV.bijou_total + 1
		end
		
		if not ZGTrackerSV.lootTable then
			ZGTrackerSV.lootTable = {}
		end

		if ZGTrackerSV.lootTable[looter] then
			ZGTrackerSV.lootTable[looter][loottype] = ZGTrackerSV.lootTable[looter][loottype] + 1
		else
			ZGTrackerSV.looter_count = ZGTrackerSV.looter_count + 1
			ZGTrackerSV.lootTable[looter] = {}
			ZGTrackerSV.lootTable[looter]["coin"] = 0
			ZGTrackerSV.lootTable[looter]["bijou"] = 0
			ZGTrackerSV.lootTable[looter]["frame"] = ZGTrackerSV.looter_count
			ZGTrackerSV.lootTable[looter]["class"] = class
			ZGTrackerSV.lootTable[looter][loottype] = ZGTrackerSV.lootTable[looter][loottype] + 1
			ZGT_D("data: " .. ZGTrackerSV.looter_count .. " - data2: " .. looter .. " - data3: " .. class)
			ZGT_GUI_Add(ZGTrackerSV.looter_count, looter, class)
		end
		-- summary update
		ZGT_GUI_Update()
		-- looter update
		ZGT_GUI_Update(looter)

	end
end

local function ZGT_Print_PlayerData(name)
	local data = false
	if not ZGTrackerSV then 
		ZGT_STATUS("There's not Data Available...something is wrong...")
		return false
	elseif ZGTrackerSV.lootTable[name] then
		data = true
	end

	if not data then
		ZGT_STATUS("Player: " .. name .. " did not loot any bijous/coins.")
		return false
	else
		local resettime = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
		local str = string.format("dataset [%s]", resettime)
		ZGT_STATUS(str)
		local str = string.format("  Bijous: [%3s]   Coins: [%3s]", ZGTrackerSV.lootTable[name]["bijou"], ZGTrackerSV.lootTable[name]["coin"])
		ZGT_STATUS(str, "  " .. name)
	end
end

local function ZGT_Print_SummaryData()
	local data = false

	if not ZGTrackerSV then 
		ZGT_STATUS("There's not Data Available...something is wrong...")
		return false
	elseif not ZGTrackerSV.coin_total and not ZGTrackerSV.coin_total then
		data = false
	else
		data = true
	end

	if not data then
		ZGT_STATUS("No loot-data available.")
		return false
	else
		ZGTrackerSV.coin_total = ZGTrackerSV.coin_total or 0
		ZGTrackerSV.bijou_total = ZGTrackerSV.bijou_total or 0

		local resettime = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
		local str = string.format("dataset [%s]", resettime)
		ZGT_STATUS(str)
		local str = string.format("  Bijous: [%3s]   Coins: [%3s]", ZGTrackerSV.bijou_total, ZGTrackerSV.coin_total)
		ZGT_STATUS(str, "  Summary")
	end
end

local function ZGT_Print_AllData()
	local data = false

	if not ZGTrackerSV then 
		ZGT_STATUS("There's not Data Available...something is wrong...")
		return false
	else
		data = true
	end
	
	if not data then
		ZGT_STATUS("No loot-data available.")
		return false
	else
		ZGTrackerSV.coin_total = ZGTrackerSV.coin_total or 0
		ZGTrackerSV.bijou_total = ZGTrackerSV.bijou_total or 0

		local resettime = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
		local str = string.format("dataset [%s]", resettime)
		ZGT_STATUS(str)
		local str = string.format("  Bijous: [%3s]   Coins: [%3s]", ZGTrackerSV.bijou_total, ZGTrackerSV.coin_total)
		ZGT_STATUS(str, "  Summary")
		for k,v in pairs(ZGTrackerSV.lootTable) do
			local str = string.format("  Bijous: [%3s]   Coins: [%3s]", v["bijou"], v["coin"])
			ZGT_STATUS(str, "  " .. k)
		end
	end
end

local function ZGT_RaidAnnounce(name)
	local ZGT_TITLE = GetAddOnMetadata("ZGTracker", "Title")
	local data = false

	if not ZGTrackerSV then 
		ZGT_STATUS("There's not Data Available...something is wrong...")
		return false
	elseif not ZGTrackerSV.coin_total and not ZGTrackerSV.bijou_total then
		data = false
	else
		data = true
	end

	if not data then
		ZGT_STATUS("No loot-data available.")
		return false
	else
		ZGTrackerSV.coin_total = ZGTrackerSV.coin_total or 0
		ZGTrackerSV.bijou_total = ZGTrackerSV.bijou_total or 0

		local resettime = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
		local str = string.format("[ZGTracker]   dataset [%s]", resettime)
		SendChatMessage(str, "RAID")
		local str = string.format("  %s  Bijous: [%3s]   Coins: [%3s]", "Summary", ZGTrackerSV.bijou_total, ZGTrackerSV.coin_total)
		SendChatMessage(str, "RAID")
	end

	if name then
		if not ZGTrackerSV.lootTable[name] then
			local str = string.format("  %s did not loot any bijous/coins.", name)
			SendChatMessage(str, "RAID", nil, nil)
		else
			ZGTrackerSV.lootTable[name]["coin"] = ZGTrackerSV.lootTable[name]["coin"] or 0
			ZGTrackerSV.lootTable[name]["bijou"] = ZGTrackerSV.lootTable[name]["bijou"] or 0

			local str = string.format("  %s  Bijous: [%3s]   Coins: [%3s]", name, ZGTrackerSV.lootTable[name]["bijou"], ZGTrackerSV.lootTable[name]["coin"])
			SendChatMessage(str, "RAID")
		end
	end
end



local function ZGT_Event_CHAT_MSG_MONEY(msg)
	if ZGT_InstanceCheck() then
		local coins = {}

		for s in string.gfind(msg, "%d+ %a+") do
			table.insert(coins, s)
		end

		local copper = 0
		
		for _,v in pairs(coins) do
			if v then
				local _, _, value = string.find(v, "(%d+)")
				value = tonumber(value)
				local _, _, moneytype = string.find(v, "(%a+)")
				if moneytype == 'Copper' then
					copper = copper + value
				elseif moneytype == 'Silver' then
					copper = copper + value * 100
				elseif moneytype == 'Gold' then
					copper = copper + value * 100 * 100
				end
			end
		end

		ZGTrackerSV.copper_total = ZGTrackerSV.copper_total + copper
		MoneyFrame_Update(getglobal("ZGT_GUI_SmallMoneyFrame"):GetName(), ZGTrackerSV.copper_total)
	end
end

local function ZGT_Event_CHAT_MSG_LOOT(msg, id)
	--msg 	- arg1	Chat message 
	--id 	- arg11	Chat lineID 

	if ZGT_InstanceCheck() then
		local loottype, looter, class = ZGT_ScanLootMSG(msg)
		if looter then
			ZGT_AddLoot(loottype, looter, class)
		end
	end
end

local function ZGT_Event_CHAT_MSG_SYSTEM(msg)
	local w = {}

	for s in string.gfind(msg, "[^%s]+") do
		table.insert(w, s)
	end

	if w[1] == "Welcome" and w[3] == "Zul'Gurub." then
		RequestRaidInfo()
		local frame = getglobal("ZGT_GUI")
		if not frame:IsVisible() then
			frame:Show()
		end
	end
end

local function ZGT_Event_START_LOOT_ROLL(id, time)
	--id 	- arg1	The rollID of the item being rolled on. 
	--time 	- arg2	The roll time. 

	if ZGT_InstanceCheck() then
		ZGT_AutoRoll(id)
	end
end

local function ZGT_Event_ZONE_CHANGED_NEW_AREA()
	local frame = getglobal("ZGT_GUI")
	if ZGT_InstanceCheck() then
		if not frame:IsVisible() then
			frame:Show()
		end
	else
		if frame:IsVisible() then
			frame:Hide()
		end
	end
end

local function ZGT_Event_COMBAT_TEXT_UPDATE(actiontype, faction, reputation)
	if actiontype == "FACTION" and faction == "Zandalar Tribe" then
		ZGTrackerSV.reputation_total = (ZGTrackerSV.reputation_total or 0) + reputation
		local frame = getglobal("ZGT_GUI_ReputationFrame")
		frame.fs_repvalue:SetText(ZGTrackerSV.reputation_total)
	end
end

-- 
-- Addon Main
--
ChatFrame_OnEvent = ZGT_ChatFrame_OnEvent

-- Slash commands
SlashCmdList["ZGTCOMMANDS"] = function(str)
	local args = {}

	for s in string.gfind(str, "[^%s]+") do
		table.insert(args, s)
	end

	local command = args[1]
	

	if command then
		command = string.lower(command)
		if command == "" then
			command = "help"
		end
	else
		command = "help"
	end
	
	if command == "help" then
		ZGT_PrintChat_Help()

	elseif command == "about" then
		ZGT_PrintChat_About()

	elseif command == "toggle" then
		local frame = getglobal("ZGT_GUI")
		if frame:IsVisible() then
			frame:Hide()
		else
			frame:Show()
		end

	elseif command == "reset" then
		if ZGT_RESET_CHECK then ZGT_RESET_CHECK = false end
		local resettime = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
		local dialog = StaticPopup_Show ("ZGT_RESET_DATA_DIALOG", resettime)

	elseif command == "print" then
		local name = args[2]
		if name and name == "all" then
			ZGT_Print_AllData()
		elseif name then
			name = string.upper(string.sub(name, 0, 1)) .. string.lower(string.sub(name, 2))
			ZGT_Print_PlayerData(name)
		else
			ZGT_Print_SummaryData()
		end

	elseif command == "raidannounce" or command == "ra" then
		local name = args[2]
		if name then
			name = string.upper(string.sub(name, 0, 1)) .. string.lower(string.sub(name, 2))
		end
		ZGT_RaidAnnounce(name)

	else
		ZGT_D("unrecognized command")
	end
end

SLASH_ZGTCOMMANDS1 = "/zgt"
SLASH_ZGTCOMMANDS2 = "/zgtracker"

-- Reset "temp-data" Dialog
StaticPopupDialogs["ZGT_RESET_DATA_DIALOG"] = {
	text = "Are you really sure do you want to reset the existing Coins/Bijous counters?\n\nDataset Reset Time: %s",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(data, data2, data3)
		ZGT_ResetData()
		if data and data2 and data3 then
			ZGT_D("data: " .. data .. " - data2: " .. data2 .. " - data3: " .. data3)
			ZGT_AddLoot(data, data2, data3)
		end
	end,
	OnCancel = function()
		ZGT_STATUS("Loot-Data Reset Canceled.")
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = false,
	preferredIndex = 1,
}

-- Function to "scan" reputation gains
--CombatTextSetActiveUnit('player')

-- ZGTracker Control Frame
local coreframe = CreateFrame("Frame", nil)
coreframe:RegisterEvent("ADDON_LOADED")
coreframe:RegisterEvent("VARIABLES_LOADED")
coreframe:RegisterEvent("CHAT_MSG_LOOT")
coreframe:RegisterEvent("CHAT_MSG_MONEY")
coreframe:RegisterEvent("CHAT_MSG_SYSTEM")
coreframe:RegisterEvent("START_LOOT_ROLL")

coreframe:RegisterEvent("ZONE_CHANGED_NEW_AREA")

coreframe:RegisterEvent("COMBAT_TEXT_UPDATE")

coreframe:SetScript("OnEvent", function()
	if event == "CHAT_MSG_MONEY" then
		ZGT_Event_CHAT_MSG_MONEY(arg1)

	elseif event =="COMBAT_TEXT_UPDATE" then
		ZGT_Event_COMBAT_TEXT_UPDATE(arg1, arg2, arg3)

	elseif event == "CHAT_MSG_LOOT" then
		ZGT_Event_CHAT_MSG_LOOT(arg1, arg11)

	elseif event == "START_LOOT_ROLL" then
		ZGT_Event_START_LOOT_ROLL(arg1, arg2)

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		ZGT_Event_ZONE_CHANGED_NEW_AREA()

	elseif event == "CHAT_MSG_SYSTEM" then
		ZGT_Event_CHAT_MSG_SYSTEM(arg1)

	elseif event == "ADDON_LOADED" then
		if (arg1 == "ZGTracker") then
			coreframe:UnregisterEvent("ADDON_LOADED")
			local ZGT_TITLE = GetAddOnMetadata("ZGTracker", "Title")
			local ZGT_VERSION = GetAddOnMetadata("ZGTracker", "Version")
			local ZGT_AUTHOR = GetAddOnMetadata("ZGTracker", "Author")
			DEFAULT_CHAT_FRAME:AddMessage(ZGT_TITLE .. " v" .. ZGT_VERSION .. " by " .."|cffFF0066".. ZGT_AUTHOR .."|cffffffff".. " loaded, type |cff00eeee".." /zgt".."|cffffffff for more info.")
		end

	elseif event == "VARIABLES_LOADED" then

		ZGT_GUI_Init()
		
	end
end)