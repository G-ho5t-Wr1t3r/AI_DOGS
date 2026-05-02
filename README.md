# Istruzioni
Per costruire l'immagine per la prima volta runnare il comando 
```
docker build -t gemini-env .
```

Creazione del volume per il login a google
```
docker volume create gemini-auth-data
```

Primo avvio & Login (una tantum)
```
docker run -it --rm \
  -v gemini-auth-data:/root/.config \
  gemini-env
```

Alternativa Windows:
```
docker run -it --rm `
   -v gemini-auth-data:/root/.config `
   gemini-env
```

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

## Su quali OS funziona?

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