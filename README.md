# Istruzioni

> DISCLAIMER:
> Il Dockerfile è configurato per installare automaticamente la skill `superpowers`, per evitare questo comportamento, commentrare la riga 20 del file: 
> `RUN yes | gemini extensions install https://github.com/obra/superpowers || (echo "Extension failed" && exit 1)`

# Installazione 
<!-- Docker installation section -->
<details>
  <summary><b>🐳 Docker</b></summary>

Per costruire l'immagine per la prima volta runnare il comando 
```
docker build -t gemini-env .
```

Creazione del volume per il login a google
```
docker volume create gemini-auth-data
```

> Primo avvio & Login (Linux)
> ```
> docker run -it --rm \
>  -v gemini-auth-data:/root/.config \
>  gemini-env
> ```

> Primo avvio & Login (Windows)
> ```
> docker run -it --rm `
>   -v gemini-auth-data:/root/.config `
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
  -v gemini-auth-data:/root/.config \
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

<!-- Docker installation section -->
<details>
  <summary><b>🎩 Podman</b></summary>

> Flag Fondamentale! 
> Il flag `:Z` nei percorsi locali dell'uso quotidiano garantisce che `SELinux` (su Bluefin o altre distro immutabili) permetta al container di leggere e scrivere correttamente nelle cartelle.

Per costruire l'immagine per la prima volta runnare il comando 
```bash
podman build -t gemini-env .
```

Creazione del volume per il login a google
```bash
podman volume create gemini-auth-data
```

> Primo avvio & Login (Linux)
> ```bash
> podman run -it --rm \
>   -v gemini-auth-data:/root/.config \
>   gemini-env
> ```

> Primo avvio & Login (Windows)
> ```powershell
> podman run -it --rm `
>    -v gemini-auth-data:/root/.config `
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
  -v gemini-auth-data:/root/.config \
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

````</ID_CONTAINER>
</details>

# Su quali OS funziona?

Struttura della repo:
```
│   Dockerfile
│   entrypoint.sh
│   kill-frozen-container.py
│   README.md
│
├───gemini_output
├───Linux_Utilities
│       remove.sh
│       setup.sh
│
└───Windows_Utilities
        Gemini.bat
        README.md
```
Verifica il contenuto delle cartelle Linux Utilities e Windows Utilities in base al tuo OS.
