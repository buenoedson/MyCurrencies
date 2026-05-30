local addonName, ns = ...
local L = MyCurrenciesL

-- --- DADOS PADRÃO ---
local defaults = {
    language = L:GetDefaultLanguageCode(),
    iconSize = 32,
    textSize = 12,
    columns = 10,
    showOnlyResting = false,
    autoFilterRegion = false, 
    visibility = {},
    position = nil,
    customItems = {},       -- Moedas/itens adicionados pelo usuário
    debugMode = false,      -- Modo desenvolvedor: exibe ID do mapa
    debugLogUnmapped = false, -- Log automático de mapas não mapeados
}

-- ============================================================================
-- MODO DEBUG / DESENVOLVEDOR
-- ============================================================================
local debugFrame = nil
local function CreateDebugFrame()
    if debugFrame then return end
        debugFrame = CreateFrame("Frame", nil, UIParent)
        debugFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -200)
        debugFrame:SetSize(300, 50)
        debugFrame:Hide()
        -- Torna o debugFrame arrastável, mas preso à tela
        debugFrame:SetMovable(true)
        debugFrame:EnableMouse(true)
        debugFrame:SetClampedToScreen(true)
        debugFrame:RegisterForDrag("LeftButton")
        debugFrame:SetScript("OnDragStart", debugFrame.StartMoving)
        debugFrame:SetScript("OnDragStop", debugFrame.StopMovingOrSizing)

    debugFrame.bg = debugFrame:CreateTexture(nil, "BACKGROUND")
    debugFrame.bg:SetAllPoints(true)
    debugFrame.bg:SetColorTexture(0, 0, 0, 0.7)

    debugFrame.text = debugFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    debugFrame.text:SetAllPoints(true)
    debugFrame.text:SetJustifyH("LEFT")
    debugFrame.text:SetText("")
end

local function GetMapHierarchyString(mapID)
    if not mapID or mapID <= 0 then return "" end
    local parts = {}
    local current = mapID
    local visited = {}
    while current and current > 0 and not visited[current] do
        visited[current] = true
        local info = C_Map.GetMapInfo(current)
        local name = info and info.name or "Unknown"
        local exp = ns.mapToExpansions[current] and (" [|cFF00FF00" .. ns.mapToExpansions[current] .. "|r]") or " [|cFFFF6B6BNONE|r]"
        table.insert(parts, 1, current .. ": " .. name .. exp)
        if info and info.parentMapID and info.parentMapID > 0 then
            current = info.parentMapID
        else
            break
        end
    end
    return table.concat(parts, "\n")
end

local function LogUnmappedMap(mapID)
    if not MyCurrenciesDB or not MyCurrenciesDB.debugLogUnmapped then return end
    if not mapID or mapID <= 0 then return end
    -- Verifica se já foi logado nesta sessão
    if not MyCurrenciesDB._loggedMaps then MyCurrenciesDB._loggedMaps = {} end
    if MyCurrenciesDB._loggedMaps[mapID] then return end
    MyCurrenciesDB._loggedMaps[mapID] = true

    local info = C_Map.GetMapInfo(mapID)
    local name = info and info.name or "Unknown"
    local parentID = info and info.parentMapID or "N/A"
    local parentInfo = info and info.parentMapID and C_Map.GetMapInfo(info.parentMapID)
    local parentName = parentInfo and parentInfo.name or "N/A"

    print("|cFFFFD100[My Currencies - DEBUG]|r")
    print("  Mapa nao mapeado encontrado!")
    print("  ID: " .. mapID .. " | Nome: " .. name)
    print("  Pai ID: " .. tostring(parentID) .. " | Pai Nome: " .. parentName)
    print("  Para adicionar ao MapData.lua, insira:")
    print("  |cFF00FF00[" .. mapID .. "] = \"<EXPANSAO>\", -- " .. name .. "|r")
end

-- Verifica se está em mapa não mapeado a cada troca de zona
local function CheckDebugOnZoneChange()
    local mapID = C_Map.GetBestMapForUnit("player")
    local exp = ns.GetExpansionByMapID(mapID)
    if not exp then
        LogUnmappedMap(mapID)
    end
end

local function UpdateDebugDisplay()
    if not MyCurrenciesDB or not MyCurrenciesDB.debugMode then
        if debugFrame then debugFrame:Hide() end
        return
    end
    
    -- Cria o debug frame sob demanda se ainda não existir
    CreateDebugFrame()
    
    if not debugFrame then return end
    
    local mapID = C_Map.GetBestMapForUnit("player")
    local exp = ns.GetExpansionByMapID(mapID)
    local expColor = exp and "|cFF00FF00" or "|cFFFF6B6B"
    local expText = exp or "NAO MAPEADO!"
    
    local info = C_Map.GetMapInfo(mapID)
    local mapName = info and info.name or "Unknown"
    
    local text = "Mapa ID: |cFF00CCFF" .. mapID .. "|r (|cFFCCCCCC" .. mapName .. "|r)\n"
    text = text .. "Expansao: " .. expColor .. expText .. "|r"
    
    -- Mostra hierarquia completa no tooltip
    debugFrame:SetScript("OnEnter", function()
        if not MyCurrenciesDB.debugMode then return end
        GameTooltip:SetOwner(debugFrame, "ANCHOR_RIGHT")
        GameTooltip:AddLine("|cFFFFD100Hierarquia de Mapas:")
        local hierarchy = GetMapHierarchyString(mapID)
        for line in string.gmatch(hierarchy, "[^\n]+") do
            GameTooltip:AddLine(line, 1, 1, 1, true)
        end
        GameTooltip:Show()
    end)
    debugFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    debugFrame.text:SetText(text)
    debugFrame:Show()
    
    -- Ajusta altura do frame debug
    debugFrame:SetHeight(debugFrame.text:GetStringHeight() + 6)
end

local function GetCurrentExpansionCategory()
    local mapID = C_Map.GetBestMapForUnit("player")
    local exp = ns.GetExpansionByMapID(mapID)
    return exp or "The War Within"
end

local trackedData = {}

-- ============================================================================
-- CARREGA MOEDAS CUSTOMIZADAS DO USUÁRIO
-- ============================================================================
local function LoadCustomItems()
    if not MyCurrenciesDB.customItems then return end
    
    for _, item in ipairs(MyCurrenciesDB.customItems) do
        if item.id and item.cat then
            table.insert(trackedData, {
                cat = item.cat,
                type = item.type or 'item',
                id = item.id,
                name = item.name or "Custom Item",
                custom = true
            })
        end
    end
