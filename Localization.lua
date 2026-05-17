-- ============================================================================
-- LOCALIZATION SYSTEM
-- ============================================================================
-- Detecta e permite seleção manual do idioma do WoW

local L = {}
_G.MyCurrenciesL = L

-- Mapa de idiomas do WoW
local wowLocales = {
    ["enUS"] = "English",
    ["esMX"] = "Español",
    ["esES"] = "Español",
    ["frFR"] = "Français",
    ["deDE"] = "Deutsch",
    ["itIT"] = "Italiano",
    ["koKR"] = "한국어",
    ["ruRU"] = "Русский",
    ["zhCN"] = "简体中文",
    ["zhTW"] = "繁體中文",
    ["ptBR"] = "Português"
}

-- Código do idioma padrão baseado no locale do WoW
local function GetDefaultLanguage()
    local locale = GetLocale()
    if locale == "ptBR" or locale:find("pt") then return "ptBR" end
    if locale:find("en") then return "enUS" end
    if locale == "esMX" or locale == "esES" then return "esES" end
    if locale:find("fr") then return "frFR" end
    if locale:find("de") then return "deDE" end
    if locale:find("it") then return "itIT" end
    if locale:find("ko") then return "koKR" end
    if locale:find("ru") then return "ruRU" end
    if locale:find("zhCN") then return "zhCN" end
    if locale:find("zhTW") then return "zhTW" end
    return "enUS" -- Fallback
end

-- ============================================================================
-- TABELAS DE TRADUÇÃO
-- ============================================================================

