# Economia domestica: contesto del progetto

App personale (un solo utente, interfaccia in italiano) per gestire l'economia domestica con il metodo dei **centri di costo (cdc) virtuali**, che sostituisce il file Excel "Economia 2026". I soldi stanno nei **conti** (CC1, CC2, Cash) e sono suddivisi in **cdc** (buste virtuali), per esempio l'assicurazione dell'auto: si accantona ogni mese una quota, così la spesa annuale non pesa su un solo mese.

## Come lavorare con l'utente
- Non è un programmatore: spiega cosa fai in modo semplice, in italiano, e mostra il codice solo se lo chiede (gli piace vedere cosa viene fatto e dove).
- Non cambiare le regole sui dati senza chiedere. Dichiara le ipotesi. Non dire "fatto" prima di aver controllato (almeno `node --check` sullo script).
- Passi piccoli e verificabili. Dopo ogni modifica dì all'utente cosa guardare.
- Lavora su un branch e apri una pull request; il sito si aggiorna quando la PR viene unita in `main`.

## Struttura del repository
- `index.html`: l'intera app (HTML + CSS + JavaScript puro, un solo file, senza build né librerie). Lo script ha un blocco di sincronizzazione tra i marcatori `/*SYNC*/` e `/*END*/`.
- `config.js`: `window.ECON_CFG={url,anon}` con l'indirizzo del progetto Supabase (forma `https://CODICE.supabase.co`, non l'indirizzo della dashboard) e la chiave pubblica (publishable). Pubblica per progettazione.
- `sw.js`, `manifest.webmanifest`, `icon-*.png`: PWA installabile e funzionante offline.
- `supabase.sql`: tabelle `app_state` e `app_backup` con regole di sicurezza (RLS) e backup giornaliero.
- `GUIDA.md`: guida alla messa online.
- Sito: GitHub Pages (`https://bebbobay.github.io/economia/`). Database: Supabase (regione UE).
- **Nel repository non devono mai finire i dati dell'utente** (né l'importazione dell'Excel) né chiavi `service_role`/`secret`. Il repository è pubblico.

## Modello dati (stato `S`, salvato in localStorage `economia-v2`)
- `accounts[{id,name,open,color}]`: CC1 `#8fd3f4` (celeste), CC2 `#c7e8a9` (verde), Cash `#ffd08a` (arancione). `open` è il saldo iniziale. L'ordine dell'array è l'ordine scelto dall'utente.
- `cdcs[{id,name}]`: anche qui l'ordine dell'array è quello scelto dall'utente e va rispettato ovunque.
- `txs[{id,type,date,acc,cdc,acc2,cdc2,amt,desc}]`, tipi:
  - `in`: entrata su un conto (finisce in "Libero").
  - `out`: uscita da conto e cdc.
  - `tr`: trasferimento (da conto/cdc a conto/cdc). `cdc="_"` significa **Libero** (parte del conto non allocata).
  - `sw`: scambio (due conti e due cdc, un solo importo): in A il cdc x passa a y e in B il cdc y passa a x.
- Tutti i saldi sono **derivati** da `calc()`: nessun saldo viene memorizzato. Libero = saldo conto − somma delle quote dei cdc nel conto.
- Regole: **conti e Libero non possono andare negativi** (`neg()` blocca il salvataggio), **i cdc sì**. Nel trasferimento il campo "A cdc" non ammette Libero: per disallocare si modifica o si elimina il movimento di allocazione.
- `pm["AAAA-MM"]["alloc|conto|cdc" oppure "out|conto|cdc"] = importo`: previsioni. Il tab In usa le allocazioni, il tab Out le uscite.
- `plans` (vecchie regole) non è più usato. `theme`: "", "light" o "dark".

## Schermate
Riepilogo · In · Out · Impostazioni (Storico con filtri, Conti, Cdc, Altro).
In e Out hanno Annuale (Costruzione = matrice di previsioni con bozza e pulsante Salva; Situazione = previsto/effettivo/differenza) e Mensile (tabella con una macro-riga per cdc, righe Prev., Eff., Diff., colonne per conto più Tot).
Colori di stato: Diff. = 0 verde, > 0 giallo, < 0 rosso; Eff. = Prev. verde, maggiore rosso, minore arancione; previsione vuota (0) con effettivo 0 verde; colonna Tot gialla; linee spesse tra i mesi e a sinistra dei Tot.

## Sincronizzazione (local-first)
`fetch` diretto alle API REST di Supabase (senza libreria). Login con email e password dell'unico utente. Un solo documento `app_state(user_id, data jsonb, version)` per utente, con aggiornamento condizionato sulla versione e **unione a tre vie per id** (`mrg()`) tra base locale, stato locale e stato remoto. La base sta in localStorage `economia-sync`. È stata provata con un server simulato e poi in uso reale con Supabase (PC e telefono).

## Da fare
1. Pagina **Accantonamenti**: spese annuali (assicurazione, bollo, gomme…) con quota mensile calcolata in automatico che riempie la matrice (sostituisce il vecchio foglio Excel di calcolo auto/moto, da rifare per tutti i cdc).
2. **Entrate previste** (stipendio) per completare la previsione di fine mese.
3. Formato data e valuta, grafici, movimenti ricorrenti, importazione CSV dell'estratto conto.
4. Messaggi d'errore di sincronizzazione più chiari.
