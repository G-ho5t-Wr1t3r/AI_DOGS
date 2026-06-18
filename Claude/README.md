<details>
<summary><b>IT</b></summary>

# Istruzioni

> DISCLAIMER:
> A differenza della versione Gemini, questo Dockerfile **non** installa la skill `superpowers`.
> Se la vuoi, installala al volo dentro una sessione di Claude con:
> ```
> /plugin marketplace add obra/superpowers-marketplace
> /plugin install superpowers@superpowers-marketplace
> ```

# Installazione

<!-- Docker installation section -->
<details>
  <summary><b>🐳 Docker</b></summary>

Per costruire l'immagine per la prima volta runnare il comando (dalla cartella `Claude/`)
```
docker build -t claude-env .
```

Creazione del volume per il login a Claude
```
docker volume create claude-auth-data
```

> Primo avvio & Login (Linux)
> ```
> docker run -it --rm \
>  -v /home/node/.claude \
>  claude-env
> ```

> Primo avvio & Login (Windows)
> ```
> docker run -it --rm `
>   -v /home/node/.claude `
>   claude-env
> ```

Una volta dentro il container eseguire
```
claude
```

> In alternativa, per saltare il login interattivo puoi passare direttamente la tua API key:
> `-e ANTHROPIC_API_KEY=sk-ant-...`

Uso quotidiano
```
docker run -it --rm \
  -v /percorso/cartella/contesto:/mnt/host_context \
  -v /home/node/.claude \
  -v ~/Desktop/Coding/Claude/claude_output:/app/output \
  claude-env
```

Per trovare l'id del container
```
docker ps
```
Per spegnere il container
```
docker stop <ID_CONTAINER>
```

Per eliminare l'immagine, verificare il nome corretto
```
docker images
```
Rimozione effettiva
```
docker rmi claude-env
```
Pulizia profonda
```
docker system prune -f
```

</details>

<!-- Podman installation section -->
<details>
  <summary><b>🎩 Podman</b></summary>

> Flag Fondamentale!
> Il flag `:Z` nei percorsi locali dell'uso quotidiano garantisce che `SELinux` (su Bluefin o altre distro immutabili) permetta al container di leggere e scrivere correttamente nelle cartelle.

Per costruire l'immagine per la prima volta runnare il comando (dalla cartella `Claude/`)
```bash
podman build -t claude-env .
```

Creazione del volume per il login a Claude
```bash
podman volume create claude-auth-data
```

> Primo avvio & Login (Linux)
> ```bash
> podman run -it --rm \
>   -v /home/node/.claude \
>   claude-env
> ```

> Primo avvio & Login (Windows)
> ```powershell
> podman run -it --rm `
>    -v /home/node/.claude `
>    claude-env
> ```

Una volta dentro il container eseguire
```bash
claude
```

Uso quotidiano
```bash
podman run -it --rm \
  -v /percorso/cartella/contesto:/mnt/host_context:Z \
  -v /home/node/.claude \
  -v ~/Desktop/Coding/Claude/claude_output:/app/output:Z \
  claude-env
```

Per trovare l'id del container
```bash
podman ps
```

Per spegnere il container
```bash
podman stop <ID_CONTAINER>
```

Per eliminare l'immagine, verificare il nome corretto
```bash
podman images
```

Rimozione effettiva
```bash
podman rmi claude-env
```

Pulizia profonda
```bash
podman system prune -f
```

</details>

# La skill "Claudio" (auto-migliorante)

Questo ambiente include **Claudio**, una skill personale che governa come vengono gestiti i file e che può migliorare se stessa nel tempo.

* **Le modifiche vanno in `/app/output`:** ogni file che chiedi di creare o modificare viene salvato lì, mantenendo lo stesso percorso relativo.
* **`/app/context` è solo riferimento:** è il punto di partenza, in sola lettura. Non viene mai modificato.
* **Auto-miglioramento:** se dici *"aggiungi alla skill: ..."* (oppure "ricorda", "d'ora in poi"...), Claudio scrive la nuova regola direttamente nel suo `SKILL.md`, e te lo conferma. Le regole apprese restano salvate nel volume persistente.

> A inizio di ogni sessione un **SessionStart hook** fa sì che Claudio si presenti e ti ricordi che è migliorabile al volo.

File coinvolti (nel volume `/root/.claude`):
`skills/claudio/SKILL.md` · `CLAUDE.md` · `hooks/claudio-session-start.sh` · `settings.json`

# Su quali OS funziona?

