ZGTrackerSV = {
	lootTable = {
		--["Name"] = {
		--	["coin"] = 0
		--	["bijou"] = 0
		--	["frame"] = x
		--},
	},
	bijou_total = 0,
	coin_total = 0,
	looter_count = 0,
	reset_time = "N/A",
	reset_date = "N/A",
	reset_cdate = "N/A",
	details = true,
	auto_roll = "no",
	x_anchor = 200,
	y_anchor = 50,
}

local ZGT_VERSION = 0.02
local ZGT_DEBUG = false

local ZGT_RESET_CHECK = true

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

local function ZGT_PrintChat_Help()
	ZGT_STATUS("Keep track of looted Bijous/Coins inside Zul'Gurub.")
	ZGT_STATUS("The addon works only while in a raid group and inside Zul'Gurub", "                 ")
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
	ZGT_STATUS("Keep track of looted Bijous/Coins inside Zul'Gurub.", ZGT_TITLE .. " - " .. ZGT_VERSION .. " - ")
	ZGT_STATUS(ZGT_AUTHOR, " - Author: ")
	ZGT_STATUS("[" .. ZGT_WEBSITE .. "]", " - Website: ")
end

local function ZGT_ResetData()
	local ldate = date("%A %d %B %Y")
	local lcdate = date("%d/%m/%y")
	local ltime = date("%H:%M")
	local prev_details = nil
	local prev_auto_roll = nil

	if ZGTrackerSV.details == true or ZGTrackerSV.details == false then
		prev_details = ZGTrackerSV.details
	else
		prev_details = true
	end

	if ZGTrackerSV.auto_roll == "no" or ZGTrackerSV.auto_roll == "NEED" or 
		ZGTrackerSV.auto_roll == "Greed" or ZGTrackerSV.auto_roll == "PASS" then
		prev_auto_roll = ZGTrackerSV.auto_roll
	else
		prev_auto_roll = "no"
	end

	ZGTrackerSV = {}
	ZGTrackerSV.bijou_total = 0
	ZGTrackerSV.coin_total = 0
	ZGTrackerSV.looter_count = 0
	ZGTrackerSV.reset_time = ltime
	ZGTrackerSV.reset_date = ldate
	ZGTrackerSV.reset_cdate = lcdate
	ZGTrackerSV.details = prev_details
	ZGTrackerSV.auto_roll = prev_auto_roll
	ZGTrackerSV.lootTable = {}

	ZGT_GUI_Reset_GUI()

	ZGT_STATUS("Loot-Data Reset Successfull. [ " .. lcdate .. " - " .. ltime.. " ]")
end

local function ZGT_AutoRoll(id)
	-- Blizzard uses 0 to pass, 1 to Need an item, 2 to Greed an item
	local roll_value = nil
	if ZGTrackerSV.auto_roll == "NEED" then
		roll_value = 1
	elseif ZGTrackerSV.auto_roll == "GREED" then
		roll_value = 2
	elseif ZGTrackerSV.auto_roll == "PASS" then
		roll_value = 0
	end

	if ZGTrackerSV.auto_roll ~= "no" then
		ZGT_D("ID: " .. id .. " - AutoRoll: " .. ZGTrackerSV.auto_roll .. " - rollval: " .. tostring(roll_value))
		local _, name, _, quality = GetLootRollItemInfo(id);
		if string.find(name ,"Hakkari Bijou") or string.find(name ,"Coin") then
			RollOnLoot(id, roll_value)
			--local _, _, _, hex = GetItemQualityColor(quality)
			--ZGT_STATUS("Autoroll " .. hex .. ZGTrackerSV.auto_roll .. " " .. GetLootRollItemLink(id))
			ZGT_STATUS("Autoroll " .. ZGTrackerSV.auto_roll .. " " .. GetLootRollItemLink(id))
			return
		end	
	end	
end

local function ZGT_ScanLootMSG(msg)
	local w = {}

	for s in string.gfind(msg, "[^%s]+") do
		table.insert(w, s)
	end

	local loottype, looter = nil, nil
	if w[2] == "won:" or w[2] == "receive" or w[2] == "receives" then
		if (string.find(msg,"Coin")) then
			loottype = "coin"
		elseif (string.find(msg,"Bijou")) then
			loottype = "bijou"
		else
			loottype = "other"
			return loottype, looter
		end

		if loottype == "coin" or loottype == "bijou" then
			--looter = string.sub(msg, string.find(msg, "%a+"))
			_, _, looter = string.find(msg, "(%a+)")
			if looter == "You" then
				looter = UnitName('player')
			end
		end
	end

	return loottype, looter
end

