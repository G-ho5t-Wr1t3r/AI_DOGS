<details>
<summary><b>IT</b></summary>

# Runner Docker per Claude & Gemini Env (Windows)

Questi script Batch automatizzano e semplificano l'avvio dei container Docker `claude-env` e `gemini-env` su sistemi Windows. Risolvono i comuni problemi di formattazione dei percorsi e garantiscono che la sessione di login (autenticazione) rimanga salvata tra un riavvio e l'altro. Tutto vive in un unico posto, `.utils\Windows_Utilities\`, e all'avvio puoi scegliere quale ambiente usare: Claude o Gemini.

## 📁 Posizione e struttura

Gli script vanno tenuti dentro `.utils\Windows_Utilities\`, con le cartelle `Claude` e `Gemini` come sorelle di `.utils`:

```
D:.
├───.utils
│   └───Windows_Utilities
│           Setup.bat
│           Launcher.bat
│           Remove_Containers.bat
├───Claude
│       Dockerfile
│       ...
└───Gemini
        Dockerfile
        ...
```

> Importante: `Setup.bat` costruisce l'immagine usando il percorso relativo `..\..\Claude` (o `..\..\Gemini`) rispetto a sé stesso. Se sposti gli script o cambi la struttura, l'unica riga da aggiornare è `BUILD_DIR` dentro `Setup.bat`.

## Prerequisiti

1. **Docker Desktop** installato, in esecuzione e con l'integrazione WSL2 attiva.
2. **Nessuna build manuale richiesta:** ci pensa `Setup.bat` a compilare l'immagine la prima volta.

## I tre script

* **`Setup.bat`** → da eseguire **una sola volta per ambiente**. Costruisce l'immagine, crea i volumi persistenti e avvia il container per il login.
* **`Launcher.bat`** → l'avvio di tutti i giorni, **per ogni singolo progetto**.
* **`Remove_Containers.bat`** → pulizia mirata di container, immagine e volumi di un ambiente.

## Primo avvio: `Setup.bat`

1. Fai doppio clic su `Setup.bat`.
2. Scegli l'ambiente: `C` per Claude, `G` per Gemini.
3. Lo script compila l'immagine, crea i volumi e apre il container.
4. **Effettua il login dentro il container.** Per Claude lancia `claude` e segui la procedura; per Gemini lancia `gemini`.
5. Quando hai finito digita `exit`: le credenziali restano salvate nel volume e non dovrai più rifare il login.

## Uso quotidiano: `Launcher.bat`

1. Fai doppio clic su `Launcher.bat`.
2. **Step 0:** Scegli l'ambiente (`C`/`G`).
3. **Step 1:** Inserisci il percorso assoluto della cartella del tuo progetto (es. `D:\MieiProgetti\Progetto`).
4. **Step 2:** Scegli il percorso di output. Premi **INVIO** per usare quello di default, oppure scrivine uno nuovo.
5. **Conferma:** Lo script ti mostra un riepilogo. Digita `Y` per confermare o `N` per correggere i dati.

## Funzionalità "Avvio Rapido" (Shortcut)

Se lavori spesso sullo stesso progetto, lo script ti offre la possibilità di creare un **file di avvio rapido** (es. `run_Claude_Progetto.bat`).

* **Cosa fa:** Crea un nuovo mini-script configurato con l'ambiente e i percorsi esatti che hai appena inserito.
* **Vantaggio:** La prossima volta ti basterà fare doppio clic sul file di avvio rapido per lanciare direttamente il container, senza dover ripetere la procedura.

## Mappatura dei Volumi Docker

Il `Launcher.bat` mappa automaticamente 4 volumi fondamentali (i nomi cambiano in base all'ambiente scelto):

* `-v "%PROJECT_PATH%:/mnt/host_context"`
  > Collega la cartella del tuo progetto al container. Lo script `entrypoint.sh` interno si occuperà poi di sincronizzarla nella cartella di lavoro.
* `-v "<ambiente>-config-data:/root/.config"`
  > Crea un volume Docker persistente per salvare i file di configurazione generici delle CLI.
* `-v "<ambiente>-auth-data:/root/.claude"` (per Claude) oppure `:/root/.gemini` (per Gemini)
  > **Cruciale per il Login:** Salva i token di autenticazione in modo persistente. Evita di dover rifare il login ogni volta che avvii il container. Per Claude il percorso è `/root/.claude`, coerente con la variabile `CLAUDE_CONFIG_DIR` impostata nel Dockerfile.
* `-v "%FINAL_OUT_PATH%:/app/output"`
  > Collega la cartella di output dove la CLI salverà eventuali risultati o file generati.

> I volumi usati da `Setup.bat` e `Launcher.bat` coincidono di proposito: il login fatto durante il setup viene ritrovato a ogni avvio del progetto.

## Rimozione: `Remove_Containers.bat`

1. Fai doppio clic su `Remove_Containers.bat`.
2. Scegli l'ambiente (`C`/`G`) e conferma.
3. Lo script rimuove **solo** i container di quell'immagine, l'immagine stessa e i suoi due volumi.

> Niente `docker system prune` globale: la pulizia è mirata e non tocca gli altri progetti Docker presenti sul tuo sistema.

## ⚠️ Risoluzione dei Problemi

* **Il terminale si chiude subito all'avvio:** Assicurati che Docker Desktop sia aperto e l'icona della balena in basso a destra sia verde/avviata. Avvia sempre con doppio clic (serve il terminale interattivo).
* **Errore "Image not found":** Esegui prima `Setup.bat` per quell'ambiente: l'immagine `claude-env` / `gemini-env` deve esistere prima di usare il `Launcher.bat`.
* **Richiede il login ogni volta:** Verifica di non aver cancellato manualmente i volumi `*-config-data` o `*-auth-data` da Docker Desktop, e di aver effettuato il login durante il `Setup.bat`.

</details>

<details open>
<summary><b>EN</b></summary>

# Docker Runner for Claude & Gemini Env (Windows)

These Batch scripts automate and simplify starting the `claude-env` and `gemini-env` Docker containers on Windows. They solve the usual path-formatting headaches and make sure your login session (authentication) stays saved across restarts. Everything lives in one place, `.utils\Windows_Utilities\`, and at startup you pick which environment to use: Claude or Gemini.

## 📁 Location and structure

Keep the scripts inside `.utils\Windows_Utilities\`, with the `Claude` and `Gemini` folders as siblings of `.utils`:

```
D:.
├───.utils
│   └───Windows_Utilities
│           Setup.bat
│           Launcher.bat
│           Remove_Containers.bat
├───Claude
│       Dockerfile
│       ...
└───Gemini
        Dockerfile
        ...
