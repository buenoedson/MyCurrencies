local addonName, ns = ...

-- ============================================================================
-- MAPA DE CONTINENTES E ZONAS PARA EXPANSÕES
-- ============================================================================
-- Estratégia: mapeamos apenas os IDs que temos certeza que estão corretos.
-- A função GetExpansionByMapID() sobe na hierarquia de mapas pais até
-- encontrar um continente raiz (que nunca muda de ID).
-- Para adicionar novos IDs, execute dentro do jogo:
--   /run print(C_Map.GetBestMapForUnit("player"))
-- e adicione o ID retornado à expansão correta abaixo.
-- ============================================================================
ns.mapToExpansions = {
    -- === MIDNIGHT (12.0) ===
    [2393] = "Midnight", -- Silvermoon
    [2395] = "Midnight", -- Eversong Woods
    [2413] = "Midnight", -- Harandar
    [2576] = "Midnight", -- The Den
    [2437] = "Midnight", -- Zul'Aman
    [2536] = "Midnight", -- Atal'Aman
    [2405] = "Midnight", -- Voidstorm
    [2512] = "Midnight", -- The Coiled Isle

    -- === THE WAR WITHIN ===
    [2274] = "The War Within", -- Khaz Algar
    [2248] = "The War Within", -- Isle of Dorn
    [2339] = "The War Within", -- Dornogal
    [2214] = "The War Within", -- The Ringing Deeps
    [2215] = "The War Within", -- Hallowfall
    [2255] = "The War Within", -- Azj-Kahet
    [2256] = "The War Within", -- Azj-Kahet - Lower
    [2213] = "The War Within", -- City of Threads
    [2216] = "The War Within", -- City of Threads - Lower

    -- === DRAGONFLIGHT ===
    [1978] = "Dragonflight", -- Dragon Isles
    [2022] = "Dragonflight", -- The Waking Shores
    [2023] = "Dragonflight", -- Ohn'ahran Plains
    [2024] = "Dragonflight", -- The Azure Span
    [2025] = "Dragonflight", -- Thaldraszus
    [2112] = "Dragonflight", -- Valdrakken
    [2151] = "Dragonflight", -- The Forbidden Reach
    [2133] = "Dragonflight", -- Zaralek Cavern
    [2200] = "Dragonflight", -- Emerald Dream

    -- === SHADOWLANDS ===
    [1550] = "Shadowlands", -- Shadowlands (overall)
    [1670] = "Shadowlands", -- Oribos
    [1533] = "Shadowlands", -- Bastion
    [1536] = "Shadowlands", -- Maldraxxus
    [1565] = "Shadowlands", -- Ardenweald
    [1525] = "Shadowlands", -- Revendreth
    [1543] = "Shadowlands", -- The Maw
    [1961] = "Shadowlands", -- Korthia
    [1970] = "Shadowlands", -- Zereth Mortis

    -- === BATTLE FOR AZEROTH ===
    [875]  = "Battle for Azeroth", -- Zandalar
    [876]  = "Battle for Azeroth", -- Kul Tiras
    [862]  = "Battle for Azeroth", -- Zuldazar
    [863]  = "Battle for Azeroth", -- Nazmir
    [864]  = "Battle for Azeroth", -- Vol'dun
    [895]  = "Battle for Azeroth", -- Tiragarde Sound
    [896]  = "Battle for Azeroth", -- Drustvar
    [942]  = "Battle for Azeroth", -- Stormsong Valley
    [1161] = "Battle for Azeroth", -- Boralus
    [1165] = "Battle for Azeroth", -- Dazar'alor
    [1355] = "Battle for Azeroth", -- Nazjatar
    [1462] = "Battle for Azeroth", -- Mechagon

    -- === LEGION ===
    [619]  = "Legion", -- Broken Isles
    [630]  = "Legion", -- Azsuna
    [641]  = "Legion", -- Val'sharah
    [650]  = "Legion", -- Highmountain
    [634]  = "Legion", -- Stormheim
    [680]  = "Legion", -- Suramar
    [646]  = "Legion", -- Broken Shore
    [905]  = "Legion", -- Argus
    [830]  = "Legion", -- Krokuun
    [885]  = "Legion", -- Antoran Wastes
    [882]  = "Legion", -- Mac'Aree

    -- === WARLORDS OF DRAENOR ===
    [572]  = "Warlords of Draenor", -- Draenor
    [525]  = "Warlords of Draenor", -- Frostfire Ridge
    [539]  = "Warlords of Draenor", -- Shadowmoon Valley
    [543]  = "Warlords of Draenor", -- Gorgrond
    [535]  = "Warlords of Draenor", -- Talador
    [542]  = "Warlords of Draenor", -- Spires of Arak
    [550]  = "Warlords of Draenor", -- Nagrand
    [534]  = "Warlords of Draenor", -- Tanaan Jungle
    [554]  = "Warlords of Draenor", -- Ashran
    [590]  = "Warlords of Draenor", -- Stormshield
    [588]  = "Warlords of Draenor", -- Warspear

    -- === MISTS OF PANDARIA ===
    [424]  = "Mists of Pandaria", -- Pandaria
    [371]  = "Mists of Pandaria", -- The Jade Forest
    [376]  = "Mists of Pandaria", -- Valley of the Four Winds
    [379]  = "Mists of Pandaria", -- Kun-Lai Summit
    [388]  = "Mists of Pandaria", -- Townlong Steppes
    [390]  = "Mists of Pandaria", -- Vale of Eternal Blossoms
    [418]  = "Mists of Pandaria", -- Krasarang Wilds
    [422]  = "Mists of Pandaria", -- Dread Wastes
    [504]  = "Mists of Pandaria", -- Isle of Thunder
    [507]  = "Mists of Pandaria", -- Isle of Giants
    [544]  = "Mists of Pandaria", -- Timeless Isle

    -- === CATACLYSM ===
    [198]  = "Cataclysm", -- Kezan
    [199]  = "Cataclysm", -- Lost Isles
    [203]  = "Cataclysm", -- Vashj'ir
    [207]  = "Cataclysm", -- Deepholm
    [208]  = "Cataclysm", -- Mount Hyjal
    [241]  = "Cataclysm", -- Twilight Highlands
    [244]  = "Cataclysm", -- Tol Barad
    [245]  = "Cataclysm", -- Tol Barad Peninsula
    [249]  = "Cataclysm", -- Uldum
    [338]  = "Cataclysm", -- Molten Front
    [568]  = "Cataclysm", -- Zul'Aman
    [638]  = "Cataclysm", -- Gilneas
    [639]  = "Cataclysm", -- Gilneas City
    [658]  = "Cataclysm", -- The Ruby Sanctum

    -- === WRATH OF THE LICH KING ===
    [113]  = "Wrath of the Lich King", -- Borean Tundra (original Wrath ID)
    [114]  = "Wrath of the Lich King", -- Howling Fjord (original Wrath ID)
    [115]  = "Wrath of the Lich King", -- Dragonblight (original Wrath ID)
    [116]  = "Wrath of the Lich King", -- Grizzly Hills
    [117]  = "Wrath of the Lich King", -- Zul'Drak
    [118]  = "Wrath of the Lich King", -- Sholazar Basin
    [119]  = "Wrath of the Lich King", -- Storm Peaks
    [120]  = "Wrath of the Lich King", -- Icecrown
    [121]  = "Wrath of the Lich King", -- Crystalsong Forest
    [122]  = "Wrath of the Lich King", -- Wintergrasp
    [123]  = "Wrath of the Lich King", -- Lake Wintergrasp
    [125]  = "Wrath of the Lich King", -- Wintergrasp Fortress
    [141]  = "Wrath of the Lich King", -- The Storm Peaks (alt)

    -- === BURNING CRUSADE ===
    [101]  = "Burning Crusade", -- Hellfire Peninsula (original BC ID)
    [102]  = "Burning Crusade", -- Zangarmarsh
    [103]  = "Burning Crusade", -- Shadowmoon Valley
    [104]  = "Burning Crusade", -- Nagrand
    [105]  = "Burning Crusade", -- Terokkar Forest
    [106]  = "Burning Crusade", -- Netherstorm
    [107]  = "Burning Crusade", -- Blade's Edge Mountains
    [108]  = "Burning Crusade", -- Isle of Quel'Danas
    [109]  = "Burning Crusade", -- Eversong Woods (BC original)

    -- === CONTINENT ANCHORS (mapas raiz que nunca mudam de ID) ===
    -- Esses IDs sao fixos e servem como fallback subindo a hierarquia
    [12]   = "Classic",                -- Kalimdor
    [13]   = "Classic",                -- Eastern Kingdoms
    [530]  = "Burning Crusade",        -- Outland
    [571]  = "Wrath of the Lich King", -- Northrend
}

