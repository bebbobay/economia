# Economia domestica: messa online (circa 20 minuti)

Nomi e posizioni dei menu di Supabase e GitHub possono cambiare un po': cerca la voce con lo stesso significato.

## 1. Supabase (il database)
1. Registrati su supabase.com e crea un **New project**: scegli un nome, una password per il database (salvala) e una regione in **Europa**, piano **Free**.
2. **SQL Editor -> New query**: incolla tutto il contenuto di `supabase.sql` e premi **Run**.
3. **Authentication -> Users -> Add user**: inserisci la tua email e una password robusta, con conferma automatica.
4. Sempre in Authentication, disattiva la registrazione di nuovi utenti ("Allow new users to sign up").
5. **Project Settings -> API**: copia il **Project URL** e la **Publishable key** (inizia con `sb_publishable_`). In alternativa va bene anche la chiave legacy **anon public**, ma verrà ritirata nel 2027.

## 2. GitHub (dove sta l'app)
1. Su github.com crea un account e un **New repository** chiamato `economia` (pubblico).
2. Apri `config.js` con il Blocco note, scrivi tra le virgolette il Project URL e la chiave anon, e salva.
3. Nel repository: **Add file -> Upload files**, trascina tutti i file di questa cartella e conferma con **Commit**.
4. **Settings -> Pages**: Source = *Deploy from a branch*, branch `main`, cartella `/ (root)`, **Save**. Dopo 1-2 minuti compare l'indirizzo `https://TUONOME.github.io/economia/`.

## 3. Primo avvio
1. **Prima di tutto, nella versione attuale (quella dentro Claude): Impostazioni -> Altro -> Backup**, copia tutto il testo e salvalo in una nota.
2. Apri l'indirizzo GitHub dal PC. **Impostazioni -> Altro -> Backup / Ripristina**, incolla il testo e premi **Importa**.
3. **Impostazioni -> Altro -> Sincronizzazione -> Collega**: URL e chiave sono già compilati, inserisci email e password dell'utente creato al punto 1.3. Il server è vuoto, quindi i dati vengono caricati.
4. Telefono: apri lo stesso indirizzo, **Collega** e scegli **Scarica i dati del server**. Poi aggiungi alla schermata Home (Chrome: menu -> *Installa app*; iPhone/Safari: Condividi -> *Aggiungi a Home*).

## Come funziona
- Ogni dispositivo tiene una copia locale: puoi registrare anche senza rete o con il server fermo, e poi tutto si riallinea da solo.
- Se modifichi cose diverse su due dispositivi, le modifiche vengono unite. Se tocchi lo stesso movimento, vince l'ultimo dispositivo che sincronizza.
- Il server salva ogni giorno una copia dello stato precedente (tabella `app_backup`).
- Fai comunque ogni tanto un **Backup** manuale.

## Sicurezza
- Il repository pubblico contiene solo il codice, non i tuoi dati.
- La chiave "anon" è pubblica per progettazione: i dati sono protetti dal login e dalle regole di accesso (RLS) create dallo script.
- Usa una password robusta e non condividere mai la chiave "service_role".
