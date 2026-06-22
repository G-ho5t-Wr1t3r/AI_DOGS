<details>
<summary><b>IT</b></summary>

# Orchestrator Docker per Claude & Gemini (Linux)

Questo script Bash (`orchestrator.sh`) gestisce in un colpo solo la **creazione** (build dell'immagine + login persistente) e la **rimozione** dei container `claude-env` e `gemini-env` su Linux. Scegli l'ambiente e l'azione con due flag e lui fa il resto. Vive in `.utils/Linux_Utilities/`.

## 📁 Posizione e struttura

```
.utils
└───Linux_Utilities
        orchestrator.sh
```

> Nota sul build context: lo script costruisce l'immagine con `docker build -t "$image" .`, quindi usa la **cartella corrente** come contesto. Lancialo dalla cartella che contiene il `Dockerfile` (`Claude/` o `Gemini/`), oppure adatta quel `.` al percorso giusto.

## ⚠️ DISCLAIMER!

Apri `orchestrator.sh` e sostituisci i percorsi placeholder con i tuoi reali:

* `~/Desktop/CHANGEME` → la cartella del progetto da montare.

## Prerequisiti

1. **Docker** installato e in esecuzione.
2. Permessi di esecuzione sullo script: `chmod +x orchestrator.sh`.

## Come si usa

```bash
./orchestrator.sh -<target> -<azione>
```

* **Target** (obbligatorio, sceglierne **uno**): `-c` Claude · `-g` Gemini
* **Azione** (obbligatorio, sceglierne **una**): `-s` Setup · `-d` Delete

Esempi:

```bash
./orchestrator.sh -c -s    # build di claude-env, crea il volume, avvia per il login
./orchestrator.sh -g -d    # rimuove gemini-env e il suo volume
```

> Lo script accetta **esattamente un target e un'azione**: qualsiasi altra combinazione (zero flag, due target, ecc.) stampa l'usage ed esce.

## Cosa fa `-s` (Setup)

1. Builda l'immagine `<ambiente>-env`.
2. Crea il volume persistente `<ambiente>-auth-data`.
3. Avvia il container: qui effettui il **login** (per Claude lancia `claude`). Le credenziali restano nel volume e non dovrai rifarlo.

## Cosa fa `-d` (Delete)

1. Rimuove l'immagine `<ambiente>-env`.
2. Rimuove il volume `<ambiente>-auth-data`.
3. Esegue `docker system prune -f`.

> ⚠️ Attenzione: a differenza della versione Windows, qui il `docker system prune -f` è **globale** e ripulisce il dangling di tutto il sistema Docker, non solo di questo ambiente. Se non lo vuoi, togli quella riga.

## Mappatura dei Volumi Docker

In fase di Setup lo script monta:

* `-v ~/Desktop/CHANGEME:/mnt/host_context`
  > La cartella del progetto, che l'`entrypoint.sh` sincronizza poi internamente.
* `-v "<ambiente>-auth-data":/root`
  > **Cruciale per il Login:** su Linux viene montata l'**intera home di root** in un unico volume, così token di autenticazione e configurazione persistono insieme.
* `-v "<output_dir>":/app/output`
  > La cartella dove la CLI salva i risultati.

## 🐧 Nota per chi vive su Linux

Qui non ti serve tutto l'apparato di launcher e doppi clic che tocca sopportare su Windows. Per l'avvio quotidiano di un progetto ti basta insegnare alla tua shell un trucchetto: aggiungi una funzione al tuo `~/.bashrc` (o `~/.zshrc`).

<details open>
	<summary><b>docker</b></summary>
```bash
claude-run() {
    docker run -it --rm \
        --userns=keep-id \
        -v "$PWD:/mnt/host_context" \
        -v claude-auth-data:/home/node/.claude \
        -v $PWD:/app/output \
        claude-env
}
```
</details>

<details>
	<summary><b>podman</b></summary>
```bash
claude-run() {
    podman run -it --rm \
        --userns=keep-id \
        -v "$PWD:/mnt/host_context:Z" \
        -v claude-auth-data:/home/node/.claude:Z \
        -v "$PWD:/app/output:Z" \
        claude-env
}
```
</details>

Poi ricarichi la shell con `source ~/.bashrc` (o `~/.zshrc`) e da qualunque cartella di progetto ti basta digitare `claude-run`. Niente script dedicato, niente percorsi da riscrivere ogni volta: il `$PWD` ci pensa da solo. 

## ⚠️ Risoluzione dei Problemi

* **`permission denied` al lancio:** dagli i permessi con `chmod +x orchestrator.sh`.
* **Build che non trova il Dockerfile:** ricorda che il contesto è la cartella corrente; lancialo da `Claude/` o `Gemini/`.
* **Chiede il login ogni volta:** assicurati di non aver cancellato il volume `<ambiente>-auth-data` e di usare lo stesso mount (`:/root`) anche nella funzione della tua shell.

</details>

<details open>
<summary><b>EN</b></summary>

# Docker Orchestrator for Claude & Gemini (Linux)

This Bash script (`orchestrator.sh`) handles both the **creation** (image build + persistent login) and the **removal** of the `claude-env` and `gemini-env` containers on Linux, all in one go. You pick the environment and the action with two flags and it does the rest. It lives in `.utils/Linux_Utilities/`.

## 📁 Location and structure

```
.utils
└───Linux_Utilities
        orchestrator.sh
```

> Note on the build context: the script builds the image with `docker build -t "$image" .`, so it uses the **current directory** as context. Run it from the folder that contains the `Dockerfile` (`Claude/` or `Gemini/`), or adjust that `.` to the right path.

## ⚠️ DISCLAIMER!

Open `orchestrator.sh` and replace the placeholder paths with your real ones:

* `~/Desktop/CHANGEME` → the project folder to mount.

## Prerequisites

1. **Docker** installed and running.
2. Execution permission on the script: `chmod +x orchestrator.sh`.

## How to use it

```bash
./orchestrator.sh -<target> -<action>
```

* **Target** (required, pick **one**): `-c` Claude · `-g` Gemini
* **Action** (required, pick **one**): `-s` Setup · `-d` Delete

Examples:

```bash
./orchestrator.sh -c -s    # build claude-env, create the volume, start for login
./orchestrator.sh -g -d    # remove gemini-env and its volume
```

> The script accepts **exactly one target and one action**: any other combination (no flags, two targets, etc.) prints the usage and exits.

## What `-s` (Setup) does

1. Builds the `<environment>-env` image.
2. Creates the persistent `<environment>-auth-data` volume.
3. Starts the container: this is where you **log in** (for Claude run `claude`). Credentials stay in the volume so you won't have to redo it.

## What `-d` (Delete) does

1. Removes the `<environment>-env` image.
2. Removes the `<environment>-auth-data` volume.
3. Runs `docker system prune -f`.

> ⚠️ Heads up: unlike the Windows version, here `docker system prune -f` is **global** and cleans up dangling resources across your whole Docker system, not just this environment. If you don't want that, drop that line.

## Docker Volume Mapping

During Setup the script mounts:

* `-v ~/Desktop/CHANGEME:/mnt/host_context`
  > The project folder, which `entrypoint.sh` then syncs internally.
* `-v "<environment>-auth-data":/root`
  > **Crucial for Login:** on Linux the **entire root home** is mounted as a single volume, so auth tokens and config persist together.
* `-v "<output_dir>":/app/output`
  > The folder where the CLI saves its results.

## 🐧 A note for Linux dwellers

Over here you don't need the whole launcher-and-double-click apparatus you have to put up with on Windows. For the daily launch of a project, just teach your shell a little trick: add a function to your `~/.bashrc` (or `~/.zshrc`).

<details open>
	<summary><b>docker</b></summary>
```bash
claude-run() {
    docker run -it --rm \
        --userns=keep-id \
        -v "$PWD:/mnt/host_context" \
        -v claude-auth-data:/home/node/.claude \
        -v $PWD:/app/output \
        claude-env
}
```
</details>

<details>
	<summary><b>podman</b></summary>
```bash
claude-run() {
    podman run -it --rm \
        --userns=keep-id \
        -v "$PWD:/mnt/host_context:Z" \
        -v claude-auth-data:/home/node/.claude:Z \
        -v "$PWD:/app/output:Z" \
        claude-env
}
```
</details>

Then reload the shell with `source ~/.bashrc` (or `~/.zshrc`) and from any project folder just type `claude-run`. No dedicated script, no paths to rewrite every time: `$PWD` handles it for you. 

## ⚠️ Troubleshooting

* **`permission denied` on launch:** grant permission with `chmod +x orchestrator.sh`.
* **Build can't find the Dockerfile:** remember the context is the current directory; run it from `Claude/` or `Gemini/`.
* **Asks for login every time:** make sure you haven't deleted the `<environment>-auth-data` volume, and that you use the same mount (`:/root`) in your shell function too.

</details>