local translations = {
    -- PORTUGUÊS (PT-BR)
    ptBR = {
        -- Título e Descrição
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "Monitor de moedas simples",
        
        -- Comandos
        CMD_OPEN = "Abre o painel principal",
        CMD_TOGGLE = "Alterna visibilidade",
        CMD_RESET = "Reseta para posição padrão",
        
        -- Opções gerais
        ICON_SIZE = "Tamanho do Ícone",
        TEXT_SIZE = "Tamanho do Texto",
        LANGUAGE = "Idioma",
        
        -- Checkboxes
        SHOW_ONLY_RESTING = "Mostrar apenas em Áreas de Descanso",
        SHOW_ONLY_EXPANSION = "Mostrar apenas moedas da expansão atual",
        
        -- Seções
        SELECT_ALL = "[ MARCAR / DESMARCAR TUDO ]",
        CATEGORIES_TITLE = "Categorias de Moedas",
        
        -- Expansões
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        
        -- Categorias de moedas
        HIDDEN_CURRENCY = "Moeda oculta",
        ITEMS = "Itens",
        ANCIENT_ITEMS = "Itens - Antigos",
    },
    
    -- ENGLISH (EN-US)
    enUS = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "Simple currency monitor",
        CMD_OPEN = "Open main panel",
        CMD_TOGGLE = "Toggle visibility",
        CMD_RESET = "Reset to default position",
        ICON_SIZE = "Icon Size",
        TEXT_SIZE = "Text Size",
        LANGUAGE = "Language",
        SHOW_ONLY_RESTING = "Show only in Resting Areas",
        SHOW_ONLY_EXPANSION = "Show only currencies from current expansion",
        SELECT_ALL = "[ SELECT / DESELECT ALL ]",
        CATEGORIES_TITLE = "Currency Categories",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "Hidden Currency",
        ITEMS = "Items",
        ANCIENT_ITEMS = "Items - Ancient",
    },
    
    -- ESPAÑOL (ES-ES)
    esES = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "Monitor de monedas simple",
        CMD_OPEN = "Abrir panel principal",
        CMD_TOGGLE = "Alternar visibilidad",
        CMD_RESET = "Restablecer a posición predeterminada",
        ICON_SIZE = "Tamaño de Icono",
        TEXT_SIZE = "Tamaño de Texto",
        LANGUAGE = "Idioma",
        SHOW_ONLY_RESTING = "Mostrar solo en Áreas de Descanso",
        SHOW_ONLY_EXPANSION = "Mostrar solo monedas de la expansión actual",
        SELECT_ALL = "[ SELECCIONAR / DESELECCIONAR TODO ]",
        CATEGORIES_TITLE = "Categorías de Monedas",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "Moneda Oculta",
        ITEMS = "Objetos",
        ANCIENT_ITEMS = "Objetos - Antiguos",
    },
    
    -- FRANÇAIS (FR-FR)
    frFR = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "Simple moniteur de devises",
        CMD_OPEN = "Ouvrir le panneau principal",
        CMD_TOGGLE = "Basculer la visibilité",
        CMD_RESET = "Réinitialiser à la position par défaut",
        ICON_SIZE = "Taille de l'Icône",
        TEXT_SIZE = "Taille du Texte",
        LANGUAGE = "Langue",
        SHOW_ONLY_RESTING = "Afficher uniquement dans les zones de repos",
        SHOW_ONLY_EXPANSION = "Afficher uniquement les devises de l'extension actuelle",
        SELECT_ALL = "[ SÉLECTIONNER / DÉSÉLECTIONNER TOUT ]",
        CATEGORIES_TITLE = "Catégories de Devises",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "Devise Cachée",
        ITEMS = "Objets",
        ANCIENT_ITEMS = "Objets - Anciens",
    },
    
    -- DEUTSCH (DE-DE)
    deDE = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "Einfacher Währungsmonitor",
        CMD_OPEN = "Hauptfenster öffnen",
        CMD_TOGGLE = "Sichtbarkeit umschalten",
        CMD_RESET = "Auf Standardposition zurücksetzen",
        ICON_SIZE = "Symbolgröße",
        TEXT_SIZE = "Textgröße",
        LANGUAGE = "Sprache",
        SHOW_ONLY_RESTING = "Nur in Ruhegebieten anzeigen",
        SHOW_ONLY_EXPANSION = "Nur Währungen der aktuellen Erweiterung anzeigen",
        SELECT_ALL = "[ ALLE AUSWÄHLEN / ALLE ABWÄHLEN ]",
        CATEGORIES_TITLE = "Währungskategorien",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "Versteckte Währung",
        ITEMS = "Gegenstände",
        ANCIENT_ITEMS = "Gegenstände - Antik",
    },
    
    -- ITALIANO (IT-IT)
    itIT = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "Semplice monitor valute",
        CMD_OPEN = "Apri pannello principale",
        CMD_TOGGLE = "Attiva/disattiva visibilità",
        CMD_RESET = "Ripristina posizione predefinita",
        ICON_SIZE = "Dimensione Icona",
        TEXT_SIZE = "Dimensione Testo",
        LANGUAGE = "Lingua",
        SHOW_ONLY_RESTING = "Mostra solo in aree di riposo",
        SHOW_ONLY_EXPANSION = "Mostra solo valute dell'espansione attuale",
        SELECT_ALL = "[ SELEZIONA / DESELEZIONA TUTTO ]",
        CATEGORIES_TITLE = "Categorie Valute",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "Valuta Nascosta",
        ITEMS = "Oggetti",
        ANCIENT_ITEMS = "Oggetti - Antichi",
    },
    
    -- РУССКИЙ (RU-RU)
    ruRU = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "Простой монитор валют",
        CMD_OPEN = "Открыть главную панель",
        CMD_TOGGLE = "Переключить видимость",
        CMD_RESET = "Сбросить на позицию по умолчанию",
        ICON_SIZE = "Размер Значка",
        TEXT_SIZE = "Размер Текста",
        LANGUAGE = "Язык",
        SHOW_ONLY_RESTING = "Показывать только в зонах отдыха",
        SHOW_ONLY_EXPANSION = "Показывать только валюты текущего дополнения",
        SELECT_ALL = "[ ВЫБРАТЬ / СНЯТЬ ВСЕ ОТМЕТКИ ]",
        CATEGORIES_TITLE = "Категории Валют",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "Скрытая Валюта",
        ITEMS = "Предметы",
        ANCIENT_ITEMS = "Предметы - Древние",
    },
    
    -- 简体中文 (ZH-CN)
    zhCN = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "简单货币监控器",
        CMD_OPEN = "打开主面板",
        CMD_TOGGLE = "切换可见性",
        CMD_RESET = "重置为默认位置",
        ICON_SIZE = "图标大小",
        TEXT_SIZE = "文本大小",
        LANGUAGE = "语言",
        SHOW_ONLY_RESTING = "仅在休息区域显示",
        SHOW_ONLY_EXPANSION = "仅显示当前扩展的货币",
        SELECT_ALL = "[ 全选 / 全不选 ]",
        CATEGORIES_TITLE = "货币分类",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "隐藏货币",
        ITEMS = "物品",
        ANCIENT_ITEMS = "物品 - 古代",
    },
    
    -- 繁體中文 (ZH-TW)
    zhTW = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "簡單貨幣監控器",
        CMD_OPEN = "打開主面板",
        CMD_TOGGLE = "切換可見性",
        CMD_RESET = "重置為預設位置",
        ICON_SIZE = "圖示大小",
        TEXT_SIZE = "文字大小",
        LANGUAGE = "語言",
        SHOW_ONLY_RESTING = "僅在休息區域顯示",
        SHOW_ONLY_EXPANSION = "僅顯示目前擴充包的貨幣",
        SELECT_ALL = "[ 全選 / 全不選 ]",
        CATEGORIES_TITLE = "貨幣分類",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "隱藏貨幣",
        ITEMS = "物品",
        ANCIENT_ITEMS = "物品 - 古代",
    },
    
    -- 한국어 (KO-KR)
    koKR = {
        ADDON_TITLE = "My Currencies Tracker",
        ADDON_SUBTITLE = "간단한 화폐 모니터",
        CMD_OPEN = "주 패널 열기",
        CMD_TOGGLE = "표시 유형 토글",
        CMD_RESET = "기본 위치로 재설정",
        ICON_SIZE = "아이콘 크기",
        TEXT_SIZE = "텍스트 크기",
        LANGUAGE = "언어",
        SHOW_ONLY_RESTING = "휴식 구역에서만 표시",
        SHOW_ONLY_EXPANSION = "현재 확장팩의 화폐만 표시",
        SELECT_ALL = "[ 모두 선택 / 모두 선택 해제 ]",
        CATEGORIES_TITLE = "화폐 카테고리",
        MIDNIGHT = "Midnight",
        THE_WAR_WITHIN = "The War Within",
        DRAGONFLIGHT = "Dragonflight",
        SHADOWLANDS = "Shadowlands",
        BATTLE_FOR_AZEROTH = "Battle for Azeroth",
        LEGION = "Legion",
        WARLORDS_OF_DRAENOR = "Warlords of Draenor",
        MISTS_OF_PANDARIA = "Mists of Pandaria",
        WRATH_OF_LICH_KING = "Wrath of the Lich King",
        BURNING_CRUSADE = "Burning Crusade",
        HIDDEN_CURRENCY = "숨겨진 화폐",
        ITEMS = "아이템",
        ANCIENT_ITEMS = "아이템 - 고대",
    },
}

-- Função para obter o idioma salvo ou detectado
local function GetCurrentLanguage()
    if MyCurrenciesDB and MyCurrenciesDB.language then
        return MyCurrenciesDB.language
    end
    return GetDefaultLanguage()
end

-- Função para obter uma string traduzida
function L:GetString(key)
    local currentLang = GetCurrentLanguage()
    local langTable = translations[currentLang]
    
    if langTable and langTable[key] then
        return langTable[key]
    end
    
    -- Fallback para inglês
    local englishTable = translations["enUS"]
    if englishTable and englishTable[key] then
        return englishTable[key]
    end
    
    return key
end

-- Atalho para usar a localização
function L:S(key)
    return self:GetString(key)
end

-- Retorna lista de idiomas disponíveis
function L:GetAvailableLanguages()
    local langs = {}
    for langCode, langName in pairs(wowLocales) do
        table.insert(langs, { code = langCode, name = langName })
    end
    table.sort(langs, function(a, b) return a.name < b.name end)
    return langs
end

-- Retorna o idioma padrão baseado no locale
function L:GetDefaultLanguageCode()
    return GetDefaultLanguage()
end

return L
