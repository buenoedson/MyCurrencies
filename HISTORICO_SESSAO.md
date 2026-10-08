# Histórico de Sessão - MyCurrencies
# Última modificação: 08/10/2026

## Informações do Projeto
- **Cliente/Local:** buenoedson/MyCurrencies
- **Objetivo:** Gerenciar e exibir moedas do World of Warcraft de acordo com a expansão e mapa atual do jogador.

## Diretrizes de Trabalho
- Evitar suposições sem testes ou validações.
- Manter o código limpo, modularizado e com tratamento de erros robusto.
- Atualizar este histórico imediatamente após qualquer alteração significativa.

## Estrutura de Arquivos
- [MyCurrencies.lua](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/MyCurrencies.lua) — Lógica principal e interface do usuário do Addon.
- [MapData.lua](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/MapData.lua) — Estruturas de dados de mapas e expansões associadas.
- [Localization.lua](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/Localization.lua) — Localização do Addon para múltiplos idiomas.
- [MyCurrencies.toc](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/MyCurrencies.toc) — Arquivo de metadados de inicialização do WoW.

---

## Log de Atividades e Decisões

### 24/08/2026: Implementação de Botões de Reordenação e Atalho Shift+Clique
- **Ações:**
  - Substituição da mecânica de Drag & Drop por dois métodos intuitivos e robustos:
    1. Botões `[▲]` e `[▼]` ao lado de cada moeda/item no painel de configurações para mover itens para cima ou para baixo.
    2. Atalho de teclado e mouse nos ícones da tela: `Shift + Clique Esquerdo` move o ícone 1 posição para a esquerda (anterior), e `Shift + Clique Direito` move 1 posição para a direita (próximo).
  - Adicionada a função auxiliar `MoveTrackedData(targetData, direction)` para reorganizar os elementos na lista `trackedData` e salvar o resultado via `SaveCustomOrder()`.
  - Atualizadas as chaves de localização `REORDER_HINT` em `Localization.lua`.
- **Decisões:**
  - Utilizar botões nativos `[▲]` / `[▼]` no painel de opções e atalhos `Shift + Clique` nos ícones, eliminando inconsistências do Drag & Drop no motor gráfico da UI do WoW.

### 24/08/2026: Correção de Sintaxe na Função GetCategoryList
- **Ações:**
  - Diagnóstico do erro LUA `'end' expected (to close 'function' at line 938) near '<eof>'`.
  - Restauração do corpo e do fechamento `end` da função `GetCategoryList()` em `MyCurrencies.lua`.
- **Decisões:**
  - Recompor a iteração e desduplicação de categorias para o dropdown da seção de adição de itens customizados.
- **Bugs corrigidos:**
  - `'end' expected (to close 'function' at line 938)` → A declaração de `GetCategoryList()` foi truncada sem o corpo e o fechamento `end` → Restaurados o laço de desduplicação de categorias e a instrução `end`.

### 24/08/2026: Restauração de Código Após Sobrescrita do CurseForge
- **Ações:**
  - Auditoria dos arquivos locais detectando a substituição dos arquivos `MyCurrencies.lua` e `Localization.lua` por uma versão anterior oriunda do cliente CurseForge.
  - Reaplicação de todas as funcionalidades implementadas na sessão: `hideInCombat`, ordenação persistente `customOrder`, função `MoveTrackedData`, botões `[▲]` / `[▼]` no painel de opções, atalhos `Shift + Clique`, tradução `REORDER_HINT` e registradores de eventos de combate.
- **Decisões:**
  - Consolidar as alterações mais recentes diretamente nos arquivos da área de trabalho e sincronizar a versão final.

### 24/08/2026: Simplificação da Ordenação (Itens Personalizados Primeiros, Seguidos das Moedas Padrão)
- **Ações:**
  - Remoção dos botões `[▲]` / `[▼]`, atalhos `Shift + Clique` e tabela `customOrder`.
  - Atualização do método `LoadGameCurrencies()` em `MyCurrencies.lua` para aplicar ordenação automática: todos os itens/moedas customizados (`custom = true`) aparecem primeiro na interface, seguidos pelas moedas nativas do jogo na ordem natural do menu de moedas da API `C_CurrencyInfo`.
- **Decisões:**
  - Adotar ordenação determinística automática (personalizados > moedas nativas do jogo), simplificando a interface e removendo botões de ajuste manual.

