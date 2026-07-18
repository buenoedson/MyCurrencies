# Histórico de Sessão - MyCurrencies
# Última modificação: 18/07/2026

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

### Tarefas Pendentes
- [x] Corrigir erro LUA `bad argument #1 to 'GetMapInfo'` em `UpdateDebugDisplay` — Ocorre quando o `mapID` retornado por `C_Map.GetBestMapForUnit("player")` é nulo (ex: em telas de carregamento ou instâncias).
- [x] Proteger botão "Show Current Map Info" contra `mapID` nulo — Evitar o mesmo erro no painel de opções.
- [x] Proteger botão "Show Map Hierarchy" contra `mapID` nulo — Evitar que processe hierarquia sem ID válido.
