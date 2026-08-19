# Histórico de Sessão - MyCurrencies
# Última modificação: 11/08/2026

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

### 18/07/2026: Diagnóstico Inicial e Correção de Erros de Mapa Nulo
- **Ações:**
  - Criação do histórico de sessão `HISTORICO_SESSAO.md`.
  - Análise de chamadas da API `C_Map.GetMapInfo` com potencial `mapID` nulo.
  - Implementação de verificações de `nil` para `mapID` em `UpdateDebugDisplay` e nas ações de clique do painel de depuração (`btnShowMap`, `btnShowHierarchy`).
- **Decisões:**
  - Adicionar proteção para verificar se `mapID` é nulo em `UpdateDebugDisplay` e no clique dos botões de depuração antes de invocar a API de mapas.
- **Bugs corrigidos:**
  - Erro LUA `bad argument #1 to 'GetMapInfo'` → `C_Map.GetBestMapForUnit("player")` retorna `nil` quando o mapa do jogador está indisponível (telas de carregamento ou instâncias) → Adicionadas proteções de `nil` e valores fallback nas chamadas de `C_Map.GetMapInfo` e formatações de textos.

### 08/08/2026: Inclusão de Todas as Opções no ScrollFrame do Painel de Configurações
- **Ações:**
  - Reestruturação do `CreateOptionsPanel` em `MyCurrencies.lua` para instanciar o `ScrollFrame` e `scrollChild` no início da construção do painel.
  - Reparentamento de todos os componentes de configuração (Idioma, Tamanhos de Ícone e Texto, Opções de Exibição, Seção Debug, Seção Adicionar Item Customizado, Caixa de Busca e Seleção Geral) para o `scrollChild`.
  - Reajuste do `UpdateOptionsList` para iniciar a renderização da lista de moedas a partir de `yOffset = -470` dentro do `scrollChild`, ajustando dinamicamente a altura total do scroll.
- **Decisões:**
  - Incluir todos os elementos de configuração dentro da barra de rolagem para que a interface de opções seja totalmente rolável e responsiva em resoluções com menor altura.
- **Bugs corrigidos:**
  - Barra de rolagem limitada apenas às moedas → Os controles principais ocupavam ~420px fixos no topo, deixando um espaço muito reduzido para as moedas → Todos os controles foram integrados no `scrollChild`, permitindo rolagem contínua.

### 09/08/2026: Correção do Escaneamento Dinâmico de Moedas e Remoção de Duplicatas
- **Ações:**
  - Refatoração do método `LoadGameCurrencies` em `MyCurrencies.lua`:
    - Leitura direta da propriedade `info.currencyID` disponibilizada por `C_CurrencyInfo.GetCurrencyListInfo(i)`, utilizando `GetCurrencyListLink` apenas como fallback.
    - Implementação de laço iterativo para expansão completa de todos os cabeçalhos e subcabeçalhos de moedas, recolhendo-os posteriormente em ordem reversa.
    - Criação do mapa de verificação única `foundKeys` no formato `type:id` para impedir que a mesma moeda ou item seja inserido mais de uma vez em `trackedData`.
    - Integração de `customItems` no processo de desduplicação: se a moeda customizada já existe no scan do jogo, marca o registro existente com `custom = true` sem gerar linha duplicada.
  - Atualização do evento `CURRENCY_DISPLAY_UPDATE` no handler `OnEvent` para re-executar `LoadGameCurrencies()` quando novas moedas forem descobertas ou atualizadas durante o jogo.
- **Decisões:**
  - Garantir desduplicação estrita via chave composta `(tipo .. ":" .. id)` para tratar isoladamente moedas et itens com mesmo ID.
- **Bugs corrigidos:**
  - Moedas não escaneadas automaticamente e duplicadas ao adicionar manualmente → `GetCurrencyListLink` retornava `nil` para algumas moedas e o escaneamento não ocorria dinamicamente no evento `CURRENCY_DISPLAY_UPDATE`; adição manual inseria duplicata pois `LoadCustomItems` não validava moedas já presentes → Refatorado o scanner e adicionada desduplicação estrita.

### 11/08/2026: Atualização de Compatibilidade do Patch 12.1.0 e Correção do Filtro Regional
- **Ações:**
  - Atualização da versão do manifesto em [MyCurrencies.toc](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/MyCurrencies.toc) para `120100` (World of Warcraft 12.1.0).
  - Remoção da exigência estrita de `info.discovered` em `UpdateDisplay()` quando a quantidade da moeda for maior que 0 (`count > 0`), garantindo a exibição de moedas da 12.1.0 e da Warband.
  - Refatoração da regra `autoFilterRegion` em [MyCurrencies.lua](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/MyCurrencies.lua) para ocultar unicamente categorias de expansões legadas explicitamente nomeadas (ex: `Dragonflight`, `Shadowlands`), liberando a exibição de categorias ativas e neutras como `Zones` (ex: Angler Pearls, Unalloyed Abundance, Uncontaminated Void Sample), `Professions`, `Dungeon and Raid` e `Warband`.