end

-- ============================================================================
-- SCANNER DINÂMICO DE MOEDAS COM SUPORTE A SUBCATEGORIAS
-- ============================================================================
local function LoadGameCurrencies()
    trackedData = {}
    local finalData = {}
    local foundIDs = {}
    
    local manualData = {
        -- ITENS E MOEDAS OCULTAS - MIDNIGHT
        { cat = L:S("MIDNIGHT") .. " - " .. L:S("HIDDEN_CURRENCY"), type = 'currency', id = 3378, name = "Dawnlight Manaflux" },
        { cat = L:S("MIDNIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 246951, name = "Stormarion Core" },
        
        -- The War Within - Itens
        { cat = L:S("THE_WAR_WITHIN") .. " - " .. L:S("ITEMS"), type = 'item', id = 210814, name = "Artisan's Acuity" },
        { cat = L:S("THE_WAR_WITHIN") .. " - " .. L:S("ITEMS"), type = 'item', id = 245653, name = "Coffer Key Shard", threshold = 100 }, 
        { cat = L:S("THE_WAR_WITHIN") .. " - " .. L:S("ITEMS"), type = 'item', id = 234741, name = "Miscellaneous Mechanica" },
        { cat = L:S("THE_WAR_WITHIN") .. " - " .. L:S("ITEMS"), type = 'item', id = 212493, name = "Odd Glob of Wax" },
        { cat = L:S("THE_WAR_WITHIN") .. " - " .. L:S("ITEMS"), type = 'item', id = 206350, name = "Radiant Remnant" },
        { cat = L:S("THE_WAR_WITHIN") .. " - " .. L:S("ITEMS"), type = 'item', id = 225557, name = "Sizzling Cinderpollen" },
        { cat = L:S("THE_WAR_WITHIN") .. " - " .. L:S("HIDDEN_CURRENCY"), type = 'currency', id = 3269, name = "Ethereal Voidsplinter" },
        
        -- Dragonflight - Itens
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 204988, name = "Barter Brick" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 205984, name = "Barter Boulder" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 199198, name = "Centaur Hunting Trophy" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 202058, name = "Copper Coin of the Isles" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 202102, name = "Coveted Bauble" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 204726, name = "Dormant Primordial Fragment" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 190453, name = "Dragon Isles Artifact" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 208151, name = "Dreamsurge Coalescence" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 205246, name = "Essence of The Storm" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 208066, name = "Gigantic Dreamseed" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 202059, name = "Gold Coin of the Isles" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 191264, name = "Greater Obsidian Key" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 193201, name = "Key Fragments" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 191251, name = "Key Framing" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 190330, name = "Mark of Sargha" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 199066, name = "Magmote" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 208067, name = "Plump Dreamseed" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 191263, name = "Restored Obsidian Key" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 199906, name = "Sacred Tuskarr Totem" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 190328, name = "Sargha's Signet" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 210986, name = "Seedbloom" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 202060, name = "Silver Coin of the Isles" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 208047, name = "Small Dreamseed" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 199905, name = "Titan Relic" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 202196, name = "Unearthed Fragrant Coin" },
        { cat = L:S("DRAGONFLIGHT") .. " - " .. L:S("ITEMS"), type = 'item', id = 203422, name = "Zskera Vault Key" },

        -- ITENS - SHADOWLANDS E ANTIGOS
        { cat = L:S("ANCIENT_ITEMS"), type = 'item', id = 187440, name = "Attendant's Token of Merit" },
        { cat = L:S("ANCIENT_ITEMS"), type = 'item', id = 188657, name = "Genesis Mote" },
        { cat = L:S("ANCIENT_ITEMS"), type = 'item', id = 188959, name = "Sandworn Relic" },
        { cat = L:S("ANCIENT_ITEMS"), type = 'item', id = 21100, name = "Coin of Ancestry" },
        { cat = L:S("ANCIENT_ITEMS"), type = 'item', id = 116035, name = "Darkmoon Game Token" },
        { cat = L:S("ANCIENT_ITEMS"), type = 'item', id = 49927, name = "Love Token" }
    }

    for _, mData in ipairs(manualData) do
        table.insert(finalData, {
            cat = mData.cat,
            type = mData.type,
            id = mData.id,
            name = mData.name,
            threshold = mData.threshold
        })
        if mData.type == "currency" then foundIDs[mData.id] = true end
    end

    local collapsedHeaders = {}
    local i = 1
    
    while i <= C_CurrencyInfo.GetCurrencyListSize() do
        local info = C_CurrencyInfo.GetCurrencyListInfo(i)
        if info.isHeader and not info.isExpanded then
            collapsedHeaders[info.name] = true
            C_CurrencyInfo.ExpandCurrencyList(i, true)
        end
        i = i + 1
    end
    
    i = 1
    local currentMainCat = "Moedas"
    local currentCat = "Moedas"
    
    while i <= C_CurrencyInfo.GetCurrencyListSize() do
        local info = C_CurrencyInfo.GetCurrencyListInfo(i)
        if info.isHeader then
            local lowerName = string.lower(info.name)
            -- Detecta se o cabeçalho atual é uma subcategoria (Season/Temporada)
            if string.find(lowerName, "season") or string.find(lowerName, "temporada") or string.find(lowerName, "série") then
                currentCat = currentMainCat .. " - " .. info.name
            else
                currentMainCat = info.name
                currentCat = info.name
            end
        else
            local link = C_CurrencyInfo.GetCurrencyListLink(i)
            if link then
                local currencyID = C_CurrencyInfo.GetCurrencyIDFromLink(link)
                if currencyID and not foundIDs[currencyID] then
                    table.insert(finalData, {
                        cat = currentCat,
                        type = 'currency',
                        id = currencyID,
                        name = info.name
                    })
                    foundIDs[currencyID] = true
                end
            end
        end
        i = i + 1
    end
    
    i = 1
    while i <= C_CurrencyInfo.GetCurrencyListSize() do
        local info = C_CurrencyInfo.GetCurrencyListInfo(i)
        if info.isHeader and collapsedHeaders[info.name] then
            C_CurrencyInfo.ExpandCurrencyList(i, false)
        end
        i = i + 1
    end
    
    trackedData = finalData
    LoadCustomItems()  -- Carrega moedas customizadas
end

-- ============================================================================
-- LÓGICA DA INTERFACE
-- ============================================================================
local f = CreateFrame("Frame", "MyCurrenciesFrame", UIParent)
f:SetSize(400, 200)
f:SetPoint("CENTER")
f:SetMovable(true)
f:EnableMouse(true)
f:SetClampedToScreen(true) 
f:RegisterForDrag("LeftButton")

local function OnDragStopHandler(self)
    f:StopMovingOrSizing()
    local point, _, relativePoint, x, y = f:GetPoint()
    if MyCurrenciesDB then
        MyCurrenciesDB.position = { point = point, relativePoint = relativePoint, x = x, y = y }
    end
end

f:SetScript("OnDragStart", f.StartMoving)
f:SetScript("OnDragStop", OnDragStopHandler)

f:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" then
        if Settings and Settings.OpenToCategory then
            if MyCurrenciesOptions and MyCurrenciesOptions.category then
                Settings.OpenToCategory(MyCurrenciesOptions.category:GetID())
            else
                Settings.OpenToCategory("My Currencies")
            end
        else
            InterfaceOptionsFrame_OpenToCategory("My Currencies")
        end
    end
end)