```

> Important: `Setup.bat` builds the image using the relative path `..\..\Claude` (or `..\..\Gemini`) from its own location. If you move the scripts or change the structure, the only line to update is `BUILD_DIR` inside `Setup.bat`.


## Prerequisites

1. **Docker Desktop** installed, running, with WSL2 integration enabled.
2. **No manual build required:** `Setup.bat` compiles the image for you the first time.

## The three scripts

* **`Setup.bat`** → run **once per environment**. Builds the image, creates the persistent volumes and starts the container for login.
* **`Launcher.bat`** → the day-to-day launcher, **for each individual project**.
* **`Remove_Containers.bat`** → targeted cleanup of an environment's containers, image and volumes.

## First launch: `Setup.bat`

1. Double-click `Setup.bat`.
2. Pick the environment: `C` for Claude, `G` for Gemini.
3. The script builds the image, creates the volumes and opens the container.
4. **Log in inside the container.** For Claude run `claude` and follow the flow; for Gemini run `gemini`.
5. When you're done type `exit`: the credentials stay saved in the volume, so you won't have to log in again.

## Daily use: `Launcher.bat`

1. Double-click `Launcher.bat`.
2. **Step 0:** Pick the environment (`C`/`G`).
3. **Step 1:** Enter the absolute path of your project folder (e.g. `D:\MyProjects\Project`).
4. **Step 2:** Choose the output path. Press **ENTER** to use the default, or type a new one.
5. **Confirm:** The script shows you a summary. Type `Y` to confirm or `N` to fix the data.

## "Quick Launch" feature (Shortcut)

If you often work on the same project, the script lets you create a **quick-launch file** (e.g. `run_Claude_Project.bat`).

* **What it does:** Creates a new mini-script configured with the exact environment and paths you just entered.
* **Benefit:** Next time you only need to double-click the quick-launch file to start the container directly, with no need to repeat the procedure.

## Docker Volume Mapping

`Launcher.bat` automatically maps 4 essential volumes (the names change depending on the chosen environment):

* `-v "%PROJECT_PATH%:/mnt/host_context"`
  > Connects your project folder to the container. The internal `entrypoint.sh` then syncs it into the working folder.
* `-v "<environment>-config-data:/root/.config"`
  > Creates a persistent Docker volume to store the CLI's generic configuration files.
* `-v "<environment>-auth-data:/root/.claude"` (for Claude) or `:/root/.gemini` (for Gemini)
  > **Crucial for Login:** Saves the authentication tokens persistently. Avoids re-logging in every time you start the container. For Claude the path is `/root/.claude`, matching the `CLAUDE_CONFIG_DIR` variable set in the Dockerfile.
* `-v "%FINAL_OUT_PATH%:/app/output"`
  > Connects the output folder where the CLI will save any results or generated files.

> The volumes used by `Setup.bat` and `Launcher.bat` match on purpose: the login done during setup is found again on every project launch.

## Removal: `Remove_Containers.bat`

1. Double-click `Remove_Containers.bat`.
2. Pick the environment (`C`/`G`) and confirm.
3. The script removes **only** that image's containers, the image itself and its two volumes.

> No global `docker system prune`: the cleanup is targeted and won't touch the other Docker projects on your system.

## ⚠️ Troubleshooting

* **The terminal closes immediately on launch:** Make sure Docker Desktop is open and the whale icon in the bottom-right is green/running. Always start with a double-click (an interactive terminal is required).
* **"Image not found" error:** Run `Setup.bat` for that environment first: the `claude-env` / `gemini-env` image must exist before you use `Launcher.bat`.
* **Asks for login every time:** Check that you haven't manually deleted the `*-config-data` or `*-auth-data` volumes from Docker Desktop, and that you completed the login during `Setup.bat`.

</details>