### 24/08/2026: Resolução de Conflitos de Mesclagem Git
- **Ações:**
  - Diagnóstico e remoção de todos os marcadores de conflito git (`<<<<<<< HEAD`, `=======`, `>>>>>>>`) gerados após mesclagens/pulls nos arquivos `MyCurrencies.toc`, `Localization.lua`, `README.md` e `CHANGELOG.md`.
  - Atualização da versão do manifesto `MyCurrencies.toc` para `2026.08.24.2`.
  - Limpeza total do código-fonte em `MyCurrencies.lua`, consolidando a ordenação automática (itens personalizados primeiro, moedas do jogo depois) e a opção `hideInCombat`.
- **Decisões:**
  - Manter o código totalmente limpo e padronizado sem fragmentos de branch ou versões antigas.

### Tarefas Pendentes
- [x] Corrigir erro de sintaxe LUA em `LoadGameCurrencies` (`'end' expected`).
- [x] Corrigir fechamento e corpo da função `GetCategoryList`.
- [x] Implementar ordenação automática (itens personalizados primeiro, moedas do jogo em seguida).
- [x] Resolver todos os conflitos de mesclagem git no projeto.

### 04/09/2026: Auditoria de Sobrescrita pelo CurseForge
- **Ações:**
  - Auditoria completa dos arquivos do Addon após sincronização do CurseForge Client para a versão `2026.08.24.2`.
  - Verificação de arquivos:
    - `MyCurrencies.toc`: Intacto (Versão `2026.08.24.2`).
    - `Localization.lua`: Intacto (Sem conflitos, chaves atualizadas).
    - `README.md`: Intacto (Documentação de ordenação automática e hide in combat preservada).
    - `MyCurrencies.lua`: A ordenação automática (`custom` primeiro) permaneceu intacta. No entanto, a correção de verificação de combate com `UnitAffectingCombat("player")` havia sido revertida para a versão anterior (`InCombatLockdown()` exclusivo) pela substituição do pacote `2026.08.24.2`.
  - Reaplicação imediata da verificação `UnitAffectingCombat("player")` em `UpdateDisplay()`.
- **Decisões:**
  - Manter `InCombatLockdown() or UnitAffectingCombat("player")` para evitar falha no evento `PLAYER_REGEN_DISABLED`.

### Tarefas Pendentes
- [x] Reaplicar verificação `UnitAffectingCombat("player")` em `MyCurrencies.lua`.

### 05/09/2026: Sincronização de Visibilidade e Localização do Debug Frame
- **Ações:**
  - Atualização do `debugFrame` para obedecer rigorosamente às opções de visibilidade do usuário: `hideInCombat` (oculta ao entrar em combate) e `showOnlyResting` (exibe apenas em áreas de descanso).
  - Chamada de `UpdateDebugDisplay()` mesmo quando o frame principal `f` é ocultado por combate ou descanso.
  - Implementação de suporte completo a idioma no `debugFrame`: rótulos `DEBUG_MAP_ID`, `DEBUG_EXPANSION`, `DEBUG_UNMAPPED`, `DEBUG_NO_MAP`, `DEBUG_NO_MAP_DATA`, `DEBUG_UNKNOWN`, `DEBUG_NONE` e nomes de expansão traduzidos dinamicamente de acordo com o idioma selecionado (`MyCurrenciesDB.language` ou locale do jogo).
- **Decisões:**
  - Utilizar a função auxiliar `GetLocalizedExpansion` para traduzir o nome canônico retornado por `MapData.lua` para o idioma ativo do usuário.

### Tarefas Pendentes
- [x] Sincronizar visibilidade do `debugFrame` com combate e área de descanso.
- [x] Localizar textos e expansões do `debugFrame` conforme idioma selecionado.

### 15/09/2026: Separação de Filtros de Expansão (Atual do Jogo vs Mapa Atual)
- **Ações:**
  - Criação da nova opção `showOnlyMapExpansion` ("Mostrar apenas moedas da expansão do mapa atual") com checagem dinâmica via `C_Map.GetBestMapForUnit("player")` e `ns.GetExpansionByMapID(mapID)`.
  - Diferenciação clara da opção `showOnlyCurrentExpansion` ("Mostrar apenas moedas da expansão atual"), que filtra exclusivamente pela versão mais recente/ativa do World of Warcraft (Retail: Midnight / The War Within) obtida via `GetServerExpansionLevel()` / `GetBuildInfo()`.
  - Registro de eventos adicionais de mapa (`ZONE_CHANGED`, `ZONE_CHANGED_INDOORS`) para atualizar a filtragem imediatamente ao transitar entre subzonas, cavernas ou mapas.
  - Atualização das tabelas de localização em `Localization.lua` com a chave `SHOW_ONLY_MAP_EXPANSION`.
  - Reorganização do painel de opções rolável com ambos os checkboxes e ajuste das posições verticais subsequentes.
