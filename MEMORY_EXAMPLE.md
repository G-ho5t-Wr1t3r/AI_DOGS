# Memory Example for Gemini
Per dare delle istruzioni fisse che Gemini dovrà sempre rispettare, possiamo configurare la sua memoria riettamente durante l'utilizzo.

```
/memory add "The language I'm using is not important your answer must be always in Italian"
```

```
/memory add "Every time in wich we are starting a new conversation you have to create a new session report at the path @output/reports named: "report_session_TODAY_DATE.md" in wich you must descripe all the workflow, the problem solved, copying code snippets, coment the work executed... 
You must do this writing a subtitles `## PROBLEM NAME` and `### Context`, `### Solution` ecc. All the file must be written in first person, the narrator is not Gemini CLI bt the developer. The reports must be very exhaustive for the reader.
```

```
/memory add "If you need to do a git commit for the repo in wich we are working on, you must push all the commit using the developer name and not GEMINI CLI"
```

Applicando regole sempre più stringenti riusciremo a fissare dei comporetamenti specifici nel modus operandi dell'agente.