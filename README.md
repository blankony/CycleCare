# CycleCare

CycleCare adalah aplikasi pencatat period pribadi berbahasa Indonesia. Aplikasi ini dibuat dengan Flutter, Android sebagai target awal, dan iOS tetap disertakan. CycleCare bukan perangkat medis: prediksi hanya perkiraan dari riwayat yang dicatat dan tidak mendiagnosis kondisi, kehamilan, atau penyebab perubahan siklus.

## Arsitektur

- UI Flutter Material 3 dengan `go_router` dan bottom navigation.
- Riverpod sebagai dependency injection dan state aplikasi.
- Domain murni Dart untuk prediksi robust-weighted dan klasifikasi EARLY/ON_WINDOW/LATE.
- Drift/SQLite sebagai sumber data lokal offline-first.
- Supabase wajib untuk autentikasi email/password dan penyimpanan cloud kanonis.
- Layanan terpisah untuk notifikasi, biometrik, backup, logging, dan sinkronisasi.

Folder utama:

```text
lib/
  app/                 app, theme, router, providers, shared widgets
  core/                environment, date-only handling, errors, logging
  data/local/          Drift tables, database, generated bindings
  data/repositories/   local period, auth, sync repositories
  domain/entities/     immutable records and enums
  domain/services/     prediction, classification, recalculation, privacy, backup
  features/            dashboard, form, calendar, history, settings, auth, lock
supabase/migrations/   schema cloud, indeks, dan RLS
```

## Requirements

- Flutter stable 3.44.0 or compatible stable Flutter.
- Dart 3.12.0 or compatible Dart 3.
- Android SDK for Android builds. No Android emulator or physical Android device was available in the implementation environment; Windows and Chrome were the available Flutter targets.

Do not modify the global Flutter SDK.

## Install and run

```bash
flutter pub get
dart run build_runner build
dart format .
flutter analyze
flutter test
flutter run
```

The database file is named `cycle_care.sqlite` in the platform application-support directory. It is local data and is ignored by Git.

### Konfigurasi Supabase wajib

Create a local `.env` file from `.env.example` and fill in the Supabase project URL and publishable/anon key:

```bash
copy .env.example .env
flutter run
```

PowerShell:

```powershell
Copy-Item .env.example .env
flutter run
```

`SUPABASE_ANON_KEY` is the client publishable/anon key. Never use a `service_role` key in Flutter and never commit `.env` or real values. The app loads `.env` at startup.

Jika `.env` tidak tersedia, nilainya kosong, atau inisialisasi Supabase gagal, aplikasi menampilkan layar konfigurasi berbahasa Indonesia dan tidak membuka tracker. Instalasi baru juga harus login dan menyelesaikan sinkronisasi awal sebelum data kesehatan dapat diakses.

## Local-first behavior

A local write is committed to Drift first, the UI updates immediately, and a stable UUID-backed sync queue item is created. Supabase is the canonical synchronized store, while Drift remains the responsive cache and temporary offline store after a successful authenticated setup. Pending local edits are pushed before remote rows can replace them, queue entries are deduplicated per entity, pulls are scoped by user ID, and soft deletion is preserved. Device clock differences remain a known limitation.

## Cycle tracking features

- Period records support ongoing periods, later end dates, editing, notes, soft deletion, restore, duplicate prevention, and overlap validation.
- Daily flow is optional and recorded per date as Bercak, Ringan, Sedang, or Deras. Flow is descriptive only and does not estimate blood volume.
- The dashboard derives current cycle day, menstruation day, next-period range, neutral late status, personal consistency, and cycle statistics from Drift.
- Ovulation and fertile-window cards and calendar markers are hidden by default and can be enabled in Pengaturan. They are estimates only; fertile estimates must not be used as contraception.
- Kalender shows recorded days separately from six derived future projections, prediction centers, uncertainty windows, and optional fertility markers. Distant projections use lower certainty.
- Riwayat is newest-first and includes flow summaries, classifications, notes, statistics, and end-of-cycle summaries.
- Statistics use up to the 12 newest valid records and compare measurements with general adult references of 24–38 cycle days and no more than 8 bleeding days. These comparisons are not diagnoses.

## Prediction algorithm

Model version: `robust-weighted-v1`.

