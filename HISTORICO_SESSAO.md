# Histórico de Sessão - MyCurrencies
# Última modificação: 24/08/2026

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
  - Refatoração do método `LoadGameCurrencies` em `MyCurrencies.lua`.
  - Integração de `customItems` no processo de desduplicação.
- **Decisões:**
  - Garantir desduplicação estrita via chave composta `(tipo .. ":" .. id)`.

### 11/08/2026: Atualização de Compatibilidade do Patch 12.1.0 e Correção do Filtro Regional
- **Ações:**
  - Atualização da versão do manifesto em [MyCurrencies.toc](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/MyCurrencies.toc) para `120100`.
  - Tratar sistemas cross-expansão/evergreen como neutros/globais.

### 24/08/2026: Adição de Opção para Ocultar em Combate, Reordenação de Ícones e Atualização de Versão
- **Ações:**
  - Adicionada a opção `hideInCombat` nas configurações salvas (`MyCurrenciesDB.hideInCombat`) e na tabela de padrões `defaults`.
  - Registrados eventos `PLAYER_REGEN_DISABLED` e `PLAYER_REGEN_ENABLED` no frame principal para atualização dinâmica da visibilidade.
  - Adicionada checagem `InCombatLockdown()` no método `UpdateDisplay()`.
  - Criado checkbox `cbCombat` ("Ocultar durante o combate") no painel de opções.
  - Criado mecanismo de drag-and-drop no `CreateIconFrame` ativado quando `IsControlKeyDown()` é verdadeiro.
  - Criadas funções `ReorderTrackedData` e `SaveCustomOrder` para persistir a ordem customizada dos ícones em `MyCurrenciesDB.customOrder`.
  - Atualizado o escaneamento `LoadGameCurrencies()` para ordenar `trackedData` segundo `MyCurrenciesDB.customOrder`.
  - Adicionadas chaves de tradução `HIDE_IN_COMBAT` e `REORDER_HINT` no arquivo [Localization.lua](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/Localization.lua).
  - Atualizada a versão do Addon no arquivo [MyCurrencies.toc](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/MyCurrencies.toc) para `2026.08.24.1`.
  - Atualizada a documentação em [README.md](file:///c:/Program%20Files%20%28x86%29/World%20of%20Warcraft/_retail_/Interface/AddOns/MyCurrencies/README.md) com as novas funcionalidades (reordenação por Control + Drag, ocultar em combate e painel rolável) e versão `2026.08.24.1`.
- **Decisões:**
  - Manter a movimentação comum da janela ao arrastar sem segurar Control, e acionar a troca de posição entre ícones apenas ao arrastar com Control pressionado.

### Tarefas Pendentes
- [x] Corrigir erro LUA `bad argument #1 to 'GetMapInfo'` em `UpdateDebugDisplay` — Ocorre quando o `mapID` retornado por `C_Map.GetBestMapForUnit("player")` é nulo.
- [x] Proteger botão "Show Current Map Info" contra `mapID` nulo.
- [x] Proteger botão "Show Map Hierarchy" contra `mapID` nulo.
- [x] Incluir todas as opções de configuração dentro do ScrollFrame.
- [x] Corrigir escaneamento de moedas em tempo real e duplicação de itens adicionados manualmente.
- [x] Atualizar compatibilidade para WoW 12.1.0 (120100) e liberar moedas da categoria Zones/Warband ocultadas pelo autoFilterRegion.
- [x] Corrigir autoFilterRegion: moedas de zonas como Khaz Algar/Undermine (TWW) apareciam em Midnight.
- [x] Adicionar opção de ocultar a interface durante combate.
- [x] Adicionar funcionalidade de alterar ordem dos ícones segurando Control e arrastando.
- [x] Atualizar a versão do Addon no arquivo `MyCurrencies.toc` para `2026.08.24.1`.
- [x] Atualizar a documentação do `README.md` com as novas funcionalidades e versão.
