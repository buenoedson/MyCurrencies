# My Currencies Tracker

## [2026.11.01.1]
| API/Evento antigo | Substituto ou ação | Patch | Fonte |
|---|---|---|---|
| `GET_ITEM_INFO_RECEIVED` (irrestrito) | Filtrado com guarda $O(1)$ por ID de item pendente (`pendingItemQueries`) | 12.1.5 | https://warcraft.wiki.gg/wiki/GET_ITEM_INFO_RECEIVED |
| `CURRENCY_DISPLAY_UPDATE` (`LoadGameCurrencies`) | Removida reinicialização da árvore de moedas; aciona apenas `RequestUpdateDisplay()` | 12.1.5 | https://warcraft.wiki.gg/wiki/CURRENCY_DISPLAY_UPDATE |
| Concatenações de string no laço de renderização | Precomputação de chaves `data.key` no carregamento da base | 12.1.5 | https://warcraft.wiki.gg/wiki/World_of_Warcraft_API |
| `UpdateDebugDisplay` closures | Handlers estáticos de `OnEnter`/`OnLeave` atribuídos uma vez em `CreateDebugFrame` | 12.1.5 | https://warcraft.wiki.gg/wiki/World_of_Warcraft_API |
| Disparos síncronos imediatos de renderização | Debounce de 50ms (`RequestUpdateDisplay`) consolidando múltiplos eventos | 12.1.5 | https://warcraft.wiki.gg/wiki/World_of_Warcraft_API |
| Coleta de lixo pós-inicialização | Chamada pontual de `collectgarbage("collect")` após inicialização e mutação de itens | 12.1.5 | https://warcraft.wiki.gg/wiki/World_of_Warcraft_API |

## [2026.10.13.1]
| API/Evento antigo | Substituto ou ação | Patch | Fonte |
|---|---|---|---|
| `## Interface: 120100` | Atualizado para `120105` | 12.1.5 | https://warcraft.wiki.gg/wiki/TOC_format |
| APIs `C_CurrencyInfo.*`, `C_Item.*`, `C_Container.*`, `C_Map.*` | Auditadas e validadas; total conformidade com o runtime 12.1.5 | 12.1.5 | https://warcraft.wiki.gg/wiki/World_of_Warcraft_API |
| Restrições de Auras de Combate | Addon não consome dados de combate/auras; não afetado pelas restrições do Patch 12.1.5 | 12.1.5 | https://warcraft.wiki.gg/wiki/World_of_Warcraft_API |

## [v2026.09.15.1](https://github.com/buenoedson/MyCurrencies/tree/v2026.09.15.1) (2026-09-15)
[Full Changelog](https://github.com/buenoedson/MyCurrencies/compare/v2026.09.04.1...v2026.09.15.1) 

- update  
- update  
