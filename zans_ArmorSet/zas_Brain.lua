-------------------------------------
	RED = "|cFFFF0000"
	GREEN = "|cFF00FF00"
	BLUE = "|cFFADD8E6"
	YELLOW = "|cFFFFFF00"
	ORANGE = "|cFFFFA500"
	PURPLE = "|cFF800080"
	CYAN = "|cFF00FFFF"
	MAGENTA = "|cFFFF00FF"
	WHITE = "|cFFFFFFFF"
	BLACK = "|cFF000000"
	GRAY = "|cFF808080"
-------------------------------------


function cmdFunc(str)
	if str=="" then
		print(YELLOW.."HELP DESK")
		print(RED.."Save set: |r/za save {name}")
		print(RED.."Load set: |r/za load {name}")
		print(RED.."Delete set: |r/za delete {name} "..YELLOW.."or |r/za remove {name}")
		print(RED.."View armor sets: |r/za list")
		print(BLUE.."Note: addon best used with macros.")
		return
	end
	
	
	local words = {}
    for word in str:gmatch("%S+") do
        table.insert(words, word)
    end

    -- Check for "save" or "load" and extract the third word
    if containsWord(words[1], "save") and words[2] then
        saveArmorSet(words[2])
    elseif containsWord(words[1], "load") and words[2] then
        loadArmorSet(words[2])
	elseif containsWord(words[1], "list") then
		listArmorSets()
    elseif (containsWord(words[1], "delete") or containsWord(words[1], "remove"))and words[2] then
		deleteArmorSet(words[2])
	else
        print("Invalid command")
    end
end

function deleteArmorSet(s_name)
	if zas_ArmorList[UnitName("player")][s_name] then
		zas_ArmorList[UnitName("player")][s_name] = nil
		print("Armor set "..s_name.." has been removed for ".. YELLOW..UnitName("player"))
	end
end

function listArmorSets()
	armorLists = ""
	if not zas_ArmorList[UnitName("player")] then
		print("No armors currently listed.")
		return
	end
	
	for key, _ in pairs(zas_ArmorList[UnitName("player")]) do
		armorLists = key..","..armorLists
	end
	
	lastLt = string.sub(UnitName("player"), -1)
	if(lastLt == "s") then
		print(YELLOW..UnitName("player").."'".."|r armor sets: " .. armorLists)
	else
		print(YELLOW..UnitName("player").."'s".."|r armor sets: " .. armorLists)
	end
end

function saveArmorSet(s_name)
	local characterName = UnitName("player")  -- Get the player's character name

    -- Get the equipped gear IDs
    local gearSet = GetEquippedGearIDs()

    -- If the character doesn't have any gear sets yet, initialize it
    if not zas_ArmorList[characterName] then
        zas_ArmorList[characterName] = {}
    end

    -- Save the gear set under the specified name
    zas_ArmorList[characterName][s_name] = gearSet

    print("Armor set '" .. s_name .. "' saved for " .. YELLOW..characterName)
end

function loadArmorSet(s_name)
    local characterName = UnitName("player")  -- Get the player's character name

    -- Check if the character has the gear set saved
    if zas_ArmorList[characterName] and zas_ArmorList[characterName][s_name] then
        local gearSet = zas_ArmorList[characterName][s_name]

        -- Equip each item in the gear set
        for slotName, itemID in pairs(gearSet) do
            if itemID then
                local slotID = GetInventorySlotInfo(slotName)

                -- Pickup and equip the item for this slot
                EquipItemByName(itemID)
            else
                print(slotName .. " is empty, no item to equip.")
            end
        end
    else
        print("Gear set '" .. s_name .. "' not found for " .. characterName)
    end
end


function GetEquippedGearIDs()
    local slots = {
        "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot",
        "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot",
        "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot",
        "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot"
    }

    local gearIDs = {}  -- Table to store gear IDs from each slot

    for _, slotName in ipairs(slots) do
        local slotID = GetInventorySlotInfo(slotName)
        local itemLink = GetInventoryItemLink("player", slotID)

        if itemLink then
            local itemID = tonumber(string.match(itemLink, "Hitem:(%d+)"))  -- Extract the item ID from the item link
            gearIDs[slotName] = itemID
        else
            gearIDs[slotName] = nil  -- No item in the slot
        end
    end

    return gearIDs
end


function containsWord(s_string, s_word)
    -- Make both strings lowercase for case-insensitive matching
    local lowerString = string.lower(s_string)
    local lowerWord = string.lower(s_word)

    -- Split the string into words
    for word in lowerString:gmatch("%w+") do
        if word == lowerWord then
            return true
        end
    end

    return false
end


SLASH_commands1 = "/za"
SlashCmdList.commands = cmdFunc;



------------------------------------------

	local function OnAddonLoaded(event, addonName, ...)
		-- Check if the loaded addon is your addon
		local str=...

			if not zas_ArmorList then
				zas_ArmorList = {}
			end

	end
	
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnAddonLoaded)