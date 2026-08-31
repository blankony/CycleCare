// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CycleCare';

  @override
  String get navHome => 'Home';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get actionRecordPeriod => 'Record period';

  @override
  String get actionUpdatePeriod => 'Update period';

  @override
  String get actionStartPeriodToday => 'Start period today';

  @override
  String get statusSynced => 'Synced';

  @override
  String get statusSyncing => 'Syncing';

  @override
  String get statusOffline => 'Offline';

  @override
  String get statusSyncNeeded => 'Needs sync';

  @override
  String get statusSavedOnDevice => 'Saved on device';

  @override
  String get sectionCycleDisplay => 'Cycle Display';

  @override
  String get sectionReminders => 'Reminders';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Indonesian';

  @override
  String get languagePickerTitle => 'Language';

  @override
  String get languagePickerSubtitle => 'Choose app language';

  @override
  String get homeToday => 'Today';

  @override
  String get homeStartYourLog => 'Start your log';

  @override
  String get homeDataGrowing => 'Data growing';

  @override
  String homeDayOfCycle(int day) {
    return 'Day $day';
  }

  @override
  String homeLateByDays(int count) {
    return 'Late by $count days from predicted window';
  }

  @override
  String get homeNextPeriodEstimate => 'Next period estimate';

  @override
  String get homeNoPeriodEstimate => 'No period estimate yet';

  @override
  String get homeLogAFewCycles => 'Log a few cycles first';

  @override
  String homeBasedOnCycles(int count, String confidence) {
    return 'Based on $count cycles · Confidence $confidence';
  }

  @override
  String get homePredictionWillChange => 'Date may change with new logs.';

  @override
  String homeCycleStatusPeriodDay(int day) {
    return 'Day $day of period';
  }

  @override
  String get homeCycleStatusLate => 'Past predicted period';

  @override
  String get homeCycleStatusFertile => 'Within fertile window estimate';

  @override
  String get homeCycleStatusAfterOvulation => 'After estimated ovulation';

  @override
  String get homeCycleStatusOngoing => 'Cycle in progress';

  @override
  String get homeCycleStatusEmpty => 'Log your first period to begin';

  @override
  String get homeChipLate => 'Past prediction';

  @override
  String get homeChipActiveCycle => 'Active cycle';

  @override
  String get homeChipPeriodOngoing => 'Period ongoing';

  @override
  String get homeTimelineCurrentCycle => 'Current cycle';

  @override
  String get homeTimelinePeriodRecorded => 'Period recorded';

  @override
  String get homeTimelineFertile => 'Fertile window';

  @override
  String get homeTimelineOvulation => 'Ovulation';

  @override
  String get homeTimelinePredictedPeriod => 'Predicted period';

  @override
  String get homeSectionCycleForecast => 'Cycle forecast';

  @override
  String get homeSectionForecastSubtitle => 'Date may change with new logs.';

  @override
  String get homePhaseFertile => 'Fertile window';

  @override
  String get homePhaseOvulationEstimate => 'Ovulation estimate';

  @override
  String get homePhaseNextPeriod => 'Next period';

  @override
  String homeConfidence(String label) {
    return 'Confidence $label';
  }

  @override
  String get homeRangeMayChange => 'Range may change';

  @override
  String get homeForthcoming => 'Upcoming';

  @override
  String homeInAboutDays(int count) {
    return 'About $count days left';
  }

  @override
  String get homePredictionRangePast => 'Predicted range has passed';

  @override
  String get homeInsufficientDataTitle => 'Not enough data';

  @override
  String get homeInsufficientDataBody =>
      'Log a few cycles to make forecasts more personal.';

  @override
  String homeRecentSummaryTitle(int count) {
    return 'Summary of last $count cycles';
  }

  @override
  String get homeRecentSummaryGeneric => 'Cycle summary';

  @override
  String get homeViewStatistics => 'View statistics';

  @override
  String homeAverageCycle(String value, String pattern) {
    return 'Average cycle length $value days. Pattern is $pattern.';
  }

  @override
  String get homePromptLogNext =>
      'Log the next cycle to see your personal pattern.';

  @override
  String get homeFertilitySafety =>
      'Fertile window estimates are not intended as contraception.';

  @override
  String get medicalDisclaimer =>
      'CycleCare predictions are estimates based on your logged history, not a medical diagnosis.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSaveChanges => 'Save changes';

  @override
  String get commonSaveNote => 'Save note';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonArchive => 'Archive';

  @override
  String get commonRestore => 'Restore';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonBackToHistory => 'Back to history';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarPreparing => 'Preparing your cycle calendar…';

  @override
  String get calendarLoadFailed =>
      'Calendar could not be loaded. Your health data stays safe on device.';

  @override
  String get calendarPredictionUnavailable =>
      'Forecast not available yet. Period notes remain accessible.';

  @override
  String get calendarPreferencesUnavailable =>
      'Fertile choices could not be loaded. Estimates temporarily hidden.';

  @override
  String get calendarLoading =>
      'Forecast and calendar preferences are being prepared.';

  @override
  String get calendarPeriodRecorded => 'Period recorded';

  @override
  String get calendarPredictedPeriod => 'Predicted period';

  @override
  String get calendarFertileWindow => 'Fertile window';

  @override
  String get calendarOvulation => 'Ovulation';

  @override
  String get calendarToday => 'Today';

  @override
  String get calendarRecordedDetailTitle => 'Period recorded';

  @override
  String get calendarPredictedDetailTitle => 'Predicted period';

  @override
  String get calendarFertileDetailTitle => 'Fertile window (estimate)';

  @override
  String get calendarOvulationDetailTitle => 'Ovulation (estimate)';

  @override
  String calendarStartOngoing(String date) {
    return 'Started $date and still ongoing.';
  }

  @override
  String calendarStartToEnd(String start, String end) {
    return '$start to $end.';
  }

  @override
  String get calendarEmptyNoRecord => 'No record or estimate on this date.';

  @override
  String get calendarEmptyFirstPrompt =>
      'No period records yet. Log your first period to see cycle patterns.';

  @override
  String get calendarFinishPeriodToday => 'Finish period today';

  @override
  String get calendarStartPeriodToday => 'Start period today';

  @override
  String get calendarSafetyNote =>
      'Estimates may change with new logs. Fertile window estimates are not contraception guidance.';

  @override
  String get calendarMonthFormat => 'Month';

  @override
  String get historyTitle => 'Period history';

  @override
  String get historyPreparing => 'Preparing your period history…';

  @override
  String get historyLoadFailed =>
      'History could not be loaded. Your health data stays safe on device.';

  @override
  String get historyEmptyTitle => 'No period history yet.';

  @override
  String get historyEmptyMessage =>
      'Log your first period to start seeing cycle patterns.';

  @override
  String get historyNewestFirst =>
      'Newest notes appear first to review cycle patterns easily.';

  @override
  String get historyPersonalStats => 'Personal statistics';

  @override
  String get historyOpenStats => 'Open personal statistics';

  @override
  String get historyFlowUnavailable =>
      'Flow summary could not be loaded. Period notes remain available.';

  @override
  String get historyFlowLoading => 'Preparing flow summary.';

  @override
  String get historyRecordedChip => 'Recorded';

  @override
  String get historyOngoingChip => 'Ongoing';

  @override
  String historyDaysChip(int count) {
    return '$count days';
  }

  @override
  String historyCycleChip(int count) {
    return 'Cycle $count days';
  }

  @override
  String get historyViewSummary => 'View summary';

  @override
  String get historyArchiveTitle => 'Archive note?';

  @override
  String get historyArchiveMessage =>
      'Note is not permanently deleted and can be restored from Settings.';

  @override
  String get historyFlowNone => 'No flow logged yet.';

  @override
  String get historyArchiveAction => 'Archive';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsCycleDisplay => 'Cycle Display';

  @override
  String get settingsOvulationEstimate => 'Ovulation estimate';

  @override
  String get settingsFertileWindow => 'Fertile window';

  @override
  String get settingsReminders => 'Reminders';

  @override
  String get settingsReminderPeriod => 'Period reminder';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsBiometricLock => 'Biometric lock';

  @override
  String get settingsTestAuth => 'Test device authentication';

  @override
  String get settingsCloudSync => 'Cloud & sync';

  @override
  String get settingsActiveAccount => 'Active account';

  @override
  String get settingsSupabaseAccount => 'Supabase account';

  @override
  String get settingsSyncNow => 'Sync now';

  @override
  String get settingsRetrySync => 'Retry sync';

  @override
  String get settingsLastSync => 'Last sync';

  @override
  String get settingsNeverSynced => 'Never synced successfully';

  @override
  String get settingsBackupRestore => 'Backup & restore';

  @override
  String get settingsManageBackup => 'Manage local backup';

  @override
  String get settingsArchivedNotes => 'Archived notes';

  @override
  String get settingsNoArchived => 'No archived notes.';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsSignOutTitle => 'Sign out?';

  @override
  String get settingsSignOutMessage =>
      'You can sign back in with the same Supabase account.';

  @override
  String get settingsDeleteCloud => 'Delete cloud account';

  @override
  String get settingsDeleteCloudTitle => 'Delete cloud account?';

  @override
  String get settingsDeleteCloudMessage =>
      'Supabase account, profile, and all related cloud data will be permanently deleted.';

  @override
  String get settingsDeleteCloudConfirmTitle => 'Final confirmation';

  @override
  String get settingsDeleteCloudConfirmMessage =>
      'This action cannot be undone. Delete account and cloud data?';

  @override
  String get settingsDeleteCloudAction => 'Delete account';

  @override
  String get settingsDangerZone => 'Danger zone';

  @override
  String get settingsDeleteLocal => 'Delete all local data';

  @override
  String get settingsDeleteLocalTitle => 'Delete all local data?';

  @override
  String get settingsDeleteLocalMessage =>
      'All periods, predictions, settings, and sync queue will be deleted from device. Cloud data may resync after next initial sync. Supabase account is not deleted.';

  @override
  String get settingsDeleteLocalConfirmTitle => 'Final confirmation';

  @override
  String get settingsDeleteLocalConfirmMessage =>
      'This action cannot be undone. Continue?';

  @override
  String get settingsDeleteLocalAction => 'Delete all';

  @override
  String get settingsLocalDeleted => 'Local data deleted.';

  @override
  String get settingsBiometricNotSupported =>
      'This device does not support biometric lock.';

  @override
  String get settingsBiometricCancelled =>
      'Authentication cancelled. Lock remains off.';

  @override
  String settingsUpdateFailed(String error) {
    return 'Failed to update preference: $error';
  }

  @override
  String get periodFormUpdateTitle => 'Update period';

  @override
  String get periodFormCreateTitle => 'Record period';

  @override
  String get periodFormUpdateSubtitle =>
      'Update dates, daily flow, or notes without changing other data.';

  @override
  String get periodFormCreateSubtitle =>
      'Log dates and daily flow you remember. Everything can be updated later.';

  @override
  String get periodFormDateRecordedChip => 'Data recorded';

  @override
  String get periodFormSectionDates => 'Period dates';

  @override
  String get periodFormDatesHint =>
      'Make sure the date range matches your notes.';

  @override
  String get periodFormStartDate => 'Start date';

  @override
  String get periodFormEndDate => 'End date';

  @override
  String get periodFormOngoing => 'Still ongoing';

  @override
  String get periodFormOngoingHint => 'Enable if period has not finished.';

  @override
  String get periodFormFlowSection => 'Daily flow';

  @override
  String get periodFormFlowHint =>
      'Optional. Each date can be updated separately.';

  @override
  String get periodFormFlowLoading => 'Saved flow is loading.';

  @override
  String get periodFormFlowUnavailable =>
      'Saved flow could not be loaded. New choices can still be saved.';

  @override
  String get periodFormNotesTitle => 'Optional notes';

  @override
  String get periodFormNotesHint =>
      'Avoid unnecessary details to keep notes concise.';

  @override
  String get periodFormNotesLabel => 'Notes';

  @override
  String get periodFormNotesPlaceholder => 'Add personal notes if needed';

  @override
  String get periodFormPrivacyNote =>
      'This note is stored as your account’s private data.';

  @override
  String get periodFormSaving => 'Saving…';

  @override
  String get periodFormPickStartHelp => 'Pick start date';

  @override
  String get periodFormPickEndHelp => 'Pick end date';

  @override
  String get periodFormValidationStartFuture =>
      'Start date cannot be in the future.';

  @override
  String get periodFormValidationEndBeforeStart =>
      'End date cannot be before start date.';

  @override
  String get periodFormValidationEndFuture =>
      'End date cannot be in the future.';

  @override
  String get periodFormOverlap => 'This range overlaps another record.';

  @override
  String get periodFormSaveFailed =>
      'Note could not be saved. Please try again.';

  @override
  String get periodFormFlowHapus => 'Remove flow';

  @override
  String get periodFormFlowOutOfRangeTitle => 'Flow outside period range';

  @override
  String periodFormFlowOutOfRangeMessage(int count) {
    return '$count flow records are outside the new dates and will be deleted. Continue?';
  }

  @override
  String get periodFormFlowDeleteAndSave => 'Delete and save';

  @override
  String get authLoginTitle => 'Sign in to CycleCare';

  @override
  String get authRegisterTitle => 'Create CycleCare account';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordRepeatLabel => 'Repeat password';

  @override
  String get authLoginAction => 'Sign in';

  @override
  String get authRegisterAction => 'Sign up';

  @override
  String get authNoAccount => 'Don’t have an account? Sign up';

  @override
  String get authHaveAccount => 'Already have an account? Sign in';

  @override
  String get authInvalidEmail => 'Enter a valid email.';

  @override
  String get authPasswordMin => 'Password must be at least 6 characters.';

  @override
  String get authPasswordMismatch => 'Passwords do not match.';

  @override
  String get authRegisteredSuccess =>
      'Registration successful. Check email for confirmation, then sign in.';

  @override
  String get authGenericFailure => 'Failed. Check connection and try again.';

  @override
  String get tooltipOpenAccount => 'Open account and settings';

  @override
  String get tooltipRecordPeriod => 'Record period';

  @override
  String get snackbarPeriodFinishedToday => 'Period finished today.';

  @override
  String get snackbarPeriodStartedToday => 'Period started today.';

  @override
  String get errorDataSafeRetry =>
      'Your local data is safe. Try reloading to show latest notes.';

  @override
  String get loadingPreparingCycle => 'Preparing your cycle…';

  @override
  String get semanticsCycleHeroEmpty =>
      'No cycle records yet. Log a period to start.';

  @override
  String get syncBannerTersinkron => 'Synced';

  @override
  String get syncBannerOffline => 'Offline';
}