f.bg = f:CreateTexture(nil, "BACKGROUND")
f.bg:SetAllPoints(true)
f.bg:SetColorTexture(0, 0, 0, 0)
f:SetScript("OnEnter", function() f.bg:SetColorTexture(0,0,0,0.3) end)
f:SetScript("OnLeave", function() f.bg:SetColorTexture(0,0,0,0) end)

local frames = {}
local optionCheckboxes = {}

local function UpdateLocalizedNames()
    for i, data in ipairs(trackedData) do
        local name
        if data.type == "currency" then
            local info = C_CurrencyInfo.GetBasicCurrencyInfo(data.id)
            if info and info.name then name = info.name end
        elseif data.type == "item" then
            name = C_Item.GetItemInfo(data.id)
            if not name then C_Item.RequestLoadItemDataByID(data.id) end
        end
        if name then
            data.name = name
            if optionCheckboxes[i] then optionCheckboxes[i].text:SetText(name) end
        end
    end
end

local function CreateIconFrame(index)
    local icon = CreateFrame("Frame", nil, f)
    icon:EnableMouse(true) 
    icon:RegisterForDrag("LeftButton")
    
    icon:SetScript("OnDragStart", function() f:StartMoving() end)
    icon:SetScript("OnDragStop", OnDragStopHandler)
    
    icon:SetScript("OnMouseUp", function(self, button)
        if button == "RightButton" then
            if Settings and Settings.OpenToCategory then
                if MyCurrenciesOptions and MyCurrenciesOptions.category then
                    Settings.OpenToCategory(MyCurrenciesOptions.category:GetID())
                else
                    Settings.OpenToCategory("My Currencies")
                end
            else
                InterfaceOptionsFrame_OpenToCategory("My Currencies")
            end
        end
    end)
    
    icon.tex = icon:CreateTexture(nil, "ARTWORK")
    icon.tex:SetAllPoints(true)
    icon.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    
    icon.glow = icon:CreateTexture(nil, "OVERLAY")
    icon.glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    icon.glow:SetPoint("CENTER")
    icon.glow:SetBlendMode("ADD")
    icon.glow:SetVertexColor(1, 0.82, 0, 1) 
    icon.glow:Hide()
    
    icon.glow.anim = icon.glow:CreateAnimationGroup()
    icon.glow.anim:SetLooping("REPEAT")
    
    local fadeOut = icon.glow.anim:CreateAnimation("Alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0.2)
    fadeOut:SetDuration(0.8)
    fadeOut:SetSmoothing("IN_OUT")
    fadeOut:SetOrder(1)
    
    local fadeIn = icon.glow.anim:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0.2)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.8)
    fadeIn:SetSmoothing("IN_OUT")
    fadeIn:SetOrder(2)
    
    icon.text = icon:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallOutline")
    icon.text:SetPoint("BOTTOMRIGHT", 2, -2)
    icon.text:SetTextColor(1, 1, 1)
    
    icon:SetScript("OnEnter", function(self)
        f.bg:SetColorTexture(0,0,0,0.3)
        if not self.data then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.data.type == "item" then
            GameTooltip:SetItemByID(self.data.id)
        else
            GameTooltip:SetCurrencyByID(self.data.id)
        end
        GameTooltip:Show()
    end)
    
    icon:SetScript("OnLeave", function() 
        f.bg:SetColorTexture(0,0,0,0) 
        GameTooltip:Hide() 
    end)
    
    return icon
end