Struttura della repo:
```
.
├───.utils
│   │   kill-frozen-container.py
│   ├───Linux_Utilities
│   │       orchestrator.sh
│   │       README.md
│   └───Windows_Utilities
│           Setup.bat
│           Launcher.bat
│           Remove_Containers.bat
│           README.md
└───Claude
        Dockerfile
        entrypoint.sh
        utility.sh
        README.md
```
Gli script di utilità (setup, avvio, rimozione) sono centralizzati in `.utils`, divisi per OS. Verifica il contenuto di `Linux_Utilities` o `Windows_Utilities` in base al tuo sistema.

</details>

<details open>
<summary><b>EN</b></summary>

# Instructions

> DISCLAIMER:
> Unlike the Gemini version, this Dockerfile does **not** install the `superpowers` skill.
> If you want it, install it on the fly inside a Claude session with:
> ```
> /plugin marketplace add obra/superpowers-marketplace
> /plugin install superpowers@superpowers-marketplace
> ```

# Installation

<!-- Docker installation section -->
<details>
  <summary><b>🐳 Docker</b></summary>

To build the image for the first time, run the command (from the `Claude/` folder)
```
docker build -t claude-env .
```

Create the volume for the Claude login
```
docker volume create claude-auth-data
```

> First launch & Login (Linux)
> ```
> docker run -it --rm \
>  -v /home/node/.claude \
>  claude-env
> ```

> First launch & Login (Windows)
> ```
> docker run -it --rm `
>   -v /home/node/.claude `
>   claude-env
> ```

Once inside the container, run
```
claude
```

> Alternatively, to skip the interactive login you can pass your API key directly:
> `-e ANTHROPIC_API_KEY=sk-ant-...`

Daily use
```
docker run -it --rm \
  -v /path/to/context/folder:/mnt/host_context \
  -v /home/node/.claude \
  -v ~/Desktop/Coding/Claude/claude_output:/app/output \
  claude-env
```

To find the container id
```
docker ps
```
To stop the container
```
docker stop <CONTAINER_ID>
```

To remove the image, check the correct name first
```
docker images
```
Actual removal
```
docker rmi claude-env
```
Deep cleanup
```
docker system prune -f
```

</details>

<!-- Podman installation section -->
<details>
  <summary><b>🎩 Podman</b></summary>

> Essential Flag!
> The `:Z` flag on the local paths in daily use makes sure `SELinux` (on Bluefin or other immutable distros) lets the container read and write to the folders correctly.

To build the image for the first time, run the command (from the `Claude/` folder)
```bash
podman build -t claude-env .
```

Create the volume for the Claude login
```bash
podman volume create claude-auth-data
```

> First launch & Login (Linux)
> ```bash
> podman run -it --rm \
>   -v /home/node/.claude \
>   claude-env
> ```

> First launch & Login (Windows)
> ```powershell
> podman run -it --rm `
>    -v /home/node/.claude `
>    claude-env
> ```

Once inside the container, run
```bash
claude
```

Daily use
```bash
podman run -it --rm \
  -v /path/to/context/folder:/mnt/host_context:Z \
  -v /home/node/.claude \
  -v ~/Desktop/Coding/Claude/claude_output:/app/output:Z \
  claude-env
```

To find the container id
```bash
podman ps
```

To stop the container
```bash
podman stop <CONTAINER_ID>
```

To remove the image, check the correct name first
```bash
podman images
```

Actual removal
```bash
podman rmi claude-env
```

Deep cleanup
```bash
podman system prune -f
```

</details>

# The "Claudio" skill (self-improving)

This environment includes **Claudio**, a personal skill that governs how files are handled and that can improve itself over time.

* **Edits go to `/app/output`:** every file you ask to create or modify is saved there, keeping the same relative path.
* **`/app/context` is reference only:** it's the read-only starting point. It is never modified.
* **Self-improvement:** if you say *"add to the skill: ..."* (or "remember", "from now on"...), Claudio writes the new rule straight into its `SKILL.md` and confirms it. Learned rules persist in the persistent volume.

> At the start of every session a **SessionStart hook** makes Claudio introduce itself and remind you it can be improved on the fly.

Files involved (in the `/root/.claude` volume):
`skills/claudio/SKILL.md` · `CLAUDE.md` · `hooks/claudio-session-start.sh` · `settings.json`

# Which OSes does it work on?

Repo structure:
```
.
├───.utils
│   │   kill-frozen-container.py
│   ├───Linux_Utilities
│   │       orchestrator.sh
│   │       README.md
│   └───Windows_Utilities
│           Setup.bat
│           Launcher.bat
│           Remove_Containers.bat
│           README.md
└───Claude
        Dockerfile
        entrypoint.sh
        utility.sh
        README.md
```
The utility scripts (setup, launch, removal) are centralized in `.utils`, split by OS. Check the contents of `Linux_Utilities` or `Windows_Utilities` depending on your system.

</details>