- **Decisões:**
  - Categorias neutras e genéricas da aba de moedas não contêm o nome da expansão e devem ser mantidas visíveis quando a opção de filtro por região estiver ativa.
- **Bugs corrigidos:**
  - Moedas da categoria `Zones` marcadas como ativas e com saldo positivo não eram exibidas na tela (conforme demonstrado em `image.png`) → O filtro `autoFilterRegion` rejeitava qualquer categoria cujo nome não contivesse `"Midnight"` ou `"The War Within"` → Primeira tentativa: filtro invertido para ocultar apenas expansões legadas.
  - Segunda correção: filtro invertido exibia moedas de **todas** as expansões mesmo com `autoFilterRegion` ativo → A nova lógica verifica se a categoria contém o nome de **qualquer expansão conhecida** e, se sim, exibe apenas se for a expansão atual. Categorias neutras sem nome de expansão (`Zones`, `Professions`, `Dungeon and Raid`, `Warband`, `Miscellaneous`) passam sem restrição.
  - Terceira correção: moedas menores (ex: `Empty Kaja'Cola Can`, ID 3218) não eram mapeadas para The War Within porque a interface do jogo cria micro-cabeçalhos obscuros (como "S.C.R.A.P." ou "Rewards") que não contém o nome da expansão e nem o nome da zona principal. Soluções aplicadas: (a) criada a tabela `HEADER_TO_EXPANSION` para zonas/continentes principais; (b) criado um **fallback infalível por Currency ID** (`GetExpansionFallbackByCurrencyID`), que mapeia moedas desconhecidas pela faixa sequencial do ID, excetuando cabeçalhos verdadeiramente globais (`IsNeutralHeader` como PvP ou Miscellaneous).
  - Quarta correção: dezenas de moedas de The War Within (Kej, Resonance Crystals, Kaja'Cola) continuavam vazando em Midnight. Causa raiz: uma regra (`isGrouped`) artificialmente permitia que conteúdo de The War Within não fosse filtrado em Midnight, pois assumiu-se erroneamente que fariam parte da mesma "era" ou patch. Removida essa regra para garantir o bloqueio estrito. Também atualizada a função `IsNeutralHeader` para blindar categorias como "Dungeon and Raid" e "Legacy", permitindo que o usuário as exiba manualmente.
  - Quinta correção (Edge Case): A moeda `Untethered Coin` de The War Within continuava aparecendo em Midnight após a Quarta Correção. Causa raiz: A interface do WoW agrupa as moedas antigas sob o cabeçalho "Legacy", seguido pelo sub-cabeçalho "War Within" (sem o 'The'). Como nosso `HEADER_TO_EXPANSION` só conhecia `"the war within"`, o cabeçalho era ignorado, ativando o fallback por ID. Acontece que a `Untethered Coin` tem um ID muito alto (adicionada no fim de TWW) e o fallback a classificava como "Midnight" (ID >= 3300), burlando o filtro. Correção: Adicionado o termo `"war within"` (sem o The) à tabela `HEADER_TO_EXPANSION`, garantindo que o cabeçalho original tome precedência e classifique a moeda corretamente sem precisar usar o fallback por ID.

### Tarefas Pendentes
- [x] Corrigir erro LUA `bad argument #1 to 'GetMapInfo'` em `UpdateDebugDisplay` — Ocorre quando o `mapID` retornado por `C_Map.GetBestMapForUnit("player")` é nulo.
- [x] Proteger botão "Show Current Map Info" contra `mapID` nulo.
- [x] Proteger botão "Show Map Hierarchy" contra `mapID` nulo.
- [x] Incluir todas as opções de configuração dentro do ScrollFrame.
- [x] Corrigir escaneamento de moedas em tempo real e duplicação de itens adicionados manualmente.
- [x] Atualizar compatibilidade para WoW 12.1.0 (120100) e liberar moedas da categoria Zones/Warband ocultadas pelo autoFilterRegion.
- [x] Corrigir autoFilterRegion: moedas de zonas como Khaz Algar/Undermine (TWW) apareciam em Midnight porque o C_CurrencyInfo usa nomes de zona, não de expansão.