local function UpdateDisplay()
    if not MyCurrenciesDB then return end
    local db = MyCurrenciesDB
    
    if db.showOnlyResting and not IsResting() then
        f:Hide()
        return
    end
    
    local visibleCount = 0
    local PADDING = 5
    local STANDARD_TEXT_FONT = GameFontHighlightSmallOutline:GetFont()
    local currentExp = GetCurrentExpansionCategory()
    
    for i, data in ipairs(trackedData) do
        local count = 0
        local iconPath = nil
        local show = false
        
        local isEnabled = db.visibility[data.id]
        if isEnabled == nil then isEnabled = true end 
        
        if db.autoFilterRegion and data.cat then
            local isCurrentExp = string.find(data.cat, currentExp)
            local catL = string.lower(data.cat)
            -- Atualizado para nunca esconder masmorras/raides/miscellaneous
            local isMisc = string.find(catL, "miscellaneous") or string.find(catL, "diversos") 
                        or string.find(catL, "antigos") or string.find(catL, string.lower(L:S("ANCIENT_ITEMS") or "")) or string.find(catL, "player vs. player") 
                        or string.find(catL, "jogador") or string.find(catL, "dungeon") 
                        or string.find(catL, "masmorra") or string.find(catL, "raid")
            
            if not (isCurrentExp or isMisc) then
                isEnabled = false
            end
        end
        
        if isEnabled then
            if data.type == "currency" then
                local info = C_CurrencyInfo.GetCurrencyInfo(data.id)
                if info then
                    count = info.quantity
                    iconPath = info.iconFileID
                    if info.discovered and count > 0 then show = true end
                end
            elseif data.type == "item" then
                count = C_Item.GetItemCount(data.id, true, false, true)
                if count > 0 then
                    show = true
                    iconPath = C_Item.GetItemIconByID(data.id)
                end
            end
        end
        
        if show then
            visibleCount = visibleCount + 1
            if not frames[visibleCount] then frames[visibleCount] = CreateIconFrame(visibleCount) end
            local frame = frames[visibleCount]
            frame:Show()
            frame:SetSize(db.iconSize, db.iconSize)
            frame.tex:SetTexture(iconPath)
            
            frame.text:SetFont(STANDARD_TEXT_FONT, db.textSize, "OUTLINE")
            frame.text:SetText(count)
            
            local iconWidth = frame:GetWidth()
            local textWidth = frame.text:GetStringWidth()
            if textWidth > (iconWidth + 2) then
                local ratio = iconWidth / textWidth
                local newSize = math.floor(db.textSize * ratio)
                if newSize < 8 then newSize = 8 end
                frame.text:SetFont(STANDARD_TEXT_FONT, newSize, "OUTLINE")
            end
            
            frame.data = data
            
            if data.threshold and count >= data.threshold then
                frame.glow:SetSize(db.iconSize * 1.7, db.iconSize * 1.7)
                frame.glow:Show()
                frame.glow.anim:Play()
            else
                frame.glow.anim:Stop()
                frame.glow:Hide()
            end
            
            local col = (visibleCount - 1) % db.columns
            local row = math.floor((visibleCount - 1) / db.columns)
            frame:SetPoint("TOPLEFT", col * (db.iconSize + PADDING), -row * (db.iconSize + PADDING))
        end
    end
    
    for i = visibleCount + 1, #frames do 
        frames[i]:Hide() 
        frames[i].glow.anim:Stop()
        frames[i].glow:Hide()
    end
    
        if visibleCount > 0 then
        f:Show()
        local rows = math.ceil(visibleCount / db.columns)
        if rows == 0 then rows = 1 end
        local width = db.columns * (db.iconSize + PADDING)
        local height = rows * (db.iconSize + PADDING)
        f:SetSize(math.max(50, width), math.max(50, height))
    else
        f:Hide()
    end
    
    -- Atualiza debug display (se ativado)
    UpdateDebugDisplay()
end

local optionsPanel
local scrollChild
local catCheckboxes = {}
local removeButtons = {}

local function UpdateOptionsList(filterText)
    if not scrollChild then return end
    filterText = filterText and string.lower(filterText) or ""
    
    for _, cb in ipairs(optionCheckboxes) do cb:Hide() end
    for _, cb in ipairs(catCheckboxes) do cb:Hide() end
    for _, btn in pairs(removeButtons) do btn:Hide() end
    
    local yOffset = -35
    local lastCategory = ""
    local catIndex = 1
    
    local visibleIndices = {}
    for i, data in ipairs(trackedData) do
        local match = filterText == "" or string.find(string.lower(data.name or ""), filterText, 1, true) or string.find(string.lower(data.cat or ""), filterText, 1, true)
        if match then visibleIndices[i] = true end
    end

    for i, data in ipairs(trackedData) do
        if visibleIndices[i] then
            if data.cat ~= lastCategory then
                yOffset = yOffset - 10
                local catHeaderCB = catCheckboxes[catIndex]
                if not catHeaderCB then
                    catHeaderCB = CreateFrame("CheckButton", nil, scrollChild, "UICheckButtonTemplate")
                    catCheckboxes[catIndex] = catHeaderCB
                end
                catHeaderCB:ClearAllPoints()
                catHeaderCB:SetPoint("TOPLEFT", 0, yOffset)
                catHeaderCB.text:SetText("|cFFFFD100" .. data.cat .. "|r")
                catHeaderCB:SetChecked(true)
                catHeaderCB:Show()
                
                local targetCat = data.cat
                catHeaderCB:SetScript("OnClick", function(self)
                    local state = self:GetChecked()
                    for k, v in ipairs(trackedData) do
                        if v.cat == targetCat then
                            MyCurrenciesDB.visibility[v.id] = state
                            if optionCheckboxes[k] then optionCheckboxes[k]:SetChecked(state) end
                        end
                    end
                    UpdateDisplay()
                end)
                yOffset = yOffset - 25
                lastCategory = data.cat
                catIndex = catIndex + 1
            end
        
            local cb = optionCheckboxes[i]
            if not cb then
                cb = CreateFrame("CheckButton", nil, scrollChild, "UICheckButtonTemplate")
                optionCheckboxes[i] = cb
            end
            cb:ClearAllPoints()
            cb:SetPoint("TOPLEFT", 20, yOffset)
            cb.text:SetText(data.name)
            cb:Show()
            
            if MyCurrenciesDB.visibility[data.id] == nil then cb:SetChecked(true)
            else cb:SetChecked(MyCurrenciesDB.visibility[data.id]) end
            
            cb:SetScript("OnClick", function(self) MyCurrenciesDB.visibility[data.id] = self:GetChecked() UpdateDisplay() end)
            
            if data.custom then
                local delBtn = removeButtons[i]
                if not delBtn then
                    delBtn = CreateFrame("Button", nil, scrollChild, "UIPanelCloseButton")
                    delBtn:SetSize(24, 24)
                    removeButtons[i] = delBtn
                end
                delBtn:ClearAllPoints()
                delBtn:SetPoint("LEFT", cb.text, "RIGHT", 5, 0)
                delBtn:Show()
                
                delBtn:SetScript("OnClick", function()
                    for idx, customItem in ipairs(MyCurrenciesDB.customItems) do
                        if customItem.id == data.id then
                            table.remove(MyCurrenciesDB.customItems, idx)
                            break
                        end
                    end
                    LoadGameCurrencies()
                    UpdateLocalizedNames()
                    UpdateOptionsList(MC_SearchBox and MC_SearchBox:GetText() or "")
                    UpdateDisplay()
                    print("|cFFFF6B6B" .. (L:S("REMOVED") or "Removed:") .. " " .. data.name .. "|r")
                end)
            end
            
            yOffset = yOffset - 25
        end
    end
    scrollChild:SetHeight(math.abs(yOffset) + 20)
end

