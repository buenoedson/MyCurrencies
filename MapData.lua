local addonName, ns = ...

-- ============================================================================
-- MAPA DE CONTINENTES E ZONAS PARA EXPANSÕES
-- ============================================================================
ns.mapToExpansions = {
    -- === MIDNIGHT (12.0) ===
    [2393] = "Midnight",       -- Silvermoon
    [2395] = "Midnight",       -- Eversong Woods
    [2413] = "Midnight",       -- Harandar
    [2576] = "Midnight",       -- The Den
    [2437] = "Midnight",       -- Zul’Aman
    [2536] = "Midnight",       -- Atal’Aman
    [2405] = "Midnight",       -- Voidstorm

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
    [1978] = "Dragonflight",   -- Dragon Isles
    [2022] = "Dragonflight",   -- The Waking Shores
    [2023] = "Dragonflight",   -- Ohn'ahran Plains
    [2024] = "Dragonflight",   -- The Azure Span
    [2025] = "Dragonflight",   -- Thaldraszus
    [2112] = "Dragonflight",   -- Valdrakken
    [2151] = "Dragonflight",   -- The Forbidden Reach
    [2133] = "Dragonflight",   -- Cavernas de Zaralek
    [2200] = "Dragonflight",   -- Sonho Esmeralda
    
    -- === SHADOWLANDS ===
    [1550] = "Shadowlands",    -- Shadowlands (Geral)
    [1670] = "Shadowlands",    -- Oribos
    [1533] = "Shadowlands",    -- Bastion
    [1536] = "Shadowlands",    -- Maldraxxus
    [1565] = "Shadowlands",    -- Ardenweald
    [1525] = "Shadowlands",    -- Revendreth
    [1543] = "Shadowlands",    -- The Maw
    [1961] = "Shadowlands",    -- Korthia
    [1970] = "Shadowlands",    -- Zereth Mortis
    
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
    [619]  = "Legion",         -- Ilhas Partidas
    [630]  = "Legion",         -- Azsuna
    [641]  = "Legion",         -- Val'sharah
    [650]  = "Legion",         -- Highmountain
    [634]  = "Legion",         -- Stormheim
    [680]  = "Legion",         -- Suramar
    [646]  = "Legion",         -- Broken Shore
    [905]  = "Legion",         -- Argus
    [830]  = "Legion",         -- Krokuun
    [885]  = "Legion",         -- Antoran Wastes
    [882]  = "Legion",         -- Mac'Aree
    
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
    [424]  = "Mists of Pandaria",   -- Pandaria
    [371]  = "Mists of Pandaria",   -- The Jade Forest
    [376]  = "Mists of Pandaria",   -- Valley of the Four Winds
    [379]  = "Mists of Pandaria",   -- Kun-Lai Summit
    [388]  = "Mists of Pandaria",   -- Townlong Steppes
    [390]  = "Mists of Pandaria",   -- Vale of Eternal Blossoms
    [418]  = "Mists of Pandaria",   -- Krasarang Wilds
    [422]  = "Mists of Pandaria",   -- Dread Wastes
    [504]  = "Mists of Pandaria",   -- Isle of Thunder
    [507]  = "Mists of Pandaria",   -- Isle of Giants
    [544]  = "Mists of Pandaria",   -- Timeless Isle
    
    -- === CATACLYSM ===
    [208]  = "Cataclysm",           -- Mount Hyjal
    [203]  = "Cataclysm",           -- Vashj'ir
    [207]  = "Cataclysm",           -- Deepholm
    [249]  = "Cataclysm",           -- Uldum
    [241]  = "Cataclysm",           -- Twilight Highlands
    [244]  = "Cataclysm",           -- Tol Barad
    [245]  = "Cataclysm",           -- Tol Barad Peninsula
    [338]  = "Cataclysm",           -- Molten Front
    
    -- === WRATH OF THE LICH KING ===
    [113]  = "Wrath of the Lich King", -- Nortúndria
    [114]  = "Wrath of the Lich King", -- Borean Tundra
    -- ... Restante mantido
    
    -- === BURNING CRUSADE ===
    [101]  = "Burning Crusade",     -- Terralém
    -- ... Restante mantido
    
    -- === CLASSIC ===
    [12]   = "Classic",             -- Kalimdor
    [13]   = "Classic"              -- Eastern Kingdoms
}
