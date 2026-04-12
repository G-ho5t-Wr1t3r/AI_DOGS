# Runner Docker per Gemini Env (Windows)

Questo script Batch (`Gemini.bat`) automatizza e semplifica l'avvio del container Docker `gemini-env` su sistemi Windows. Risolve i comuni problemi di formattazione dei percorsi e garantisce che la sessione di login (autenticazione Google/Gemini) rimanga salvata tra un riavvio e l'altro.

## ⚠️ DISCLAIMER!

Modifica il file ```Gemini.bat``` mappando i percorsi corretti e sostituendo il placeholder.

## Prerequisiti

1. **Docker Desktop** installato, in esecuzione e con l'integrazione WSL2 attiva.
2. L'immagine Docker `gemini-env` deve essere già stata compilata sulla tua macchina.
   *(Se non l'hai fatto: vai nella cartella del Dockerfile ed esegui `docker build -t gemini-env .`)*

## Come utilizzare lo script

1. Fai doppio clic sul file `gemini.bat`.
2. **Step 1:** Inserisci il percorso assoluto della cartella del tuo progetto (es. `D:\MieiProgetti\Progetto`).
3. **Step 2:** Scegli il percorso di output. Puoi premere **INVIO** per usare quello di default, oppure scriverne uno nuovo.
4. **Conferma:** Lo script ti mostrerà un riepilogo. Digita `Y` per confermare o `N` per correggere i dati.

## Funzionalità "Avvio Rapido" (Shortcut)

Se lavori spesso sullo stesso progetto, lo script ti offre la possibilità di creare un **file di avvio rapido** (es. `run_gemini_Progetto.bat`). 

* **Cosa fa:** Crea un nuovo mini-script configurato con i percorsi esatti che hai appena inserito.
* **Vantaggio:** La prossima volta ti basterà fare doppio clic sul file di avvio rapido per lanciare direttamente il container, senza dover digitare di nuovo i percorsi.

## Mappatura dei Volumi Docker

Lo script mappa automaticamente 4 volumi fondamentali per il funzionamento dell'ambiente:

* `-v "%PROJECT_PATH%:/mnt/host_context"`
  > Collega la cartella del tuo progetto al container. Lo script `entrypoint.sh` interno si occuperà poi di sincronizzarla nella cartella di lavoro di Gemini.
* `-v "gemini-config-data:/root/.config"`
  > Crea un volume Docker persistente per salvare i file di configurazione generici delle CLI.
* `-v "gemini-auth-data:/root/.gemini"`
  > **Cruciale per il Login:** Salva i token di autenticazione in modo persistente. Evita di dover rifare il login ogni volta che avvii il container.
* `-v "%FINAL_OUT_PATH%:/app/output"`
  > Collega la cartella di output dove Gemini salverà eventuali risultati o file generati.

## ⚠️ Risoluzione dei Problemi

* **Il terminale si chiude subito all'avvio:** Assicurati che Docker Desktop sia aperto e l'icona della balena in basso a destra sia verde/avviata.
* **Errore "Image not found":** Assicurati di aver compilato l'immagine chiamandola esattamente `gemini-env` (tutto minuscolo).
* **Richiede il login ogni volta:** Verifica di non aver cancellato manualmente i volumi Docker `gemini-config-data` o `gemini-auth-data` tramite l'interfaccia di Docker Desktop.

---
*Creato per semplificare il flusso di lavoro AI su Windows.*