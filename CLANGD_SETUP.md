# C++ Konfiguration för LazyVim på NixOS

Här är en sammanfattning av vad som gjordes för att få C++-miljön (clangd) att fungera robust på NixOS, samt hur det fungerar under huven.

## Problemet
1.  **NixOS struktur:** C++ standardbibliotek (som `<iostream>`) ligger på unika hash-sökvägar i `/nix/store`, inte i `/usr/include` som på vanliga Linux-distributioner.
2.  **Fel drivrutin:** `clangd` (språkservern) försöker som standard agera som `clang`, men systemet har `g++` (GCC) installerat.
3.  **Språkfel:** `g++` gav felmeddelanden på svenska, vilket gjorde att `clangd` inte kunde parsa sökvägarna till biblioteken korrekt.
4.  **Säkerhet:** `clangd` vägrar av säkerhetsskäl att köra externa kompilatorer för att hitta headers om de inte är vitlistade via flaggan `--query-driver`.

## Lösningen

Lösningen är uppdelad i två delar för att vara **dynamisk** och överleva systemuppdateringar.

### 1. Neovim Konfiguration (`lua/plugins/lsp.lua`)
Vi ändrade hur `clangd` startas inifrån Neovim för att:

*   **Hitta kompilatorn dynamiskt:** Vi använder `vim.fn.exepath("g++")` för att automatiskt hitta var `g++` ligger just nu (även om Nix flyttar den efter en uppdatering).
*   **Vitlista drivrutinen:** Vi skickar med flaggan `--query-driver=<din-g++-sökväg>`. Detta ger `clangd` tillåtelse att köra kompilatorn för att fråga: *"Var ligger dina bibliotek?"*.
*   **Tvinga engelska (LC_ALL=C):** Vi sätter miljömvariabeln `LC_ALL` till `C` för `clangd`-processen. Detta tvingar `g++` att svara på engelska så att `clangd` kan förstå och använda sökvägarna.

### 2. Clangd Konfiguration (`~/.config/clangd/config.yaml`)
Vi skapade en global konfigurationsfil för `clangd` med följande innehåll:

```yaml
CompileFlags:
  Compiler: g++
```

Detta instruerar `clangd`: *"Försök inte vara clang, använd g++ som drivrutin istället"*. Utan denna försöker `clangd` ibland använda fel flaggor som inte är kompatibla med GCC.

## Resultat
Du har nu en setup som är:
*   **Reproducerbar:** Inga hårdkodade hash-sökvägar i din config.
*   **Automatisk:** Fungerar direkt även om du uppdaterar GCC via Nix.
*   **Ren:** Swap-filsvarningar (W325) har rensats bort.

## För att fortsätta
Du behöver bara se till att `g++` (gcc) finns tillgängligt i din terminal (vilket det gör via din nix-profile), så sköter Neovim resten automatiskt vid uppstart.
