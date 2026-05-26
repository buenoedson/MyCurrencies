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
        
        -- Custom items
        ADD_CUSTOM_TITLE = "Adicionar Moeda/Item Customizado",
        ID = "ID",
        CATEGORY = "Categoria",
        TYPE = "Tipo",
        TYPE_ITEM = "Item",
        TYPE_CURRENCY = "Moeda",
        BTN_ADD = "Adicionar",
        BTN_CLEAR_CUSTOM = "Limpar Itens Customizados",
        CUSTOM = "Customizado",
        ERROR_INVALID_ID = "Erro: ID inválido",
        ERROR_CATEGORY_REQUIRED = "Erro: Categoria obrigatória",
        ERROR_ID_EXISTS = "Erro: Este ID já existe",
        ADDED = "Adicionado:",
                CLEARED_ALL = "Todos os itens customizados foram limpos",
        RELOAD_REQUIRED = "Recarregue a interface (/reload) para aplicar o idioma.",
        
        -- Debug / Developer
        DEBUG_TITLE = "Desenvolvedor / Debug",
        DEBUG_MODE = "Modo Debug (exibe ID do mapa e expansão)",
        DEBUG_LOG_UNMAPPED = "Gerar log se mapa não estiver mapeado",
        DEBUG_SHOW_MAP = "Mostrar Info do Mapa Atual",
        DEBUG_SHOW_HIERARCHY = "Mostrar Hierarquia do Mapa",
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
        
        ADD_CUSTOM_TITLE = "Add Custom Currency/Item",
        ID = "ID",
        CATEGORY = "Category",
        TYPE = "Type",
        TYPE_ITEM = "Item",
        TYPE_CURRENCY = "Currency",
        BTN_ADD = "Add",
        BTN_CLEAR_CUSTOM = "Clear Custom Items",
        CUSTOM = "Custom",
        ERROR_INVALID_ID = "Error: Invalid ID",
        ERROR_CATEGORY_REQUIRED = "Error: Category required",
        ERROR_ID_EXISTS = "Error: This ID already exists",
        ADDED = "Added:",
                CLEARED_ALL = "Cleared all custom items",
        RELOAD_REQUIRED = "Reload UI (/reload) to apply language changes.",
        
        -- Debug / Developer
        DEBUG_TITLE = "Developer / Debug",
        DEBUG_MODE = "Debug Mode (show map ID & expansion)",
        DEBUG_LOG_UNMAPPED = "Log if map is not mapped to any expansion",
        DEBUG_SHOW_MAP = "Show Current Map Info",
        DEBUG_SHOW_HIERARCHY = "Show Map Hierarchy",
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
        
        ADD_CUSTOM_TITLE = "Añadir Moneda/Objeto Personalizado",
        ID = "ID",
        CATEGORY = "Categoría",
        TYPE = "Tipo",
        TYPE_ITEM = "Objeto",
        TYPE_CURRENCY = "Moneda",
        BTN_ADD = "Añadir",
        BTN_CLEAR_CUSTOM = "Borrar Objetos Personalizados",
        CUSTOM = "Personalizado",
        ERROR_INVALID_ID = "Error: ID no válido",
        ERROR_CATEGORY_REQUIRED = "Error: Categoría requerida",
        ERROR_ID_EXISTS = "Error: Este ID ya existe",
        ADDED = "Añadido:",
                CLEARED_ALL = "Se borraron todos los objetos personalizados",
        RELOAD_REQUIRED = "Recarga la interfaz (/reload) para aplicar el idioma.",
        
        -- Debug / Developer
        DEBUG_TITLE = "Desarrollador / Depuración",
        DEBUG_MODE = "Modo depuración (mostrar ID del mapa y expansión)",
        DEBUG_LOG_UNMAPPED = "Registrar si el mapa no está mapeado",
        DEBUG_SHOW_MAP = "Mostrar Info del Mapa Actual",
        DEBUG_SHOW_HIERARCHY = "Mostrar Jerarquía del Mapa",
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
        RELOAD_REQUIRED = "Rechargez l'interface (/reload) pour appliquer la langue.",
        
        -- Debug / Developer
        DEBUG_TITLE = "Développeur / Débogage",
        DEBUG_MODE = "Mode débogage (afficher l'ID de la carte et l'extension)",
        DEBUG_LOG_UNMAPPED = "Journaliser si la carte n'est pas répertoriée",
        DEBUG_SHOW_MAP = "Afficher les Infos de la Carte Actuelle",
        DEBUG_SHOW_HIERARCHY = "Afficher la Hiérarchie de la Carte",
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
        RELOAD_REQUIRED = "Benutzeroberfläche neu laden (/reload), um die Sprache anzuwenden.",
        
        -- Debug / Developer
        DEBUG_TITLE = "Entwickler / Debug",
        DEBUG_MODE = "Debug-Modus (Karten-ID und Erweiterung anzeigen)",
        DEBUG_LOG_UNMAPPED = "Protokollieren, wenn Karte nicht zugeordnet ist",
        DEBUG_SHOW_MAP = "Aktuelle Karteninfo anzeigen",
        DEBUG_SHOW_HIERARCHY = "Kartenhierarchie anzeigen",
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
        RELOAD_REQUIRED = "Ricarica l'interfaccia (/reload) per applicare la lingua.",
        
        -- Debug / Developer
        DEBUG_TITLE = "Sviluppatore / Debug",
        DEBUG_MODE = "Modalità debug (mostra ID mappa ed espansione)",
        DEBUG_LOG_UNMAPPED = "Registra se la mappa non è associata",
        DEBUG_SHOW_MAP = "Mostra Info Mappa Corrente",
        DEBUG_SHOW_HIERARCHY = "Mostra Gerarchia Mappa",
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
        RELOAD_REQUIRED = "Перезагрузите интерфейс (/reload) для применения языка.",
        
        -- Debug / Developer
        DEBUG_TITLE = "Разработчик / Отладка",
        DEBUG_MODE = "Режим отладки (показать ID карты и дополнение)",
        DEBUG_LOG_UNMAPPED = "Записывать, если карта не сопоставлена",
        DEBUG_SHOW_MAP = "Показать информацию о текущей карте",
        DEBUG_SHOW_HIERARCHY = "Показать иерархию карты",
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
        RELOAD_REQUIRED = "重载界面 (/reload) 以应用语言更改。",
        
        -- Debug / Developer
        DEBUG_TITLE = "开发人员 / 调试",
        DEBUG_MODE = "调试模式 (显示地图ID和扩展包)",
        DEBUG_LOG_UNMAPPED = "记录未映射的地图",
        DEBUG_SHOW_MAP = "显示当前地图信息",
        DEBUG_SHOW_HIERARCHY = "显示地图层级",
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
        RELOAD_REQUIRED = "重載介面 (/reload) 以套用語言變更。",
        
        -- Debug / Developer
        DEBUG_TITLE = "開發人員 / 除錯",
        DEBUG_MODE = "除錯模式 (顯示地圖ID和擴充包)",
        DEBUG_LOG_UNMAPPED = "記錄未映射的地圖",
        DEBUG_SHOW_MAP = "顯示目前地圖資訊",
        DEBUG_SHOW_HIERARCHY = "顯示地圖層級",
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
        RELOAD_REQUIRED = "언어 변경을 적용하려면 UI를 다시 로드(/reload)하세요.",
        
        -- Debug / Developer
        DEBUG_TITLE = "개발자 / 디버그",
        DEBUG_MODE = "디버그 모드 (지도 ID 및 확장팩 표시)",
        DEBUG_LOG_UNMAPPED = "매핑되지 않은 지도 기록",
        DEBUG_SHOW_MAP = "현재 지도 정보 표시",
        DEBUG_SHOW_HIERARCHY = "지도 계층 표시",
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
