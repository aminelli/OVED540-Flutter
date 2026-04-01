# 📝 Todo List App con Flutter Bloc

Un'applicazione Todo List completa sviluppata in Flutter che dimostra l'implementazione del **pattern Bloc** per la gestione dello stato.

## 🎯 Obiettivo del Progetto

Questo progetto è stato creato per mostrare come utilizzare il pattern **Bloc (Business Logic Component)** in un caso d'uso reale. È un esempio didattico perfetto per comprendere:

- Come separare la logica di business dall'interfaccia utente
- Come gestire lo stato in modo prevedibile e testabile
- Come implementare un'architettura scalabile e manutenibile

## ✨ Funzionalità

- ✅ **Aggiungere task** con titolo e descrizione
- ✅ **Modificare task** esistenti
- ✅ **Segnare task come completati** con checkbox
- ✅ **Eliminare task** con swipe gesture
- ✅ **Visualizzare statistiche** (totali, da fare, completati)
- ✅ **Eliminare tutti i task completati** con un solo click
- ✅ **Interfaccia intuitiva** con Material Design 3

## 🏗️ Architettura Bloc

Il pattern Bloc separa la logica di business dalla presentazione seguendo questi principi:

### Componenti Principali

```
┌─────────────┐
│     UI      │  ← Invia Eventi
│  (Screens)  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    BLOC     │  ← Processa Eventi → Emette Stati
│ (Business)  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   STATO     │  ← UI si Ricostruisce
│  (States)   │
└─────────────┘
```

### 1. **Eventi** (`todo_event.dart`)
Gli eventi rappresentano le azioni dell'utente:
- `LoadTodos` - Carica la lista iniziale
- `AddTodo` - Aggiunge un nuovo task
- `UpdateTodo` - Modifica un task esistente
- `DeleteTodo` - Elimina un task
- `ToggleTodo` - Cambia lo stato completato/non completato
- `ClearCompleted` - Rimuove tutti i task completati

### 2. **Stati** (`todo_state.dart`)
Gli stati rappresentano le diverse situazioni dell'app:
- `TodoInitial` - Stato iniziale
- `TodoLoading` - Caricamento in corso
- `TodoLoaded` - Dati caricati con successo
- `TodoError` - Errore durante un'operazione

### 3. **Bloc** (`todo_bloc.dart`)
Il Bloc contiene tutta la logica di business:
- Riceve eventi dall'UI
- Processa la logica
- Emette nuovi stati
- Mantiene la lista dei task (single source of truth)

### 4. **UI** (`todo_list_screen.dart`)
L'interfaccia utente:
- **BlocBuilder**: Ricostruisce l'UI quando lo stato cambia
- **BlocProvider**: Fornisce il Bloc a tutti i widget figli
- **context.read()**: Invia eventi al Bloc

## 📁 Struttura del Progetto

```
lib/
├── main.dart                    # Punto di ingresso dell'app
├── models/
│   └── todo.dart               # Modello dati Todo
├── bloc/
│   ├── todo_event.dart         # Definizione eventi
│   ├── todo_state.dart         # Definizione stati
│   └── todo_bloc.dart          # Logica di business
└── screens/
    └── todo_list_screen.dart   # Interfaccia utente
```

## 🔧 Dipendenze

Il progetto utilizza le seguenti dipendenze principali:

```yaml
dependencies:
  flutter_bloc: ^8.1.6    # Implementazione Bloc per Flutter
  equatable: ^2.0.5       # Confronto oggetti per eventi/stati
```

## 🚀 Come Avviare il Progetto

### Prerequisiti

- Flutter SDK installato (versione 3.11.4 o superiore)
- Un editor (VS Code, Android Studio, IntelliJ IDEA)
- Un emulatore o dispositivo fisico collegato

### Passaggi

1. **Clona o scarica il progetto**

2. **Installa le dipendenze**
   ```bash
   flutter pub get
   ```

3. **Verifica che Flutter sia configurato correttamente**
   ```bash
   flutter doctor
   ```

4. **Esegui l'applicazione**
   ```bash
   flutter run
   ```

   Per eseguire su un dispositivo specifico:
   ```bash
   flutter devices              # Elenca i dispositivi disponibili
   flutter run -d <device-id>   # Esegui su un dispositivo specifico
   ```

5. **Hot Reload durante lo sviluppo**
   - Premi `r` nel terminale per ricaricare le modifiche
   - Premi `R` per riavviare completamente l'app
   - Premi `q` per uscire

## 📱 Come Usare l'App

1. **Aggiungere un task**: Premi il pulsante `+` in basso a destra
2. **Completare un task**: Tocca il checkbox a sinistra del task
3. **Modificare un task**: Tocca il task nella lista
4. **Eliminare un task**: Fai swipe verso sinistra sul task
5. **Eliminare completati**: Premi l'icona del cestino nella AppBar

## 🎨 Vantaggi del Pattern Bloc

### ✅ Separazione delle Responsabilità
- La logica di business è separata dall'UI
- Facile da testare in modo indipendente
- Codice più pulito e organizzato

### ✅ Gestione Prevedibile dello Stato
- Uno stato per ogni situazione dell'app
- Facile debuggare il flusso di dati
- Eventi espliciti per ogni azione

### ✅ Testabilità
- Puoi testare il Bloc senza UI
- Eventi e stati sono oggetti semplici
- Logica isolata e ripetibile

### ✅ Scalabilità
- Facile aggiungere nuove funzionalità
- Pattern consistente in tutta l'app
- Adatto a progetti di qualsiasi dimensione

## 🧪 Test (Opzionale)

Per testare il Bloc:

```bash
flutter test
```

Esempio di test per il TodoBloc:

```dart
test('LoadTodos emette TodoLoaded con lista di task', () async {
  final bloc = TodoBloc();
  
  bloc.add(const LoadTodos());
  
  await expectLater(
    bloc.stream,
    emitsInOrder([
      isA<TodoLoading>(),
      isA<TodoLoaded>(),
    ]),
  );
});
```

## 📚 Risorse Utili

- [Documentazione Flutter](https://flutter.dev/docs)
- [Documentazione Bloc](https://bloclibrary.dev/)
- [Pattern Bloc - Guida Completa](https://bloclibrary.dev/#/coreconcepts)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

## 🛠️ Possibili Estensioni

Idee per migliorare ulteriormente l'app:

1. **Persistenza dei dati**: Salvare i task con SQLite o SharedPreferences
2. **Filtri**: Mostrare solo task attivi, completati o tutti
3. **Categorie**: Organizzare i task per categoria/tag
4. **Date di scadenza**: Aggiungere deadline ai task
5. **Notifiche**: Promemoria per task in scadenza
6. **Sincronizzazione cloud**: Backup su Firebase
7. **Dark mode**: Tema scuro/chiaro
8. **Animazioni**: Transizioni fluide tra stati

## 📝 Note Tecniche

- **Flutter SDK**: ^3.11.4
- **Pattern**: Bloc (Business Logic Component)
- **State Management**: flutter_bloc
- **Material Design**: Material 3
- **Linguaggio**: Dart con commenti in italiano

## 👨‍💻 Sviluppo

Questo progetto è stato sviluppato come esempio didattico per dimostrare l'uso del pattern Bloc in Flutter. Tutti i commenti nel codice sono in italiano per facilitare la comprensione.

---

**Buon coding! 🚀**
