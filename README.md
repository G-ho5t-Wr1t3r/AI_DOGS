# AI DOGS

<details>
<summary><b>IT</b></summary>

## Overview

Ambienti Docker/Podman pronti all'uso per far girare le CLI di **Claude** e **Gemini** dentro container isolati, con login persistente, montaggio del progetto su cui lavori e una cartella di output dedicata. Tutta la gestione (build, avvio, rimozione) è automatizzata da script per Linux e Windows.

## Cosa offre

* **Due ambienti separati:** `claude-env` e `gemini-env`, ognuno con il suo Dockerfile.
* **Login persistente:** fai il login una volta, le credenziali restano salvate in un volume Docker e non te le richiede più.
* **Contesto e output:** monti la cartella del progetto come riferimento e raccogli i risultati in una cartella di output dedicata.
* **Script multi-OS:** utility per Linux e Windows che gestiscono setup, avvio per-progetto e pulizia.
* **Skill "Claudio" (solo Claude):** una skill auto-migliorante che impara nuove regole quando glielo chiedi. Dettagli nel README della cartella `Claude`.

## Struttura della repo

```
.
│   README.md                      <- questo file
│
├───.utils                         <- script di utilità, divisi per OS
│   │   kill-frozen-container.py
│   ├───Linux_Utilities
│   │       orchestrator.sh
│   │       README.md
│   └───Windows_Utilities
│           Setup.bat
│           Launcher.bat
│           Remove_Containers.bat
│           README.md
│
├───Claude                         <- ambiente Claude
│   │   Dockerfile
│   │   entrypoint.sh
│   │   utility.sh
│   │   CLAUDE.md
│   │   README.md
│   │   .claudio/                   <- skill "Claudio" + hook + settings
│   └───claude_output/
│
└───Gemini                         <- ambiente Gemini
    │   Dockerfile
    │   entrypoint.sh
    │   utility.sh
    │   MEMORY_EXAMPLE.md
    │   README.md
    └───gemini_output/
```

## Come si parte

Il flusso è sempre lo stesso: **Setup una volta → avvio per ogni progetto → pulizia quando serve.**

### Windows (script automatici)

Gli script sono in `.utils/Windows_Utilities/`:

1. **`Setup.bat`** — una volta per ambiente: costruisce l'immagine, crea i volumi e ti fa fare il login.
2. **`Launcher.bat`** — l'avvio di tutti i giorni: scegli Claude o Gemini, indichi il progetto e parti.
3. **`Remove_Containers.bat`** — rimozione mirata di container, immagine e volumi di un ambiente.

### Linux (script automatico)

In `.utils/Linux_Utilities/` trovi `orchestrator.sh`, che con due flag gestisce setup e rimozione:

```bash
./orchestrator.sh -c -s    # Claude, Setup
./orchestrator.sh -g -d    # Gemini, Delete
```

### Modalità manuale (Docker / Podman)

Se preferisci lanciare i comandi a mano, ogni ambiente ha la sua guida passo-passo:

* 🐳/🎩 **Claude:** vedi `Claude/README.md`
* 🐳/🎩 **Gemini:** vedi `Gemini/README.md`

## Dove approfondire

| README | Cosa contiene |
| --- | --- |
| `Claude/README.md` | Uso manuale (Docker/Podman) di Claude e la skill Claudio |
| `Gemini/README.md` | Uso manuale (Docker/Podman) di Gemini |
| `.utils/Windows_Utilities/README.md` | Setup, Launcher e Remove su Windows |
| `.utils/Linux_Utilities/README.md` | Orchestrator su Linux |

## Su quali OS funziona?

Ovunque giri Docker o Podman: Linux, Windows (con WSL2) e macOS. Verifica gli script in `Linux_Utilities` o `Windows_Utilities` in base al tuo sistema.

</details>

<details open>
<summary><b>EN</b></summary>

## Overview

Ready-to-use Docker/Podman environments to run the **Claude** and **Gemini** CLIs inside isolated containers, with persistent login, mounting of the project you're working on, and a dedicated output folder. The whole lifecycle (build, launch, removal) is automated by scripts for Linux and Windows.

## What it gives you

* **Two separate environments:** `claude-env` and `gemini-env`, each with its own Dockerfile.
* **Persistent login:** log in once, the credentials stay saved in a Docker volume and you won't be asked again.
* **Context and output:** mount your project folder as reference and collect results in a dedicated output folder.
* **Multi-OS scripts:** utilities for Linux and Windows that handle setup, per-project launch and cleanup.
* **"Claudio" skill (Claude only):** a self-improving skill that learns new rules when you ask it to. Details in the `Claude` folder README.

## Repo structure

```
.
│   README.md                      <- this file
│
├───.utils                         <- utility scripts, split by OS
│   │   kill-frozen-container.py
│   ├───Linux_Utilities
│   │       orchestrator.sh
│   │       README.md
│   └───Windows_Utilities
│           Setup.bat
│           Launcher.bat
│           Remove_Containers.bat
│           README.md
│
├───Claude                         <- Claude environment
│   │   Dockerfile
│   │   entrypoint.sh
│   │   utility.sh
│   │   CLAUDE.md
│   │   README.md
│   │   .claudio/                   <- "Claudio" skill + hook + settings
│   └───claude_output/
│
└───Gemini                         <- Gemini environment
    │   Dockerfile
    │   entrypoint.sh
    │   utility.sh
    │   MEMORY_EXAMPLE.md
    │   README.md
    └───gemini_output/
```

## Getting started

The flow is always the same: **set up once → launch per project → clean up when needed.**

### Windows (automatic scripts)

The scripts live in `.utils/Windows_Utilities/`:

1. **`Setup.bat`** — once per environment: builds the image, creates the volumes and walks you through login.
2. **`Launcher.bat`** — the day-to-day launcher: pick Claude or Gemini, point it at your project and go.
3. **`Remove_Containers.bat`** — targeted removal of an environment's containers, image and volumes.

### Linux (automatic script)

In `.utils/Linux_Utilities/` you'll find `orchestrator.sh`, which handles setup and removal with two flags:

```bash
./orchestrator.sh -c -s    # Claude, Setup
./orchestrator.sh -g -d    # Gemini, Delete
```

### Manual mode (Docker / Podman)

If you'd rather run the commands by hand, each environment has its own step-by-step guide:

* 🐳/🎩 **Claude:** see `Claude/README.md`
* 🐳/🎩 **Gemini:** see `Gemini/README.md`

## Where to dig deeper

| README | What it covers |
| --- | --- |
| `Claude/README.md` | Manual (Docker/Podman) use of Claude and the Claudio skill |
| `Gemini/README.md` | Manual (Docker/Podman) use of Gemini |
| `.utils/Windows_Utilities/README.md` | Setup, Launcher and Remove on Windows |
| `.utils/Linux_Utilities/README.md` | Orchestrator on Linux |

## Which OSes does it work on?

Anywhere Docker or Podman runs: Linux, Windows (with WSL2) and macOS. Check the scripts in `Linux_Utilities` or `Windows_Utilities` depending on your system.

</details>