1. Normalize, deduplicate, and sort calendar dates.
2. Calculate consecutive start-date intervals and use only the six newest intervals.
3. Calculate median and median absolute deviation (MAD).
4. Exclude intervals farther than `max(7, 3 * MAD)` days from the median for the baseline.
5. Calculate a newer-data-weighted average and round to a whole day.
6. Use variability `clamp(round(MAD), 2, 7)` as the prediction window on each side.
7. Predict from the latest recorded start date.
8. Confidence is LOW with limited/high variability data, MEDIUM with at least three usable intervals, and HIGH with at least five usable intervals and variability at most three days.

Fewer than two intervals produces insufficient data. The output is always shown as an estimate.

## Classification

Classification compares an actual period start with the prediction that existed before that period:

- `EARLY`: before the prediction window.
- `ON_WINDOW`: on either window boundary or between them.
- `LATE`: after the prediction window.
- `INSUFFICIENT_DATA`: no valid previous prediction.

Signed variance is actual start minus predicted center: negative means earlier, zero means equal, positive means later. These labels are pattern comparisons only and do not imply pregnancy, illness, stress, or hormonal causes.

## Notifications and biometrics

Notification infrastructure initializes without requesting permission. Permission is requested only when the user enables reminders. Reminders use the `Asia/Jakarta` timezone and contain neutral text; they cover three days before the window, the first window day, and adding an end date. Permission denial and unsupported platforms are handled without blocking local tracking.

Biometric lock is not enabled automatically. The service checks device support, requests operating-system authentication before enabling, and stores only a boolean configuration flag in secure storage. Period records are not stored in secure storage. Hardware biometric behavior was not tested in this environment.

## Supabase setup

1. Create a Supabase project.
2. Open the SQL editor and apply `supabase/migrations/001_initial_schema.sql`.
3. Apply `supabase/migrations/002_cycle_tracking_features.sql`.
4. Keep Row Level Security enabled.
5. Copy `.env.example` to `.env` and fill in `SUPABASE_URL` and `SUPABASE_ANON_KEY`.
6. Run the app normally with `flutter run`.
7. Register or log in from the startup authentication screen and complete the initial sync gate.
8. Deploy `supabase/functions/delete-account` and configure its service-role secret only in the Edge Function environment for account deletion.

Every cloud-owned row uses `auth.uid() = user_id`; profiles use `auth.uid() = id`. Supabase credentials, tokens, and service-role keys are never included in local JSON backup.

## Backup and restore

Export creates schema version 2 JSON containing `schemaVersion`, `exportedAt`, period entries and prediction snapshots, daily flow logs, synchronized cycle settings, predictions, notes, and local settings, then uses the platform share sheet. Import accepts schema version 1 backups without flow/settings, normalizes date-only values, validates required fields, assigns imported ownership to the currently authenticated user, queues imported records, recalculates derived values, and uses an explicit replace flow inside a transaction. JSON backups are unencrypted and contain sensitive health information; store them carefully. Encryption is a known limitation.

Delete-all-local-data requires two confirmations and clears local periods, daily logs, predictions, settings, and the sync queue. Account deletion uses the authenticated `delete-account` Edge Function, then clears the current user's local cache and reminders without exposing a service-role key to Flutter.

## Testing and quality

The tests cover:

- Deterministic prediction with empty/short/stable/variable/outlier/duplicate/unsorted data.
- Six-interval limit, confidence levels, minimum/maximum windows, month/year/leap boundaries, and date-only behavior.
- Early/on-window/late boundaries and signed variance.
- Drift repository duplicate/future/end-date validation, duration, cycle length, soft delete, and restore.
- Dashboard empty state, confirmation dialog, bottom navigation, and unavailable cloud state.
- Mandatory bootstrap configuration states and required provider graph.
- Authenticated route redirects, initial-sync retry, temporary offline access, and expired sessions.
- Drift version 1 to version 2 migration, user isolation, sync conflict handling, soft deletion, and daily-flow sync foundations.
- Cycle day, late-status, fertility-estimate, future-projection, statistics, reference-comparison, summary, and backup compatibility tests.

Run:

```bash
dart run build_runner build
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

## Known limitations and roadmap

- No Android emulator or physical device was available here, so APK/device startup, notification delivery, and biometric hardware behavior remain to be verified on Android hardware.
- Advanced remote conflict review, background sync scheduling, encrypted backups, and full deleted-record management UI are intentionally minimal.
- iOS platform folders are generated and retained, but iOS signing/build must be performed on macOS.
- Calendar markers currently use a compact legend rather than separate custom marker widgets.
- The app does not infer medical causes and will not add AI to prediction calculations.
