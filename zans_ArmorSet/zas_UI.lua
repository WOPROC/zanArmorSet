-- Create the button
local armorButton = CreateFrame("Button", "MyCharacterPanelButton", CharacterFrame, "UIPanelButtonTemplate")

-- Set button properties
armorButton:SetSize(80, 22) -- Width, Height
armorButton:SetText("Armor Sets")
armorButton:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMRIGHT", -40, 60) -- Position relative to CharacterFrame




local zan_ArmorPanel = CreateFrame("Frame", "MyCharacterPanelExtension", CharacterFrame, "BackdropTemplate")

-- Set panel properties
zan_ArmorPanel:SetSize(200, 300) -- Width, Height
zan_ArmorPanel:SetPoint("LEFT", CharacterFrame, "RIGHT", -40, 40) -- Position it to the right of the CharacterFrame
zan_ArmorPanel:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", -- Background texture
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", -- Border texture
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
zan_ArmorPanel:SetBackdropColor(0, 0, 0, 0.8) -- Background color (black with transparency)

zan_ArmorPanel:Hide()

-----------------------------

local scrollFrame = CreateFrame("ScrollFrame", "MyScrollFrame", zan_ArmorPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

-- Create the content inside the scroll frame
local scrollContent = CreateFrame("Frame", "MyScrollContent", scrollFrame)
scrollContent:SetPoint("TOPLEFT")
scrollContent:SetWidth(scrollFrame:GetWidth() - 20) -- Adjust width to fit within the scroll frame
scrollFrame:SetScrollChild(scrollContent)

-- Function to dynamically update content height
local function UpdateContentHeight()
    local totalHeight = 100
    for _, child in ipairs({scrollContent:GetChildren()}) do
        local _, childHeight = child:GetSize()
        totalHeight = totalHeight + (childHeight or 0)
    end
    scrollContent:SetHeight(math.max(totalHeight+30, scrollFrame:GetHeight())) -- Ensure content is at least as tall as the frame
end

textBoxes = {}
--Function to clear out content
function clearContent()
	for _, child in ipairs({scrollContent:GetChildren()}) do
		child:Hide()
		child:SetParent(nil)
	end
	
	for _, text in ipairs(textBoxes) do
		text:Hide()
		text:SetParent(nil)
		textBoxes[text]=nil
	end
	
	UpdateContentHeight()
end

function addContent()
	clearContent()

	if(not zas_ArmorList[UnitName("player")]) then
		zas_ArmorList[UnitName("player")] = {}
	end
	idx=1
	lastPosition = -10
	for key, _ in pairs(zas_ArmorList[UnitName("player")]) do	
		
		local text = scrollContent:CreateFontString("TXT", "OVERLAY", "GameFontNormalLarge")
		text:SetPoint("TOP", scrollContent, "TOP", 0, lastPosition) -- Center the text within the frame
		text:SetText(key) -- Set the text content
		
		table.insert(textBoxes, text)
		
		local saveBtn = CreateFrame("Button", "MyCharacterPanelButton", scrollContent, "UIPanelButtonTemplate")
		saveBtn:SetSize(60,20)
		saveBtn:SetText("Save")
		saveBtn:SetPoint("TOP", scrollContent, "TOP", -30, lastPosition-20)
		
		local loadBtn = CreateFrame("Button", "MyCharacterPanelButton", scrollContent, "UIPanelButtonTemplate")
		loadBtn:SetSize(60,20)
		loadBtn:SetText("Load")
		loadBtn:SetPoint("TOP", scrollContent, "TOP", 40, lastPosition-20)
		
		local helmBox = CreateFrame("CheckButton", "MyCheckbox", scrollContent, "ChatConfigCheckButtonTemplate")
		helmBox:SetPoint("CENTER", scrollContent, "TOP", -30, lastPosition-60) -- Position it in the center of the frame
		helmBox.Text:SetText("Show Helm") -- Text next to the checkbox
		
		local capeBox = CreateFrame("CheckButton", "MyCheckbox", scrollContent, "ChatConfigCheckButtonTemplate")
		capeBox:SetPoint("CENTER", scrollContent, "TOP", -30, lastPosition-75) -- Position it in the center of the frame
		capeBox.Text:SetText("Show Cape") -- Text next to the checkbox
		
		capeBox:SetChecked(zas_ArmorList[UnitName("player")][key]["cape"])
		helmBox:SetChecked(zas_ArmorList[UnitName("player")][key]["hat"])
		------- SCRIPTS ------------
		
		capeBox:SetScript("OnClick", function(self) 
			zas_ArmorList[UnitName("player")][key]["cape"] = self:GetChecked()
		end)
		
		helmBox:SetScript("OnClick", function(self) 
			zas_ArmorList[UnitName("player")][key]["hat"] = self:GetChecked()
		end)
		
		saveBtn:SetScript("OnClick", function(self) 
			saveArmorSet(key)
			zas_ArmorList[UnitName("player")][key]["cape"] = capeBox:GetChecked()
			zas_ArmorList[UnitName("player")][key]["hat"] = helmBox:GetChecked()
			addContent()
		end)
		
		loadBtn:SetScript("OnClick", function(self) 
			loadArmorSet(key)
		end)
		
		idx = idx+1
		lastPosition = lastPosition - 90
	end

end







-------------------------------










-- Ensure the button appears when the character panel is shown
CharacterFrame:HookScript("OnShow", function()
    armorButton:Show()
end)

-- Add a click event handler
armorButton:SetScript("OnClick", function(self, button)
    if(zan_ArmorPanel:IsShown()) then
		zan_ArmorPanel:Hide()
	else
		zan_ArmorPanel:Show()
	end
end)