local function GetCategoryList()
    local uniqueCategories = {}
    local categoriesList = {}
    for _, data in ipairs(trackedData) do
        if data.cat and not uniqueCategories[data.cat] then
            uniqueCategories[data.cat] = true
            table.insert(categoriesList, data.cat)
        end
    end
    table.sort(categoriesList)
    return categoriesList
end

local function CreateOptionsPanel()
    if optionsPanel then return end
    local panel = CreateFrame("Frame", "MyCurrenciesOptions", UIParent)
    optionsPanel = panel
    panel.name = "My Currencies"
    
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(L:S("ADDON_TITLE"))

    -- Language dropdown
    local languageLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    languageLabel:SetPoint("TOPLEFT", 20, -50)
    languageLabel:SetText(L:S("LANGUAGE") .. ":")
    
    local langDropdown = CreateFrame("Frame", "MC_LanguageDropdown", panel, "UIDropDownMenuTemplate")
    langDropdown:SetPoint("TOPLEFT", 20, -70)
    
    local langOptions = L:GetAvailableLanguages()
    local function InitializeLanguageDropdown(frame, level)
        for _, langOption in ipairs(langOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = langOption.name
            info.value = langOption.code
            info.func = function(self)
                MyCurrenciesDB.language = self.value
                UIDropDownMenu_SetSelectedValue(langDropdown, self.value)
                -- Aviso para recarregar a interface
                print("|cFFFFD100My Currencies:|r |cFF00FF00" .. (L:S("RELOAD_REQUIRED") or "Please type /reload to apply language changes.") .. "|r")
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    
    UIDropDownMenu_Initialize(langDropdown, InitializeLanguageDropdown)
    UIDropDownMenu_SetSelectedValue(langDropdown, MyCurrenciesDB.language or L:GetDefaultLanguageCode())

    local sliderIcon = CreateFrame("Slider", "MC_IconSizeSlider", panel, "OptionsSliderTemplate")
    sliderIcon:SetPoint("TOPLEFT", 20, -120)
    sliderIcon:SetMinMaxValues(16, 64)
    sliderIcon:SetValueStep(2)
    sliderIcon:SetObeyStepOnDrag(true)
    sliderIcon:SetValue(MyCurrenciesDB.iconSize)
    _G[sliderIcon:GetName() .. "Low"]:SetText("16")
    _G[sliderIcon:GetName() .. "High"]:SetText("64")
    _G[sliderIcon:GetName() .. "Text"]:SetText(L:S("ICON_SIZE"))
    
    local inputIcon = CreateFrame("EditBox", "MC_IconSizeInput", panel, "InputBoxTemplate")
    inputIcon:SetPoint("LEFT", sliderIcon, "RIGHT", 15, 0)
    inputIcon:SetSize(40, 20)
    inputIcon:SetAutoFocus(false)
    inputIcon:SetNumeric(true)
    inputIcon:SetText(math.floor(MyCurrenciesDB.iconSize))
    inputIcon:SetScript("OnEnterPressed", function(self)
        local val = tonumber(self:GetText()) or 32
        if val < 16 then val = 16 elseif val > 64 then val = 64 end
        self:SetText(math.floor(val))
        sliderIcon:SetValue(val)
        self:ClearFocus()
    end)
    inputIcon:SetScript("OnEscapePressed", function(self)
        self:SetText(math.floor(sliderIcon:GetValue()))
        self:ClearFocus()
    end)
    
    sliderIcon:SetScript("OnValueChanged", function(self, value) 
        MyCurrenciesDB.iconSize = value 
        inputIcon:SetText(math.floor(value))
        UpdateDisplay() 
    end)

    local sliderText = CreateFrame("Slider", "MC_TextSizeSlider", panel, "OptionsSliderTemplate")
    sliderText:SetPoint("TOPLEFT", 250, -120)
    sliderText:SetMinMaxValues(8, 24)
    sliderText:SetValueStep(1)
    sliderText:SetObeyStepOnDrag(true)
    sliderText:SetValue(MyCurrenciesDB.textSize)
    _G[sliderText:GetName() .. "Low"]:SetText("8")
    _G[sliderText:GetName() .. "High"]:SetText("24")
    _G[sliderText:GetName() .. "Text"]:SetText(L:S("TEXT_SIZE"))
    
    local inputText = CreateFrame("EditBox", "MC_TextSizeInput", panel, "InputBoxTemplate")
    inputText:SetPoint("LEFT", sliderText, "RIGHT", 15, 0)
    inputText:SetSize(40, 20)
    inputText:SetAutoFocus(false)
    inputText:SetNumeric(true)
    inputText:SetText(math.floor(MyCurrenciesDB.textSize))
    inputText:SetScript("OnEnterPressed", function(self)
        local val = tonumber(self:GetText()) or 12
        if val < 8 then val = 8 elseif val > 24 then val = 24 end
        self:SetText(math.floor(val))
        sliderText:SetValue(val)
        self:ClearFocus()
    end)
    inputText:SetScript("OnEscapePressed", function(self)
        self:SetText(math.floor(sliderText:GetValue()))
        self:ClearFocus()
    end)
    
    sliderText:SetScript("OnValueChanged", function(self, value) 
        MyCurrenciesDB.textSize = value 
        inputText:SetText(math.floor(value))
        UpdateDisplay() 
    end)
    
    local cbRest = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    cbRest:SetPoint("TOPLEFT", 20, -160)
    cbRest.text:SetText(L:S("SHOW_ONLY_RESTING"))
    cbRest:SetChecked(MyCurrenciesDB.showOnlyResting)
    cbRest:SetScript("OnClick", function(self) MyCurrenciesDB.showOnlyResting = self:GetChecked() UpdateDisplay() end)

        local cbRegion = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    cbRegion:SetPoint("TOPLEFT", 20, -185)
    cbRegion.text:SetText(L:S("SHOW_ONLY_EXPANSION"))
    cbRegion:SetChecked(MyCurrenciesDB.autoFilterRegion)
    cbRegion:SetScript("OnClick", function(self) MyCurrenciesDB.autoFilterRegion = self:GetChecked() UpdateDisplay() end)

    -- ========== SEÇÃO DEBUG / DESENVOLVEDOR ==========
    local debugLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    debugLabel:SetPoint("TOPLEFT", 16, -210)
    debugLabel:SetText(L:S("DEBUG_TITLE") or "Developer / Debug")

    local cbDebugMode = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    cbDebugMode:SetPoint("TOPLEFT", 20, -235)
    cbDebugMode.text:SetText(L:S("DEBUG_MODE") or "Debug Mode (show map ID & expansion)")
    cbDebugMode:SetChecked(MyCurrenciesDB.debugMode)
        cbDebugMode:SetScript("OnClick", function(self)
        MyCurrenciesDB.debugMode = self:GetChecked()
        UpdateDisplay()
    end)

    local cbDebugLog = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    cbDebugLog:SetPoint("TOPLEFT", 20, -260)
    cbDebugLog.text:SetText(L:S("DEBUG_LOG_UNMAPPED") or "Log unmapped maps to chat")
    cbDebugLog:SetChecked(MyCurrenciesDB.debugLogUnmapped)
    cbDebugLog:SetScript("OnClick", function(self)
        MyCurrenciesDB.debugLogUnmapped = self:GetChecked()
        if not MyCurrenciesDB._loggedMaps then MyCurrenciesDB._loggedMaps = {} end
    end)

    -- Botão para mostrar mapa atual no chat
    local btnShowMap = CreateFrame("Button", nil, panel, "GameMenuButtonTemplate")
    btnShowMap:SetPoint("TOPLEFT", 20, -285)
    btnShowMap:SetSize(200, 22)
    btnShowMap:SetText(L:S("DEBUG_SHOW_MAP") or "Show Current Map Info")
    btnShowMap:SetScript("OnClick", function()
        local mapID = C_Map.GetBestMapForUnit("player")
        local info = C_Map.GetMapInfo(mapID)
        local name = info and info.name or "Unknown"
        local parentID = info and info.parentMapID or "N/A"
        local parentInfo = info and info.parentMapID and C_Map.GetMapInfo(info.parentMapID)
        local parentName = parentInfo and parentInfo.name or "N/A"
        local exp = ns.GetExpansionByMapID(mapID)
        local expText = exp or "|cFFFF6B6BNOT MAPPED|r"

        print("|cFFFFD100==== Current Map Info ====|r")
        print("Map ID: |cFF00CCFF" .. mapID .. "|r")
        print("Name: |cFFCCCCCC" .. name .. "|r")
        print("Parent ID: " .. tostring(parentID) .. " | Parent Name: " .. parentName)
        print("Expansion: " .. expText)
        print("|cFFFFD100============================|r")
        if not exp then
            print("|cFFFF6B6BSuggestion:|r Add this to MapData.lua:")
            print("|cFF00FF00[" .. mapID .. "] = \"<EXPANSAO>\", -- " .. name .. "|r")
        end
    end)

    -- Botão para mostrar hierarquia completa
    local btnShowHierarchy = CreateFrame("Button", nil, panel, "GameMenuButtonTemplate")
    btnShowHierarchy:SetPoint("TOPLEFT", 230, -285)
    btnShowHierarchy:SetSize(200, 22)
    btnShowHierarchy:SetText(L:S("DEBUG_SHOW_HIERARCHY") or "Show Map Hierarchy")
    btnShowHierarchy:SetScript("OnClick", function()
        local mapID = C_Map.GetBestMapForUnit("player")
        local hierarchy = GetMapHierarchyString(mapID)
        print("|cFFFFD100==== Map Hierarchy ====|r")
        for line in string.gmatch(hierarchy, "[^\n]+") do
            print(line)
        end
        print("|cFFFFD100========================|r")
    end)

    -- Linha separadora
    local separator = panel:CreateTexture(nil, "ARTWORK")
    separator:SetColorTexture(1, 1, 1, 0.3)
    separator:SetPoint("TOPLEFT", 16, -310)
    separator:SetPoint("TOPRIGHT", -16, -310)
    separator:SetHeight(1)

        -- ========== SEÇÃO ADICIONAR MOEDA/ITEM CUSTOMIZADO ==========
    local customLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    customLabel:SetPoint("TOPLEFT", 16, -330)
    customLabel:SetText(L:S("ADD_CUSTOM_TITLE") or "Add Custom Currency/Item")

    -- ID Input
    local idLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    idLabel:SetPoint("TOPLEFT", 20, -355)
    idLabel:SetText((L:S("ID") or "ID") .. ":")
    
    local idInput = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    idInput:SetPoint("TOPLEFT", 45, -355)
    idInput:SetSize(80, 24)
    idInput:SetAutoFocus(false)
    idInput:SetMaxLetters(50)
    idInput:SetText("")

    -- Category Dropdown
    local catLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    catLabel:SetPoint("TOPLEFT", 140, -355)
    catLabel:SetText((L:S("CATEGORY") or "Category") .. ":")
    
    local catDropdown = CreateFrame("Frame", "MC_CategoryDropdown", panel, "UIDropDownMenuTemplate")
    catDropdown:SetPoint("TOPLEFT", 195, -350)
    UIDropDownMenu_SetWidth(catDropdown, 140)
    
    local function InitializeCategoryDropdown(frame, level)
        local categoriesList = GetCategoryList()
        for _, catName in ipairs(categoriesList) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = catName
            info.value = catName
            info.func = function(self)
                UIDropDownMenu_SetSelectedValue(catDropdown, self.value)
                UIDropDownMenu_SetText(catDropdown, self.value)
            end
            info.checked = (UIDropDownMenu_GetSelectedValue(catDropdown) == catName)
            UIDropDownMenu_AddButton(info, level)
        end
    end
    
    UIDropDownMenu_Initialize(catDropdown, InitializeCategoryDropdown)
    local initialCats = GetCategoryList()
    if #initialCats > 0 then
        UIDropDownMenu_SetSelectedValue(catDropdown, initialCats[1])
        UIDropDownMenu_SetText(catDropdown, initialCats[1])
    else
        UIDropDownMenu_SetText(catDropdown, L:S("CATEGORY") or "Category")
    end

    -- Type Dropdown
        local typeLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    typeLabel:SetPoint("TOPLEFT", 370, -355)
    typeLabel:SetText((L:S("TYPE") or "Type") .. ":")
    
    local typeDropdown = CreateFrame("Frame", "MC_TypeDropdown", panel, "UIDropDownMenuTemplate")
    typeDropdown:SetPoint("TOPLEFT", 410, -350)
    UIDropDownMenu_SetWidth(typeDropdown, 90)
    
    local function InitializeTypeDropdown(frame, level)
        local info = UIDropDownMenu_CreateInfo()
        info.text = L:S("TYPE_ITEM") or "Item"
        info.value = "item"
        info.func = function(self)
            UIDropDownMenu_SetSelectedValue(typeDropdown, self.value)
            UIDropDownMenu_SetText(typeDropdown, info.text)
        end
        info.checked = (UIDropDownMenu_GetSelectedValue(typeDropdown) == "item")
        UIDropDownMenu_AddButton(info, level)
        
        info = UIDropDownMenu_CreateInfo()
        info.text = L:S("TYPE_CURRENCY") or "Currency"
        info.value = "currency"
        info.func = function(self)
            UIDropDownMenu_SetSelectedValue(typeDropdown, self.value)
            UIDropDownMenu_SetText(typeDropdown, info.text)
        end
        info.checked = (UIDropDownMenu_GetSelectedValue(typeDropdown) == "currency")
        UIDropDownMenu_AddButton(info, level)
    end
    
    UIDropDownMenu_Initialize(typeDropdown, InitializeTypeDropdown)
    UIDropDownMenu_SetSelectedValue(typeDropdown, "item")
    UIDropDownMenu_SetText(typeDropdown, L:S("TYPE_ITEM") or "Item")

    -- ==========================================================
    -- AUTOCOMPLETAR / BUSCAR ITENS DA MOCHILA
    -- ==========================================================
    local suggestFrame = CreateFrame("Frame", "MC_ItemSuggestFrame", panel, "BackdropTemplate")
    suggestFrame:SetPoint("TOPLEFT", idInput, "BOTTOMLEFT", 0, 0)
    suggestFrame:SetSize(220, 100)
    suggestFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    suggestFrame:SetBackdropColor(0, 0, 0, 0.9)
    suggestFrame:SetFrameLevel(100)
    suggestFrame:Hide()

    local suggestButtons = {}
    for i = 1, 5 do
        local btn = CreateFrame("Button", nil, suggestFrame)
        btn:SetSize(210, 20)
        if i == 1 then
            btn:SetPoint("TOPLEFT", 5, -5)
        else
            btn:SetPoint("TOPLEFT", suggestButtons[i-1], "BOTTOMLEFT", 0, 0)
        end
        btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        btn.text:SetPoint("LEFT", 20, 0)
        btn.text:SetPoint("RIGHT", -5, 0)
        btn.text:SetJustifyH("LEFT")
        
        btn.icon = btn:CreateTexture(nil, "ARTWORK")
        btn.icon:SetSize(16, 16)
        btn.icon:SetPoint("LEFT", 2, 0)
        
        btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        
        btn:SetScript("OnClick", function(self)
            if self.itemID then
                idInput:SetText(tostring(self.itemID))
                suggestFrame:Hide()
                idInput:ClearFocus()
                -- Já altera o tipo para Item automaticamente
                UIDropDownMenu_SetSelectedValue(typeDropdown, "item")
                UIDropDownMenu_SetText(typeDropdown, L:S("TYPE_ITEM") or "Item")
                
                -- Detecta a expansão automaticamente
                local expacID = select(15, C_Item.GetItemInfo(self.itemID))
                if expacID then
                    local expacName = ""
                    if expacID == 1 then expacName = L:S("BURNING_CRUSADE") or "Burning Crusade"
                    elseif expacID == 2 then expacName = L:S("WRATH_OF_LICH_KING") or "Wrath of the Lich King"
                    elseif expacID == 3 then expacName = "Cataclysm"
                    elseif expacID == 4 then expacName = L:S("MISTS_OF_PANDARIA") or "Mists of Pandaria"
                    elseif expacID == 5 then expacName = L:S("WARLORDS_OF_DRAENOR") or "Warlords of Draenor"
                    elseif expacID == 6 then expacName = L:S("LEGION") or "Legion"
                    elseif expacID == 7 then expacName = L:S("BATTLE_FOR_AZEROTH") or "Battle for Azeroth"
                    elseif expacID == 8 then expacName = L:S("SHADOWLANDS") or "Shadowlands"
                    elseif expacID == 9 then expacName = L:S("DRAGONFLIGHT") or "Dragonflight"
                    elseif expacID == 10 then expacName = L:S("THE_WAR_WITHIN") or "The War Within"
                    elseif expacID == 11 then expacName = L:S("MIDNIGHT") or "Midnight"
                    end
                    
                    local catStr = expacName ~= "" and (expacName .. " - " .. (L:S("ITEMS") or "Items")) or (L:S("ANCIENT_ITEMS") or "Items - Ancient")
                    
                    -- Atualiza o dropdown da Categoria com a expansão detectada
                    UIDropDownMenu_SetSelectedValue(catDropdown, catStr)
                    UIDropDownMenu_SetText(catDropdown, catStr)
                end
            end
        end)
        suggestButtons[i] = btn
    end

    local function UpdateSuggestions(text)
        -- Ignora se for menor que 3 letras ou se o usuário já estiver digitando um ID numérico
        if not text or string.len(text) < 3 or tonumber(text) then
            suggestFrame:Hide()
            return
        end
        
        text = string.lower(text)
        local results = {}
        local foundIDs = {}
        
        -- Vasculha as mochilas de 0 a 4 (Bags principais)
        for bag = 0, NUM_BAG_SLOTS do
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                local info = C_Container.GetContainerItemInfo(bag, slot)
                if info and info.itemID and info.itemName then
                    if not foundIDs[info.itemID] and string.find(string.lower(info.itemName), text, 1, true) then
                        table.insert(results, {id = info.itemID, name = info.itemName, icon = info.iconFileID})
                        foundIDs[info.itemID] = true
                        if #results >= 5 then break end
                    end
                end
            end
            if #results >= 5 then break end
        end
        
        if #results > 0 then
            suggestFrame:Show()
            local height = 10
            for i = 1, 5 do
                if results[i] then
                    suggestButtons[i]:Show()
                    suggestButtons[i].text:SetText(results[i].name)
                    suggestButtons[i].icon:SetTexture(results[i].icon)
                    suggestButtons[i].itemID = results[i].id
                    height = height + 20
                else
                    suggestButtons[i]:Hide()
                end
            end
            suggestFrame:SetHeight(height)
        else
            suggestFrame:Hide()
        end
    end

    idInput:SetScript("OnTextChanged", function(self, userInput)
        if userInput then UpdateSuggestions(self:GetText()) end
    end)

    -- Esconde as sugestões caso clique fora (usando um pequeno atraso para dar tempo de clicar no botão)
    idInput:SetScript("OnEditFocusLost", function(self)
        C_Timer.After(0.2, function() if suggestFrame then suggestFrame:Hide() end end)
    end)

        -- Add Button
    local addButton = CreateFrame("Button", nil, panel, "GameMenuButtonTemplate")
    addButton:SetPoint("TOPLEFT", 520, -353)
    addButton:SetSize(80, 26)
    addButton:SetText(L:S("BTN_ADD") or "Add")
    addButton:SetScript("OnClick", function()
        local id = tonumber(idInput:GetText())
        local cat = UIDropDownMenu_GetSelectedValue(catDropdown)
        local itemType = UIDropDownMenu_GetSelectedValue(typeDropdown) or "item"
        
        if not id or id <= 0 then
            print("|cFFFF0000" .. (L:S("ERROR_INVALID_ID") or "Error: Invalid ID") .. "|r")
            return
        end
        if not cat or cat == "" then
            print("|cFFFF0000" .. (L:S("ERROR_CATEGORY_REQUIRED") or "Error: Category required") .. "|r")
            return
        end
        
        -- Verifica se já existe
        for _, item in ipairs(MyCurrenciesDB.customItems) do
            if item.id == id then
                print("|cFFFF0000" .. (L:S("ERROR_ID_EXISTS") or "Error: This ID already exists") .. "|r")
                return
            end
        end
        
        -- Obter nome da moeda/item
        local name = L:S("CUSTOM") or "Custom"
        if itemType == "currency" then
            local info = C_CurrencyInfo.GetBasicCurrencyInfo(id)
            if info then name = info.name end
        else
            local itemName = C_Item.GetItemInfo(id)
            if itemName then name = itemName end
        end
        
        -- Adiciona
        table.insert(MyCurrenciesDB.customItems, {
            id = id,
            cat = cat,
            type = itemType,
            name = name
        })
        
        LoadGameCurrencies()
        UpdateLocalizedNames()
        UpdateOptionsList()
        UpdateDisplay()
        print("|cFF00FF00" .. (L:S("ADDED") or "Added:") .. " " .. name .. "|r")
        
        -- Limpa inputs
        idInput:SetText("")
    end)

        -- Search Box
    local searchBox = CreateFrame("EditBox", "MC_SearchBox", panel, "SearchBoxTemplate")
    searchBox:SetPoint("TOPLEFT", 20, -390)
    searchBox:SetSize(200, 20)
    searchBox:SetAutoFocus(false)
    if searchBox.Instructions then
        searchBox.Instructions:SetText(L:S("SEARCH") or "Search...")
    end
    searchBox:SetScript("OnTextChanged", function(self)
        if SearchBoxTemplate_OnTextChanged then
            SearchBoxTemplate_OnTextChanged(self)
        end
        UpdateOptionsList(self:GetText())
    end)

            local scrollFrame = CreateFrame("ScrollFrame", "MC_ScrollFrame", panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 20, -420)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 20)
    
    scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetSize(panel:GetWidth()-50, 2000)

    local cbAll = CreateFrame("CheckButton", nil, scrollChild, "UICheckButtonTemplate")
    cbAll:SetPoint("TOPLEFT", 0, 0)
    cbAll.text:SetText("|cFF00FF00" .. L:S("SELECT_ALL") .. "|r")
    cbAll:SetChecked(true)
    cbAll:SetScript("OnClick", function(self)
        local state = self:GetChecked()
        for i, data in ipairs(trackedData) do
            MyCurrenciesDB.visibility[data.id] = state
            if optionCheckboxes[i] then optionCheckboxes[i]:SetChecked(state) end
        end
        UpdateDisplay()
    end)

    -- Inicializa a lista de opções
    UpdateOptionsList()

    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, "My Currencies")
        panel.category = category
        Settings.RegisterAddOnCategory(category)
    else
        InterfaceOptions_AddCategory(panel)
    end
