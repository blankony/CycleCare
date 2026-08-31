// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'CycleCare';

  @override
  String get navHome => 'Beranda';

  @override
  String get navCalendar => 'Kalender';

  @override
  String get navHistory => 'Riwayat';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get actionRecordPeriod => 'Catat period';

  @override
  String get actionUpdatePeriod => 'Perbarui period';

  @override
  String get actionStartPeriodToday => 'Mulai period hari ini';

  @override
  String get statusSynced => 'Tersinkron';

  @override
  String get statusSyncing => 'Menyinkronkan';

  @override
  String get statusOffline => 'Offline';

  @override
  String get statusSyncNeeded => 'Perlu sinkronisasi';

  @override
  String get statusSavedOnDevice => 'Tersimpan di perangkat';

  @override
  String get sectionCycleDisplay => 'Tampilan siklus';

  @override
  String get sectionReminders => 'Pengingat';

  @override
  String get sectionLanguage => 'Bahasa';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languagePickerTitle => 'Bahasa';

  @override
  String get languagePickerSubtitle => 'Pilih bahasa aplikasi';

  @override
  String get homeToday => 'Hari ini';

  @override
  String get homeStartYourLog => 'Mulai catatanmu';

  @override
  String get homeDataGrowing => 'Data bertambah';

  @override
  String homeDayOfCycle(int day) {
    return 'Hari $day';
  }

  @override
  String homeLateByDays(int count) {
    return 'Terlambat $count hari dari rentang perkiraan';
  }

  @override
  String get homeNextPeriodEstimate => 'Perkiraan period berikutnya';

  @override
  String get homeNoPeriodEstimate => 'Belum ada perkiraan period';

  @override
  String get homeLogAFewCycles => 'Catat beberapa siklus dahulu';

  @override
  String homeBasedOnCycles(int count, String confidence) {
    return 'Berdasarkan $count siklus · Keyakinan $confidence';
  }

  @override
  String get homePredictionWillChange =>
      'Tanggal dapat berubah mengikuti catatan terbaru.';

  @override
  String homeCycleStatusPeriodDay(int day) {
    return 'Hari ke-$day period';
  }

  @override
  String get homeCycleStatusLate => 'Perkiraan period telah lewat';

  @override
  String get homeCycleStatusFertile => 'Dalam perkiraan masa subur';

  @override
  String get homeCycleStatusAfterOvulation => 'Fase setelah perkiraan ovulasi';

  @override
  String get homeCycleStatusOngoing => 'Siklus sedang berjalan';

  @override
  String get homeCycleStatusEmpty => 'Catat period pertama untuk memulai';

  @override
  String get homeChipLate => 'Lewat perkiraan';

  @override
  String get homeChipActiveCycle => 'Siklus aktif';

  @override
  String get homeChipPeriodOngoing => 'Period berlangsung';

  @override
  String get homeTimelineCurrentCycle => 'Siklus saat ini';

  @override
  String get homeTimelinePeriodRecorded => 'Period tercatat';

  @override
  String get homeTimelineFertile => 'Masa subur';

  @override
  String get homeTimelineOvulation => 'Ovulasi';

  @override
  String get homeTimelinePredictedPeriod => 'Period diperkirakan';

  @override
  String get homeSectionCycleForecast => 'Perkiraan siklus';

  @override
  String get homeSectionForecastSubtitle =>
      'Tanggal dapat berubah mengikuti catatan terbaru.';

  @override
  String get homePhaseFertile => 'Masa subur';

  @override
  String get homePhaseOvulationEstimate => 'Perkiraan ovulasi';

  @override
  String get homePhaseNextPeriod => 'Period berikutnya';

  @override
  String homeConfidence(String label) {
    return 'Keyakinan $label';
  }

  @override
  String get homeRangeMayChange => 'Rentang dapat berubah';

  @override
  String get homeForthcoming => 'Berikutnya';

  @override
  String homeInAboutDays(int count) {
    return 'Sekitar $count hari lagi';
  }

  @override
  String get homePredictionRangePast => 'Rentang perkiraan telah lewat';

  @override
  String get homeInsufficientDataTitle => 'Data belum cukup';

  @override
  String get homeInsufficientDataBody =>
      'Catat beberapa siklus agar perkiraan menjadi lebih personal.';

  @override
  String homeRecentSummaryTitle(int count) {
    return 'Ringkasan $count siklus';
  }

  @override
  String get homeRecentSummaryGeneric => 'Ringkasan siklus';

  @override
  String get homeViewStatistics => 'Lihat statistik';

  @override
  String homeAverageCycle(String value, String pattern) {
    return 'Rata-rata siklusmu $value hari. Pola saat ini $pattern.';
  }

  @override
  String get homePromptLogNext =>
      'Catat siklus berikutnya untuk melihat pola pribadi.';

  @override
  String get homeFertilitySafety =>
      'Perkiraan masa subur tidak ditujukan sebagai metode kontrasepsi.';

  @override
  String get medicalDisclaimer =>
      'Prediksi CycleCare adalah perkiraan berdasarkan riwayat yang dicatat, bukan diagnosis medis.';

  @override
  String get commonRetry => 'Coba lagi';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonContinue => 'Lanjut';

  @override
  String get commonSaveChanges => 'Simpan perubahan';

  @override
  String get commonSaveNote => 'Simpan catatan';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonArchive => 'Arsipkan';

  @override
  String get commonRestore => 'Pulihkan';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonBackToHistory => 'Kembali ke riwayat';

  @override
  String get calendarTitle => 'Kalender';

  @override
  String get calendarPreparing => 'Menyiapkan kalender siklusmu…';

  @override
  String get calendarLoadFailed =>
      'Kalender belum dapat dimuat. Data kesehatanmu tetap aman di perangkat.';

  @override
  String get calendarPredictionUnavailable =>
      'Perkiraan belum dapat ditampilkan. Catatan period tetap tersedia.';

  @override
  String get calendarPreferencesUnavailable =>
      'Pilihan masa subur belum dapat dimuat. Estimasi disembunyikan sementara.';

  @override
  String get calendarLoading =>
      'Perkiraan dan pilihan kalender sedang disiapkan.';

  @override
  String get calendarPeriodRecorded => 'Period tercatat';

  @override
  String get calendarPredictedPeriod => 'Perkiraan period';

  @override
  String get calendarFertileWindow => 'Masa subur';

  @override
  String get calendarOvulation => 'Ovulasi';

  @override
  String get calendarToday => 'Hari ini';

  @override
  String get calendarRecordedDetailTitle => 'Period tercatat';

  @override
  String get calendarPredictedDetailTitle => 'Perkiraan period';

  @override
  String get calendarFertileDetailTitle => 'Masa subur (perkiraan)';

  @override
  String get calendarOvulationDetailTitle => 'Ovulasi (perkiraan)';

  @override
  String calendarStartOngoing(String date) {
    return 'Dimulai $date dan masih berlangsung.';
  }

  @override
  String calendarStartToEnd(String start, String end) {
    return '$start sampai $end.';
  }

  @override
  String get calendarEmptyNoRecord =>
      'Tidak ada catatan atau perkiraan pada tanggal ini.';

  @override
  String get calendarEmptyFirstPrompt =>
      'Belum ada catatan period. Catat period pertamamu untuk mulai melihat pola siklus.';

  @override
  String get calendarFinishPeriodToday => 'Selesaikan period hari ini';

  @override
  String get calendarStartPeriodToday => 'Mulai period hari ini';

  @override
  String get calendarSafetyNote =>
      'Perkiraan dapat berubah seiring catatan baru. Estimasi masa subur bukan panduan kontrasepsi.';

  @override
  String get calendarMonthFormat => 'Bulan';

  @override
  String get historyTitle => 'Riwayat period';

  @override
  String get historyPreparing => 'Menyiapkan riwayat periodmu…';

  @override
  String get historyLoadFailed =>
      'Riwayat belum dapat dimuat. Data kesehatanmu tetap aman di perangkat.';

  @override
  String get historyEmptyTitle => 'Belum ada riwayat period.';

  @override
  String get historyEmptyMessage =>
      'Catat period pertamamu untuk mulai melihat pola siklus.';

  @override
  String get historyNewestFirst =>
      'Catatan terbaru ditampilkan paling atas agar pola siklus lebih mudah ditinjau.';

  @override
  String get historyPersonalStats => 'Statistik pribadi';

  @override
  String get historyOpenStats => 'Buka statistik pribadi';

  @override
  String get historyFlowUnavailable =>
      'Ringkasan flow belum dapat dimuat. Catatan period tetap tersedia.';

  @override
  String get historyFlowLoading => 'Ringkasan flow sedang disiapkan.';

  @override
  String get historyRecordedChip => 'Tercatat';

  @override
  String get historyOngoingChip => 'Sedang berlangsung';

  @override
  String historyDaysChip(int count) {
    return '$count hari';
  }

  @override
  String historyCycleChip(int count) {
    return 'Siklus $count hari';
  }

  @override
  String get historyViewSummary => 'Lihat ringkasan';

  @override
  String get historyArchiveTitle => 'Arsipkan catatan?';

  @override
  String get historyArchiveMessage =>
      'Catatan tidak dihapus permanen dan dapat dipulihkan dari Pengaturan.';

  @override
  String get historyFlowNone => 'Belum ada flow yang dicatat.';

  @override
  String get historyArchiveAction => 'Arsipkan';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsCycleDisplay => 'Tampilan siklus';

  @override
  String get settingsOvulationEstimate => 'Perkiraan ovulasi';

  @override
  String get settingsFertileWindow => 'Masa subur';

  @override
  String get settingsReminders => 'Pengingat';

  @override
  String get settingsReminderPeriod => 'Pengingat period';

  @override
  String get settingsSecurity => 'Keamanan';

  @override
  String get settingsBiometricLock => 'Kunci biometrik';

  @override
  String get settingsTestAuth => 'Uji autentikasi perangkat';

  @override
  String get settingsCloudSync => 'Cloud & sinkronisasi';

  @override
  String get settingsActiveAccount => 'Akun aktif';

  @override
  String get settingsSupabaseAccount => 'Akun Supabase';

  @override
  String get settingsSyncNow => 'Sinkronkan sekarang';

  @override
  String get settingsRetrySync => 'Coba lagi sinkronisasi';

  @override
  String get settingsLastSync => 'Sinkronisasi terakhir';

  @override
  String get settingsNeverSynced => 'Belum pernah berhasil';

  @override
  String get settingsBackupRestore => 'Backup & restore';

  @override
  String get settingsManageBackup => 'Kelola backup lokal';

  @override
  String get settingsArchivedNotes => 'Catatan terarsip';

  @override
  String get settingsNoArchived => 'Tidak ada catatan terarsip.';

  @override
  String get settingsAccount => 'Akun';

  @override
  String get settingsSignOut => 'Keluar dari akun';

  @override
  String get settingsSignOutTitle => 'Keluar dari akun?';

  @override
  String get settingsSignOutMessage =>
      'Kamu dapat masuk kembali menggunakan akun Supabase yang sama.';

  @override
  String get settingsDeleteCloud => 'Hapus akun cloud';

  @override
  String get settingsDeleteCloudTitle => 'Hapus akun cloud?';

  @override
  String get settingsDeleteCloudMessage =>
      'Akun Supabase, profil, dan semua data cloud terkait akan dihapus permanen.';

  @override
  String get settingsDeleteCloudConfirmTitle => 'Konfirmasi terakhir';

  @override
  String get settingsDeleteCloudConfirmMessage =>
      'Tindakan ini tidak dapat dibatalkan. Hapus akun dan data cloud?';

  @override
  String get settingsDeleteCloudAction => 'Hapus akun';

  @override
  String get settingsDangerZone => 'Zona bahaya';

  @override
  String get settingsDeleteLocal => 'Hapus semua data lokal';

  @override
  String get settingsDeleteLocalTitle => 'Hapus semua data lokal?';

  @override
  String get settingsDeleteLocalMessage =>
      'Semua period, prediksi, pengaturan, dan antrean sinkronisasi akan dihapus dari perangkat. Data cloud dapat tersinkron kembali setelah sinkronisasi awal berikutnya. Akun Supabase tidak ikut dihapus.';

  @override
  String get settingsDeleteLocalConfirmTitle => 'Konfirmasi terakhir';

  @override
  String get settingsDeleteLocalConfirmMessage =>
      'Tindakan ini tidak dapat dibatalkan. Lanjutkan?';

  @override
  String get settingsDeleteLocalAction => 'Hapus semua';

  @override
  String get settingsLocalDeleted => 'Data lokal telah dihapus.';

  @override
  String get settingsBiometricNotSupported =>
      'Perangkat ini tidak mendukung kunci biometrik.';

  @override
  String get settingsBiometricCancelled =>
      'Autentikasi dibatalkan. Kunci tetap nonaktif.';

  @override
  String settingsUpdateFailed(String error) {
    return 'Gagal memperbarui preferensi: $error';
  }

  @override
  String get periodFormUpdateTitle => 'Perbarui period';

  @override
  String get periodFormCreateTitle => 'Catat period';

  @override
  String get periodFormUpdateSubtitle =>
      'Perbarui tanggal, flow harian, atau catatan tanpa mengubah data lain.';

  @override
  String get periodFormCreateSubtitle =>
      'Catat tanggal dan flow harian yang kamu ingat. Semua bagian dapat diperbarui nanti.';

  @override
  String get periodFormDateRecordedChip => 'Data tercatat';

  @override
  String get periodFormSectionDates => 'Tanggal period';

  @override
  String get periodFormDatesHint =>
      'Pastikan rentang tanggal sesuai dengan catatanmu.';

  @override
  String get periodFormStartDate => 'Tanggal mulai';

  @override
  String get periodFormEndDate => 'Tanggal selesai';

  @override
  String get periodFormOngoing => 'Masih berlangsung';

  @override
  String get periodFormOngoingHint => 'Aktifkan jika period belum selesai.';

  @override
  String get periodFormFlowSection => 'Flow harian';

  @override
  String get periodFormFlowHint =>
      'Opsional. Setiap tanggal dapat diperbarui secara terpisah.';

  @override
  String get periodFormFlowLoading => 'Flow yang tersimpan sedang dimuat.';

  @override
  String get periodFormFlowUnavailable =>
      'Flow yang tersimpan belum dapat dimuat. Pilihan baru tetap dapat disimpan.';

  @override
  String get periodFormNotesTitle => 'Catatan opsional';

  @override
  String get periodFormNotesHint =>
      'Hindari informasi yang tidak perlu agar catatan tetap ringkas.';

  @override
  String get periodFormNotesLabel => 'Catatan';

  @override
  String get periodFormNotesPlaceholder =>
      'Tambahkan catatan pribadi jika perlu';

  @override
  String get periodFormPrivacyNote =>
      'Catatan ini disimpan sebagai data pribadi akunmu.';

  @override
  String get periodFormSaving => 'Menyimpan…';

  @override
  String get periodFormPickStartHelp => 'Pilih tanggal mulai';

  @override
  String get periodFormPickEndHelp => 'Pilih tanggal selesai';

  @override
  String get periodFormValidationStartFuture =>
      'Tanggal mulai tidak boleh di masa depan.';

  @override
  String get periodFormValidationEndBeforeStart =>
      'Tanggal selesai tidak boleh sebelum tanggal mulai.';

  @override
  String get periodFormValidationEndFuture =>
      'Tanggal selesai tidak boleh di masa depan.';

  @override
  String get periodFormOverlap =>
      'Rentang ini bertumpang tindih dengan catatan lain.';

  @override
  String get periodFormSaveFailed => 'Catatan belum dapat disimpan. Coba lagi.';

  @override
  String get periodFormFlowHapus => 'Hapus flow';

  @override
  String get periodFormFlowOutOfRangeTitle => 'Flow di luar rentang period';

  @override
  String periodFormFlowOutOfRangeMessage(int count) {
    return '$count catatan flow berada di luar tanggal baru dan akan dihapus. Lanjutkan?';
  }

  @override
  String get periodFormFlowDeleteAndSave => 'Hapus dan simpan';

  @override
  String get authLoginTitle => 'Masuk ke CycleCare';

  @override
  String get authRegisterTitle => 'Buat akun CycleCare';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordRepeatLabel => 'Ulangi password';

  @override
  String get authLoginAction => 'Masuk';

  @override
  String get authRegisterAction => 'Daftar';

  @override
  String get authNoAccount => 'Belum punya akun? Daftar';

  @override
  String get authHaveAccount => 'Sudah punya akun? Masuk';

  @override
  String get authInvalidEmail => 'Masukkan email yang valid.';

  @override
  String get authPasswordMin => 'Password minimal 6 karakter.';

  @override
  String get authPasswordMismatch => 'Password tidak sama.';

  @override
  String get authRegisteredSuccess =>
      'Pendaftaran berhasil. Periksa email untuk konfirmasi, lalu masuk.';

  @override
  String get authGenericFailure =>
      'Proses gagal. Periksa koneksi lalu coba lagi.';

  @override
  String get tooltipOpenAccount => 'Buka akun dan pengaturan';

  @override
  String get tooltipRecordPeriod => 'Catat period';

  @override
  String get snackbarPeriodFinishedToday => 'Period diselesaikan hari ini.';

  @override
  String get snackbarPeriodStartedToday => 'Period dimulai hari ini.';

  @override
  String get errorDataSafeRetry =>
      'Data lokalmu tetap aman. Coba muat kembali untuk menampilkan catatan terbaru.';

  @override
  String get loadingPreparingCycle => 'Menyiapkan siklusmu…';

  @override
  String get semanticsCycleHeroEmpty =>
      'Belum ada catatan siklus. Catat period untuk memulai.';

  @override
  String get syncBannerTersinkron => 'Tersinkron';

  @override
  String get syncBannerOffline => 'Offline';
}