-- ============================================================================
-- DETECCAO DE EXPANSAO POR HIERARQUIA DE MAPAS
-- ============================================================================
-- Sobe na arvore de mapas pais ate encontrar um continente/expansao conhecido.
-- Isso significa que mesmo que uma masmorra/raide antiga tenha mudado de ID,
-- ela eventualmente vai herdar do continente pai.
function ns.GetExpansionByMapID(mapID)
    if not mapID or mapID <= 0 then return nil end

    local visited = {}
    local current = mapID

    while current and current > 0 and not visited[current] do
        visited[current] = true

        if ns.mapToExpansions[current] then
            return ns.mapToExpansions[current]
        end

        local info = C_Map.GetMapInfo(current)
        if info and info.parentMapID and info.parentMapID > 0 then
            current = info.parentMapID
        else
            break
        end
    end

    return nil
end

-- ============================================================================
-- LISTA DE TODAS AS EXPANSOES DISPONIVEIS
-- ============================================================================
ns.expansionsList = {
    { key = "THE_WAR_WITHIN",         displayName = "The War Within" },
    { key = "DRAGONFLIGHT",           displayName = "Dragonflight" },
    { key = "SHADOWLANDS",            displayName = "Shadowlands" },
    { key = "BATTLE_FOR_AZEROTH",     displayName = "Battle for Azeroth" },
    { key = "LEGION",                 displayName = "Legion" },
    { key = "WARLORDS_OF_DRAENOR",    displayName = "Warlords of Draenor" },
    { key = "MISTS_OF_PANDARIA",      displayName = "Mists of Pandaria" },
    { key = "CATACLYSM",              displayName = "Cataclysm" },
    { key = "WRATH_OF_THE_LICH_KING", displayName = "Wrath of the Lich King" },
    { key = "BURNING_CRUSADE",        displayName = "Burning Crusade" },
    { key = "CLASSIC",                displayName = "Classic" },
}

-- Mapa reverso: displayName -> localization key
ns.expansionToKey = {}
for _, exp in ipairs(ns.expansionsList) do
    ns.expansionToKey[exp.displayName] = exp.key
end