local function ZGT_AddLoot(loottype, looter)
	ZGTrackerSV.coin_total = ZGTrackerSV.coin_total or 0
	ZGTrackerSV.bijou_total = ZGTrackerSV.bijou_total or 0
	ZGTrackerSV.looters_count = ZGTrackerSV.looters_count or 0

	if ZGT_RESET_CHECK then
		--ZGT_STATUS("'temp' data already present. Use '/zgt reset temp' to wipe it.")
		ZGT_RESET_CHECK = false

		if (ZGTrackerSV.bijou_total or ZGTrackerSV.coin_total) and (ZGTrackerSV.bijou_total > 0 or ZGTrackerSV.coin_total > 0) then
			local resettime = ZGTrackerSV.reset_cdate .. " - " .. ZGTrackerSV.reset_time
			local dialog = StaticPopup_Show ("ZGT_RESET_DATA_DIALOG", resettime)
			if dialog then
				dialog.data = loottype
				dialog.data2 = looter
			end
			ZGT_STATUS("Friendly Reminder! Use '/zgt reset' to wipe Loot-Dataset!")
		end
	end


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
			ZGTrackerSV.looters_count = ZGTrackerSV.looters_count + 1
			ZGTrackerSV.lootTable[looter] = {}
			ZGTrackerSV.lootTable[looter]["coin"] = 0
			ZGTrackerSV.lootTable[looter]["bijou"] = 0
			ZGTrackerSV.lootTable[looter]["frame"] = ZGTrackerSV.looters_count
			ZGTrackerSV.lootTable[looter][loottype] = ZGTrackerSV.lootTable[looter][loottype] + 1
		end

		ZGT_GUI_Update_InfoLine(nil, true)
		ZGT_GUI_Update_InfoLine(looter, false)
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
		--local str = string.format("-- Bijous: [%3s]   Coins: [%3s]", ZGTrackerSV.bijou_total, ZGTrackerSV.coin_total)
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
		--local str = string.format("--- [%s] loot-data is empty", "Summary")
		--SendChatMessage(str, "RAID", nil, nil)
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

local function ZGT_InstanceCheck()
	local zg = false

	if IsInInstance() then
		local zone = GetZoneText()
		--ZGT_D("Current Zone: " .. zone)
		local zoneR = GetRealZoneText()
		--ZGT_D("Current Real Zone: " .. zoneR)
		if zone == "Zul'Gurub" or zoneR == "Zul'Gurub" then
			zg = true		
		end
	end

	return zg
end

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
			--command = "help"
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
	OnAccept = function(data, data2)
		ZGT_ResetData()
		ZGT_D("Data Reset successful.")
		if data and data2 then
			ZGT_AddLoot(data, data2)
		end
	end,
	OnCancel = function()
		ZGT_D("Data Reset was canceled.")
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = false,
	preferredIndex = 1,
}

-- ZGTracker Control Frame
local coreframe = CreateFrame("Frame", nil)
coreframe:RegisterEvent("ADDON_LOADED")
coreframe:RegisterEvent("VARIABLES_LOADED")
coreframe:RegisterEvent("PLAYER_ENTERING_WORLD")
coreframe:RegisterEvent("CHAT_MSG_LOOT")
coreframe:RegisterEvent("CHAT_MSG_SYSTEM")
coreframe:RegisterEvent("UPDATE_INSTANCE_INFO")
coreframe:RegisterEvent("START_LOOT_ROLL")

coreframe:SetScript("OnEvent", function()
	if event == "CHAT_MSG_LOOT" then
		if ZGT_InstanceCheck() then
			local loottype, looter = ZGT_ScanLootMSG(arg1)
			if looter then
				ZGT_AddLoot(loottype, looter)
			end
		end

	elseif event == "START_LOOT_ROLL" then
		if ZGT_InstanceCheck() then
			ZGT_AutoRoll(arg1)
		end

	elseif event == "UPDATE_INSTANCE_INFO" then
		if ZGT_InstanceCheck() then
			ZGT_D(" We're inside ZG! (event UPDATE_INSTANCE_INFO)")
			local frame = getglobal("ZGT_GUI")
			if not frame:IsVisible() then
				frame:Show()
			end
		else
			ZGT_D(" NOT inside an instance.")
			local frame = getglobal("ZGT_GUI")
			if frame:IsVisible() then
				frame:Hide()
			end
		end

	elseif event == "CHAT_MSG_SYSTEM" then
		--ZGT_D(event .. " - " .. tostring(arg1))
		local args = {}

		for s in string.gfind(arg1, "[^%s]+") do
			table.insert(args, s)
		end

		if args[1] == "Welcome" and args[3] == "Zul'Gurub." then
			RequestRaidInfo()
			local frame = getglobal("ZGT_GUI")
			if not frame:IsVisible() then
				frame:Show()
			end
			if ZGT_InstanceCheck() then
				ZGT_D(" We're inside ZG! (Welcome message)")
			end
		end
		
		if arg1 == "You are now saved to this instance" then
			if ZGT_InstanceCheck() then
				ZGT_D(" You're now saved for Zul'Gurub.")
			end
		end

	--elseif event == "PLAYER_ENTERING_WORLD" then
		--ZGT_D(event)

	

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