- **Decisões:**
  - Manter suporte retrocompatível ao identificador anterior `autoFilterRegion`.

### Tarefas Pendentes
- [x] Adicionar opção de exibir apenas moedas da expansão do mapa atual.
- [x] Manter opção de exibir apenas moedas da expansão atual do jogo.

### 08/10/2026: Auditoria de Segurança, Consistência e Otimização de Performance
- **Ações:**
  - Correção de runtime error potencial em `select(15, C_Item.GetItemInfo(self.itemID))` substituindo por extração segura em tabela `{ C_Item.GetItemInfo(...) }`.
  - Inclusão do slot de Reagent Bag (`Enum.BagIndex.ReagentBag` / bag 5) na varredura de sugestões em `UpdateSuggestions`.
  - Ajuste do threshold heurístico de moedas The War Within de `>= 2400` para `>= 2800` para evitar conflito com moedas de Dragonflight (2400-2800).
  - Adição de guarda de reentrância (`isScanningCurrencies`) em `LoadGameCurrencies()` para impedir recursão infinita acionada por eventos durante `C_CurrencyInfo.ExpandCurrencyList()`.
  - Agrupamento de itens personalizados por categoria na ordenação determinística de `trackedData` para evitar duplicação visual de cabeçalhos de categoria na lista de opções.
  - Substituição do armazenamento persistente desnecessário de `sessionLoggedMaps` por tabela volátil em memória (com limpeza retrocompatível em `ADDON_LOADED`).
  - Criação de `OpenSettingsSafely()` com guarda `InCombatLockdown()` no clique direito do frame/ícones e no comando `/mc` para prevenir `ADDON_ACTION_BLOCKED` e taint de combate no Retail.
  - Substituição do registro do evento `BAG_UPDATE` por `BAG_UPDATE_DELAYED` para eliminar picos de chamadas redundantes e perda de FPS.
  - Migração da chave de visibilidade em `MyCurrenciesDB.visibility` para formato composto `<type>:<id>` com fallback retrocompatível por `<id>`.
  - Sincronização do estado visual dos checkboxes de categoria de acordo com a visibilidade de todos os seus itens filhos.
  - Desduplicação da chave `Español` em `wowLocales` e mapeamento de `esMX` para `esES`.
  - Padronização da chave `WRATH_OF_LICH_KING` / `WRATH_OF_THE_LICH_KING` e adição de `MIDNIGHT`, `CATACLYSM` e `CLASSIC` em `ns.expansionsList` e tabelas de localização.
  - Adição das chaves de localização faltantes em todos os idiomas (`ptBR`, `enUS`, `esES`, `frFR`, `deDE`, `itIT`, `ruRU`, `zhCN`, `zhTW`, `koKR`).
- **Decisões:**
  - Adotar chaves de visibilidade compostas (`type:id`) para evitar colisão entre itens e moedas com mesmo ID numérico, mantendo compatibilidade transparente com bancos salvos legados.
  - Limpar mapas depurados (`_loggedMaps`) na memória de sessão para manter o `SavedVariables` conciso.
  - Utilizar `BAG_UPDATE_DELAYED` em vez de múltiplos `BAG_UPDATE` sequenciais para operações de inventário.
- **Bugs corrigidos:**
  - Possível crash de runtime em item uncached → `select(15, nil)` lança erro `index out of range` em Lua 5.1 → extração de array com guarda nil implementada.
  - Moedas de Dragonflight (2400–2799) classificadas incorretamente como The War Within no fallback de ID → limite inferior de TWW ajustado de 2400 para 2800.
  - Reentrância no loop de expansão de moedas → `ExpandCurrencyList` pode disparar eventos da UI durante varredura → flag `isScanningCurrencies` adicionada.
  - Bloqueio de ação/Taint ao abrir painel em combate via clique direito ou slash command → chamadas de Settings sem guarda em combate geram taint → `OpenSettingsSafely()` implementado com guarda de combate.
  - Disparos massivos de evento de bolsa → `BAG_UPDATE` dispara para cada slot alterado → migrado para `BAG_UPDATE_DELAYED`.

### Tarefas Pendentes
- [x] Corrigir possíveis crashes de API e indexação de bolsas em `MyCurrencies.lua`.
- [x] Implementar guarda contra reentrância de expansão de moedas.
- [x] Implementar proteção contra Taint de combate ao abrir o painel de opções.
- [x] Otimizar performance de eventos substituindo `BAG_UPDATE` por `BAG_UPDATE_DELAYED`.
- [x] Resolver colisões de ID entre moedas e itens na visibilidade.
- [x] Normalizar e sincronizar chaves de localização e expansões em todos os idiomas suportados.

