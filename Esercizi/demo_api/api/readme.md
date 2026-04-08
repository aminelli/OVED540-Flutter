# Docs

Documentazione on-line:

- https://github.com/typicode/json-server


## Per inizializzare il progetto

```sh
# NOTA: Importante
# Se non esiste il file "package.json" lanciare innanzitutto
# npm init

# Per installare le dipendenze
npm install json-server
```

## Per Avviare il progetto

```sh
npx json-server db.json --port 3000
```

## Per Ambienti Windows:

Lanciare powershell come amministratore

```powershell
# Lanciare questo comando per abilitare l'esecuzione di script
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# NOTA: Se non funziona usare
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

```
