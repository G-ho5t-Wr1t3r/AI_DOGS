<details>
<summary><b>IT</b></summary>

# Istruzioni

> DISCLAIMER:
> Il Dockerfile installa automaticamente la skill `superpowers`. Per evitare questo comportamento, commenta la riga che la installa:
> `RUN yes | gemini extensions install https://github.com/obra/superpowers || (echo "Extension failed" && exit 1)`

# Installazione

<!-- Docker installation section -->
<details>
  <summary><b>🐳 Docker</b></summary>

Per costruire l'immagine per la prima volta runnare il comando (dalla cartella `Gemini/`)
```
docker build -t gemini-env .
```

Creazione dei volumi per il login a Google
```
docker volume create gemini-config-data
docker volume create gemini-auth-data
```

> Primo avvio & Login (Linux)
> ```
> docker run -it --rm \
>  -v gemini-config-data:/root/.config \
>  -v gemini-auth-data:/root/.gemini \
>  gemini-env
> ```

> Primo avvio & Login (Windows)
> ```
> docker run -it --rm `
>   -v gemini-config-data:/root/.config `
>   -v gemini-auth-data:/root/.gemini `
>   gemini-env
> ```

Una volta dentro il container eseguire
```
gemini
```

Uso quotidiano
```
docker run -it --rm \
  -v /percorso/cartella/contesto:/mnt/host_context \
  -v gemini-config-data:/root/.config \
  -v gemini-auth-data:/root/.gemini \
  -v ~/Desktop/Coding/Gemini/gemini_output:/app/output \
  gemini-env
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
docker rmi gemini-env
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
> Il flag `:Z` nei percorsi locali dell'uso quotidiano garantisce che `SELinux` (su Bluefin o altre distro immutabili) permetta al container di leggere e scrivere correttamente nelle cartelle. Va solo sui bind mount (cartelle dell'host), non sui volumi named.

Per costruire l'immagine per la prima volta runnare il comando (dalla cartella `Gemini/`)
```bash
podman build -t gemini-env .
```

Creazione dei volumi per il login a Google
```bash
podman volume create gemini-config-data
podman volume create gemini-auth-data
```

> Primo avvio & Login (Linux)
> ```bash
> podman run -it --rm \
>   -v gemini-config-data:/root/.config \
>   -v gemini-auth-data:/root/.gemini \
>   gemini-env
> ```

> Primo avvio & Login (Windows)
> ```powershell
> podman run -it --rm `
>    -v gemini-config-data:/root/.config `
>    -v gemini-auth-data:/root/.gemini `
>    gemini-env
> ```

Una volta dentro il container eseguire
```bash
gemini
```

Uso quotidiano
```bash
podman run -it --rm \
  -v /percorso/cartella/contesto:/mnt/host_context:Z \
  -v gemini-config-data:/root/.config \
  -v gemini-auth-data:/root/.gemini \
  -v ~/Desktop/Coding/Gemini/gemini_output:/app/output:Z \
  gemini-env
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
podman rmi gemini-env
```

Pulizia profonda
```bash
podman system prune -f
```

</details>

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
└───Gemini
    │   Dockerfile
    │   entrypoint.sh
    │   utility.sh
    │   MEMORY_EXAMPLE.md
    │   README.md
    └───gemini_output/
```
Gli script di utilità (setup, avvio, rimozione) sono centralizzati in `.utils`, divisi per OS. Verifica il contenuto di `Linux_Utilities` o `Windows_Utilities` in base al tuo sistema.

</details>

<details open>
<summary><b>EN</b></summary>

# Instructions

> DISCLAIMER:
> The Dockerfile automatically installs the `superpowers` skill. To prevent this behavior, comment out the line that installs it:
> `RUN yes | gemini extensions install https://github.com/obra/superpowers || (echo "Extension failed" && exit 1)`

# Installation

<!-- Docker installation section -->
<details>
  <summary><b>🐳 Docker</b></summary>

To build the image for the first time, run the command (from the `Gemini/` folder)
```
docker build -t gemini-env .
```

Create the volumes for the Google login
```
docker volume create gemini-config-data
docker volume create gemini-auth-data
```

> First launch & Login (Linux)
> ```
> docker run -it --rm \
>  -v gemini-config-data:/root/.config \
>  -v gemini-auth-data:/root/.gemini \
>  gemini-env
> ```

> First launch & Login (Windows)
> ```
> docker run -it --rm `
>   -v gemini-config-data:/root/.config `
>   -v gemini-auth-data:/root/.gemini `
>   gemini-env
> ```

Once inside the container, run
```
gemini
```

Daily use
```
docker run -it --rm \
  -v /path/to/context/folder:/mnt/host_context \
  -v gemini-config-data:/root/.config \
  -v gemini-auth-data:/root/.gemini \
  -v ~/Desktop/Coding/Gemini/gemini_output:/app/output \
  gemini-env
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
docker rmi gemini-env
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
> The `:Z` flag on the local paths in daily use makes sure `SELinux` (on Bluefin or other immutable distros) lets the container read and write to the folders correctly. It goes only on bind mounts (host folders), not on named volumes.

To build the image for the first time, run the command (from the `Gemini/` folder)
```bash
podman build -t gemini-env .
```

Create the volumes for the Google login
```bash
podman volume create gemini-config-data
podman volume create gemini-auth-data
```

> First launch & Login (Linux)
> ```bash
> podman run -it --rm \
>   -v gemini-config-data:/root/.config \
>   -v gemini-auth-data:/root/.gemini \
>   gemini-env
> ```

> First launch & Login (Windows)
> ```powershell
> podman run -it --rm `
>    -v gemini-config-data:/root/.config `
>    -v gemini-auth-data:/root/.gemini `
>    gemini-env
> ```

Once inside the container, run
```bash
gemini
```

Daily use
```bash
podman run -it --rm \
  -v /path/to/context/folder:/mnt/host_context:Z \
  -v gemini-config-data:/root/.config \
  -v gemini-auth-data:/root/.gemini \
  -v ~/Desktop/Coding/Gemini/gemini_output:/app/output:Z \
  gemini-env
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
podman rmi gemini-env
```

Deep cleanup
```bash
podman system prune -f
```

</details>

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
└───Gemini
    │   Dockerfile
    │   entrypoint.sh
    │   utility.sh
    │   MEMORY_EXAMPLE.md
    │   README.md
    └───gemini_output/
```
The utility scripts (setup, launch, removal) are centralized in `.utils`, split by OS. Check the contents of `Linux_Utilities` or `Windows_Utilities` depending on your system.

</details>