end

-- ============================================================================
-- EVENTOS GERAIS
-- ============================================================================
local isInitialized = false

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("PLAYER_UPDATE_RESTING")
f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA") 

f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        if not MyCurrenciesDB then MyCurrenciesDB = {} end
        for k, v in pairs(defaults) do
            if MyCurrenciesDB[k] == nil then MyCurrenciesDB[k] = v end
        end
        if MyCurrenciesDB.position then
            f:ClearAllPoints()
            f:SetPoint(
                MyCurrenciesDB.position.point, 
                UIParent, 
                MyCurrenciesDB.position.relativePoint, 
                MyCurrenciesDB.position.x, 
                MyCurrenciesDB.position.y
            )
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if not isInitialized then
            isInitialized = true
                                    C_Timer.After(1, function()
                LoadGameCurrencies()
                UpdateLocalizedNames()
                CreateOptionsPanel()
                UpdateDisplay()
                CheckDebugOnZoneChange()
            end)
        else
            UpdateDisplay()
        end
        elseif event == "GET_ITEM_INFO_RECEIVED" then
        if isInitialized then UpdateLocalizedNames() end
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        if isInitialized then
            UpdateDisplay()
            CheckDebugOnZoneChange()
        end
    else
        if isInitialized then UpdateDisplay() end
    end
end)

SLASH_MYCURRENCIES1 = "/mycur"
SLASH_MYCURRENCIES2 = "/mc"
SLASH_MYCURRENCIES3 = "/myc"
SlashCmdList["MYCURRENCIES"] = function(msg)
    msg = msg and strtrim(string.lower(msg)) or ""
    
    if msg == "reset" then
        if MyCurrenciesDB then MyCurrenciesDB.position = nil end
        f:ClearAllPoints()
        f:SetPoint("CENTER")
        print("|cFFFFD100My Currencies:|r " .. (L:S("CMD_RESET") or "Position reset."))
        return
    elseif msg == "toggle" then
        if f:IsShown() then f:Hide() else UpdateDisplay() end
        return
    end

    if Settings and Settings.OpenToCategory then
        if MyCurrenciesOptions and MyCurrenciesOptions.category then
            Settings.OpenToCategory(MyCurrenciesOptions.category:GetID())
        else
            Settings.OpenToCategory("My Currencies")
        end
    else
        InterfaceOptionsFrame_OpenToCategory("My Currencies")
    end
end