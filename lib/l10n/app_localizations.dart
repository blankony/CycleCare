import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CycleCare'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @actionRecordPeriod.
  ///
  /// In en, this message translates to:
  /// **'Record period'**
  String get actionRecordPeriod;

  /// No description provided for @actionUpdatePeriod.
  ///
  /// In en, this message translates to:
  /// **'Update period'**
  String get actionUpdatePeriod;

  /// No description provided for @actionStartPeriodToday.
  ///
  /// In en, this message translates to:
  /// **'Start period today'**
  String get actionStartPeriodToday;

  /// No description provided for @statusSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get statusSynced;

  /// No description provided for @statusSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get statusSyncing;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// No description provided for @statusSyncNeeded.
  ///
  /// In en, this message translates to:
  /// **'Needs sync'**
  String get statusSyncNeeded;

  /// No description provided for @statusSavedOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Saved on device'**
  String get statusSavedOnDevice;

  /// No description provided for @sectionCycleDisplay.
  ///
  /// In en, this message translates to:
  /// **'Cycle Display'**
  String get sectionCycleDisplay;

  /// No description provided for @sectionReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get sectionReminders;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageIndonesian;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languagePickerTitle;

  /// No description provided for @languagePickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get languagePickerSubtitle;

  /// No description provided for @homeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeToday;

  /// No description provided for @homeStartYourLog.
  ///
  /// In en, this message translates to:
  /// **'Start your log'**
  String get homeStartYourLog;

  /// No description provided for @homeDataGrowing.
  ///
  /// In en, this message translates to:
  /// **'Data growing'**
  String get homeDataGrowing;

  /// No description provided for @homeDayOfCycle.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String homeDayOfCycle(int day);

  /// No description provided for @homeLateByDays.
  ///
  /// In en, this message translates to:
  /// **'Late by {count} days from predicted window'**
  String homeLateByDays(int count);

  /// No description provided for @homeNextPeriodEstimate.
  ///
  /// In en, this message translates to:
  /// **'Next period estimate'**
  String get homeNextPeriodEstimate;

  /// No description provided for @homeNoPeriodEstimate.
  ///
  /// In en, this message translates to:
  /// **'No period estimate yet'**
  String get homeNoPeriodEstimate;

  /// No description provided for @homeLogAFewCycles.
  ///
  /// In en, this message translates to:
  /// **'Log a few cycles first'**
  String get homeLogAFewCycles;

  /// No description provided for @homeBasedOnCycles.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} cycles · Confidence {confidence}'**
  String homeBasedOnCycles(int count, String confidence);

  /// No description provided for @homePredictionWillChange.
  ///
  /// In en, this message translates to:
  /// **'Date may change with new logs.'**
  String get homePredictionWillChange;

  /// No description provided for @homeCycleStatusPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of period'**
  String homeCycleStatusPeriodDay(int day);

  /// No description provided for @homeCycleStatusLate.
  ///
  /// In en, this message translates to:
  /// **'Past predicted period'**
  String get homeCycleStatusLate;

  /// No description provided for @homeCycleStatusFertile.
  ///
  /// In en, this message translates to:
  /// **'Within fertile window estimate'**
  String get homeCycleStatusFertile;

  /// No description provided for @homeCycleStatusAfterOvulation.
  ///
  /// In en, this message translates to:
  /// **'After estimated ovulation'**
  String get homeCycleStatusAfterOvulation;

  /// No description provided for @homeCycleStatusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Cycle in progress'**
  String get homeCycleStatusOngoing;

  /// No description provided for @homeCycleStatusEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log your first period to begin'**
  String get homeCycleStatusEmpty;

  /// No description provided for @homeChipLate.
  ///
  /// In en, this message translates to:
  /// **'Past prediction'**
  String get homeChipLate;

  /// No description provided for @homeChipActiveCycle.
  ///
  /// In en, this message translates to:
  /// **'Active cycle'**
  String get homeChipActiveCycle;

  /// No description provided for @homeChipPeriodOngoing.
  ///
  /// In en, this message translates to:
  /// **'Period ongoing'**
  String get homeChipPeriodOngoing;

  /// No description provided for @homeTimelineCurrentCycle.
  ///
  /// In en, this message translates to:
  /// **'Current cycle'**
  String get homeTimelineCurrentCycle;

  /// No description provided for @homeTimelinePeriodRecorded.
  ///
  /// In en, this message translates to:
  /// **'Period recorded'**
  String get homeTimelinePeriodRecorded;

  /// No description provided for @homeTimelineFertile.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get homeTimelineFertile;

  /// No description provided for @homeTimelineOvulation.
  ///
  /// In en, this message translates to:
  /// **'Ovulation'**
  String get homeTimelineOvulation;

  /// No description provided for @homeTimelinePredictedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Predicted period'**
  String get homeTimelinePredictedPeriod;

  /// No description provided for @homeSectionCycleForecast.
  ///
  /// In en, this message translates to:
  /// **'Cycle forecast'**
  String get homeSectionCycleForecast;

  /// No description provided for @homeSectionForecastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Date may change with new logs.'**
  String get homeSectionForecastSubtitle;

  /// No description provided for @homePhaseFertile.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get homePhaseFertile;

  /// No description provided for @homePhaseOvulationEstimate.
  ///
  /// In en, this message translates to:
  /// **'Ovulation estimate'**
  String get homePhaseOvulationEstimate;

  /// No description provided for @homePhaseNextPeriod.
  ///
  /// In en, this message translates to:
  /// **'Next period'**
  String get homePhaseNextPeriod;

  /// No description provided for @homeConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence {label}'**
  String homeConfidence(String label);

  /// No description provided for @homeRangeMayChange.
  ///
  /// In en, this message translates to:
  /// **'Range may change'**
  String get homeRangeMayChange;

  /// No description provided for @homeForthcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get homeForthcoming;

  /// No description provided for @homeInAboutDays.
  ///
  /// In en, this message translates to:
  /// **'About {count} days left'**
  String homeInAboutDays(int count);

  /// No description provided for @homePredictionRangePast.
  ///
  /// In en, this message translates to:
  /// **'Predicted range has passed'**
  String get homePredictionRangePast;

  /// No description provided for @homeInsufficientDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough data'**
  String get homeInsufficientDataTitle;

  /// No description provided for @homeInsufficientDataBody.
  ///
  /// In en, this message translates to:
  /// **'Log a few cycles to make forecasts more personal.'**
  String get homeInsufficientDataBody;

  /// No description provided for @homeRecentSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of last {count} cycles'**
  String homeRecentSummaryTitle(int count);

  /// No description provided for @homeRecentSummaryGeneric.
  ///
  /// In en, this message translates to:
  /// **'Cycle summary'**
  String get homeRecentSummaryGeneric;

  /// No description provided for @homeViewStatistics.
  ///
  /// In en, this message translates to:
  /// **'View statistics'**
  String get homeViewStatistics;

  /// No description provided for @homeAverageCycle.
  ///
  /// In en, this message translates to:
  /// **'Average cycle length {value} days. Pattern is {pattern}.'**
  String homeAverageCycle(String value, String pattern);

  /// No description provided for @homePromptLogNext.
  ///
  /// In en, this message translates to:
  /// **'Log the next cycle to see your personal pattern.'**
  String get homePromptLogNext;

  /// No description provided for @homeFertilitySafety.
  ///
  /// In en, this message translates to:
  /// **'Fertile window estimates are not intended as contraception.'**
  String get homeFertilitySafety;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'CycleCare predictions are estimates based on your logged history, not a medical diagnosis.'**
  String get medicalDisclaimer;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get commonSaveChanges;

  /// No description provided for @commonSaveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get commonSaveNote;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get commonArchive;

  /// No description provided for @commonRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get commonRestore;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonBackToHistory.
  ///
  /// In en, this message translates to:
  /// **'Back to history'**
  String get commonBackToHistory;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your cycle calendar…'**
  String get calendarPreparing;

  /// No description provided for @calendarLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Calendar could not be loaded. Your health data stays safe on device.'**
  String get calendarLoadFailed;

  /// No description provided for @calendarPredictionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Forecast not available yet. Period notes remain accessible.'**
  String get calendarPredictionUnavailable;

  /// No description provided for @calendarPreferencesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Fertile choices could not be loaded. Estimates temporarily hidden.'**
  String get calendarPreferencesUnavailable;

  /// No description provided for @calendarLoading.
  ///
  /// In en, this message translates to:
  /// **'Forecast and calendar preferences are being prepared.'**
  String get calendarLoading;

  /// No description provided for @calendarPeriodRecorded.
  ///
  /// In en, this message translates to:
  /// **'Period recorded'**
  String get calendarPeriodRecorded;

  /// No description provided for @calendarPredictedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Predicted period'**
  String get calendarPredictedPeriod;

  /// No description provided for @calendarFertileWindow.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get calendarFertileWindow;

  /// No description provided for @calendarOvulation.
  ///
  /// In en, this message translates to:
  /// **'Ovulation'**
  String get calendarOvulation;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarRecordedDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Period recorded'**
  String get calendarRecordedDetailTitle;

  /// No description provided for @calendarPredictedDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Predicted period'**
  String get calendarPredictedDetailTitle;

  /// No description provided for @calendarFertileDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Fertile window (estimate)'**
  String get calendarFertileDetailTitle;

  /// No description provided for @calendarOvulationDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Ovulation (estimate)'**
  String get calendarOvulationDetailTitle;

  /// No description provided for @calendarStartOngoing.
  ///
  /// In en, this message translates to:
  /// **'Started {date} and still ongoing.'**
  String calendarStartOngoing(String date);

  /// No description provided for @calendarStartToEnd.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}.'**
  String calendarStartToEnd(String start, String end);

  /// No description provided for @calendarEmptyNoRecord.
  ///
  /// In en, this message translates to:
  /// **'No record or estimate on this date.'**
  String get calendarEmptyNoRecord;

  /// No description provided for @calendarEmptyFirstPrompt.
  ///
  /// In en, this message translates to:
  /// **'No period records yet. Log your first period to see cycle patterns.'**
  String get calendarEmptyFirstPrompt;

  /// No description provided for @calendarFinishPeriodToday.
  ///
  /// In en, this message translates to:
  /// **'Finish period today'**
  String get calendarFinishPeriodToday;

  /// No description provided for @calendarStartPeriodToday.
  ///
  /// In en, this message translates to:
  /// **'Start period today'**
  String get calendarStartPeriodToday;

  /// No description provided for @calendarSafetyNote.
  ///
  /// In en, this message translates to:
  /// **'Estimates may change with new logs. Fertile window estimates are not contraception guidance.'**
  String get calendarSafetyNote;

  /// No description provided for @calendarMonthFormat.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarMonthFormat;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Period history'**
  String get historyTitle;

  /// No description provided for @historyPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your period history…'**
  String get historyPreparing;

  /// No description provided for @historyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'History could not be loaded. Your health data stays safe on device.'**
  String get historyLoadFailed;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No period history yet.'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Log your first period to start seeing cycle patterns.'**
  String get historyEmptyMessage;

  /// No description provided for @historyNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest notes appear first to review cycle patterns easily.'**
  String get historyNewestFirst;

  /// No description provided for @historyPersonalStats.
  ///
  /// In en, this message translates to:
  /// **'Personal statistics'**
  String get historyPersonalStats;

  /// No description provided for @historyOpenStats.
  ///
  /// In en, this message translates to:
  /// **'Open personal statistics'**
  String get historyOpenStats;

  /// No description provided for @historyFlowUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Flow summary could not be loaded. Period notes remain available.'**
  String get historyFlowUnavailable;

  /// No description provided for @historyFlowLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing flow summary.'**
  String get historyFlowLoading;

  /// No description provided for @historyRecordedChip.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get historyRecordedChip;

  /// No description provided for @historyOngoingChip.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get historyOngoingChip;

  /// No description provided for @historyDaysChip.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String historyDaysChip(int count);

  /// No description provided for @historyCycleChip.
  ///
  /// In en, this message translates to:
  /// **'Cycle {count} days'**
  String historyCycleChip(int count);

  /// No description provided for @historyViewSummary.
  ///
  /// In en, this message translates to:
  /// **'View summary'**
  String get historyViewSummary;

  /// No description provided for @historyArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive note?'**
  String get historyArchiveTitle;

  /// No description provided for @historyArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Note is not permanently deleted and can be restored from Settings.'**
  String get historyArchiveMessage;

  /// No description provided for @historyFlowNone.
  ///
  /// In en, this message translates to:
  /// **'No flow logged yet.'**
  String get historyFlowNone;

  /// No description provided for @historyArchiveAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get historyArchiveAction;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsCycleDisplay.
  ///
  /// In en, this message translates to:
  /// **'Cycle Display'**
  String get settingsCycleDisplay;

  /// No description provided for @settingsOvulationEstimate.
  ///
  /// In en, this message translates to:
  /// **'Ovulation estimate'**
  String get settingsOvulationEstimate;

  /// No description provided for @settingsFertileWindow.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get settingsFertileWindow;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// No description provided for @settingsReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get settingsReminderTime;

  /// No description provided for @settingsReminderTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders are delivered at this time'**
  String get settingsReminderTimeSubtitle;

  /// No description provided for @settingsPillReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Pill reminder time'**
  String get settingsPillReminderTime;

  /// No description provided for @settingsDailyCheckin.
  ///
  /// In en, this message translates to:
  /// **'Daily mood check-in'**
  String get settingsDailyCheckin;

  /// No description provided for @settingsDailyCheckinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle reminder while your period is ongoing'**
  String get settingsDailyCheckinSubtitle;

  /// No description provided for @settingsDailyCheckinOngoingOnly.
  ///
  /// In en, this message translates to:
  /// **'Delivered only while a period is ongoing.'**
  String get settingsDailyCheckinOngoingOnly;

  /// No description provided for @settingsPeriodHeadsUp.
  ///
  /// In en, this message translates to:
  /// **'Period heads-up (2 days before)'**
  String get settingsPeriodHeadsUp;

  /// No description provided for @settingsPeriodHeadsUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder 2 days before the predicted start date'**
  String get settingsPeriodHeadsUpSubtitle;

  /// No description provided for @settingsOvulationReminder.
  ///
  /// In en, this message translates to:
  /// **'Ovulation day reminder'**
  String get settingsOvulationReminder;

  /// No description provided for @settingsOvulationReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder on the predicted ovulation day'**
  String get settingsOvulationReminderSubtitle;

  /// No description provided for @settingsPillReminder.
  ///
  /// In en, this message translates to:
  /// **'Pill / supplement reminder'**
  String get settingsPillReminder;

  /// No description provided for @settingsPillReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder at your chosen time'**
  String get settingsPillReminderSubtitle;

  /// No description provided for @settingsNotificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied. Enable notifications in system settings to receive reminders.'**
  String get settingsNotificationPermissionDenied;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsBiometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock'**
  String get settingsBiometricLock;

  /// No description provided for @settingsTestAuth.
  ///
  /// In en, this message translates to:
  /// **'Test device authentication'**
  String get settingsTestAuth;

  /// No description provided for @settingsCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud & sync'**
  String get settingsCloudSync;

  /// No description provided for @settingsActiveAccount.
  ///
  /// In en, this message translates to:
  /// **'Active account'**
  String get settingsActiveAccount;

  /// No description provided for @settingsSupabaseAccount.
  ///
  /// In en, this message translates to:
  /// **'Supabase account'**
  String get settingsSupabaseAccount;

  /// No description provided for @settingsSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get settingsSyncNow;

  /// No description provided for @settingsRetrySync.
  ///
  /// In en, this message translates to:
  /// **'Retry sync'**
  String get settingsRetrySync;

  /// No description provided for @settingsLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get settingsLastSync;

  /// No description provided for @settingsNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'Never synced successfully'**
  String get settingsNeverSynced;

  /// No description provided for @settingsBackupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackupRestore;

  /// No description provided for @settingsManageBackup.
  ///
  /// In en, this message translates to:
  /// **'Manage local backup'**
  String get settingsManageBackup;

  /// No description provided for @settingsArchivedNotes.
  ///
  /// In en, this message translates to:
  /// **'Archived notes'**
  String get settingsArchivedNotes;

  /// No description provided for @settingsNoArchived.
  ///
  /// In en, this message translates to:
  /// **'No archived notes.'**
  String get settingsNoArchived;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get settingsSignOutTitle;

  /// No description provided for @settingsSignOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You can sign back in with the same Supabase account.'**
  String get settingsSignOutMessage;

  /// No description provided for @settingsDeleteCloud.
  ///
  /// In en, this message translates to:
  /// **'Delete cloud account'**
  String get settingsDeleteCloud;

  /// No description provided for @settingsDeleteCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete cloud account?'**
  String get settingsDeleteCloudTitle;

  /// No description provided for @settingsDeleteCloudMessage.
  ///
  /// In en, this message translates to:
  /// **'Supabase account, profile, and all related cloud data will be permanently deleted.'**
  String get settingsDeleteCloudMessage;

  /// No description provided for @settingsDeleteCloudConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Final confirmation'**
  String get settingsDeleteCloudConfirmTitle;

  /// No description provided for @settingsDeleteCloudConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Delete account and cloud data?'**
  String get settingsDeleteCloudConfirmMessage;

  /// No description provided for @settingsDeleteCloudAction.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteCloudAction;

  /// No description provided for @settingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get settingsDangerZone;

  /// No description provided for @settingsDeleteLocal.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data'**
  String get settingsDeleteLocal;

  /// No description provided for @settingsDeleteLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data?'**
  String get settingsDeleteLocalTitle;

  /// No description provided for @settingsDeleteLocalMessage.
  ///
  /// In en, this message translates to:
  /// **'All periods, predictions, settings, and sync queue will be deleted from device. Cloud data may resync after next initial sync. Supabase account is not deleted.'**
  String get settingsDeleteLocalMessage;

  /// No description provided for @settingsDeleteLocalConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Final confirmation'**
  String get settingsDeleteLocalConfirmTitle;

  /// No description provided for @settingsDeleteLocalConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Continue?'**
  String get settingsDeleteLocalConfirmMessage;

  /// No description provided for @settingsDeleteLocalAction.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get settingsDeleteLocalAction;

  /// No description provided for @settingsLocalDeleted.
  ///
  /// In en, this message translates to:
  /// **'Local data deleted.'**
  String get settingsLocalDeleted;

  /// No description provided for @settingsBiometricNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This device does not support biometric lock.'**
  String get settingsBiometricNotSupported;

  /// No description provided for @settingsBiometricCancelled.
  ///
  /// In en, this message translates to:
  /// **'Authentication cancelled. Lock remains off.'**
  String get settingsBiometricCancelled;

  /// No description provided for @settingsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update preference: {error}'**
  String settingsUpdateFailed(String error);

  /// No description provided for @periodFormUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update period'**
  String get periodFormUpdateTitle;

  /// No description provided for @periodFormCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Record period'**
  String get periodFormCreateTitle;

  /// No description provided for @periodFormUpdateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update dates, daily flow, or notes without changing other data.'**
  String get periodFormUpdateSubtitle;

  /// No description provided for @periodFormCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log dates and daily flow you remember. Everything can be updated later.'**
  String get periodFormCreateSubtitle;

  /// No description provided for @periodFormDateRecordedChip.
  ///
  /// In en, this message translates to:
  /// **'Data recorded'**
  String get periodFormDateRecordedChip;

  /// No description provided for @periodFormSectionDates.
  ///
  /// In en, this message translates to:
  /// **'Period dates'**
  String get periodFormSectionDates;

  /// No description provided for @periodFormDatesHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure the date range matches your notes.'**
  String get periodFormDatesHint;

  /// No description provided for @periodFormStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get periodFormStartDate;

  /// No description provided for @periodFormEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get periodFormEndDate;

  /// No description provided for @periodFormOngoing.
  ///
  /// In en, this message translates to:
  /// **'Still ongoing'**
  String get periodFormOngoing;

  /// No description provided for @periodFormOngoingHint.
  ///
  /// In en, this message translates to:
  /// **'Enable if period has not finished.'**
  String get periodFormOngoingHint;

  /// No description provided for @periodFormFlowSection.
  ///
  /// In en, this message translates to:
  /// **'Daily flow'**
  String get periodFormFlowSection;

  /// No description provided for @periodFormFlowHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Each date can be updated separately.'**
  String get periodFormFlowHint;

  /// No description provided for @periodFormFlowLoading.
  ///
  /// In en, this message translates to:
  /// **'Saved flow is loading.'**
  String get periodFormFlowLoading;

  /// No description provided for @periodFormFlowUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Saved flow could not be loaded. New choices can still be saved.'**
  String get periodFormFlowUnavailable;

  /// No description provided for @periodFormNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Optional notes'**
  String get periodFormNotesTitle;

  /// No description provided for @periodFormNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Avoid unnecessary details to keep notes concise.'**
  String get periodFormNotesHint;

  /// No description provided for @periodFormNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get periodFormNotesLabel;

  /// No description provided for @periodFormNotesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add personal notes if needed'**
  String get periodFormNotesPlaceholder;

  /// No description provided for @periodFormPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'This note is stored as your account’s private data.'**
  String get periodFormPrivacyNote;

  /// No description provided for @periodFormSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get periodFormSaving;

  /// No description provided for @periodFormPickStartHelp.
  ///
  /// In en, this message translates to:
  /// **'Pick start date'**
  String get periodFormPickStartHelp;

  /// No description provided for @periodFormPickEndHelp.
  ///
  /// In en, this message translates to:
  /// **'Pick end date'**
  String get periodFormPickEndHelp;

  /// No description provided for @periodFormValidationStartFuture.
  ///
  /// In en, this message translates to:
  /// **'Start date cannot be in the future.'**
  String get periodFormValidationStartFuture;

  /// No description provided for @periodFormValidationEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'End date cannot be before start date.'**
  String get periodFormValidationEndBeforeStart;

  /// No description provided for @periodFormValidationEndFuture.
  ///
  /// In en, this message translates to:
  /// **'End date cannot be in the future.'**
  String get periodFormValidationEndFuture;

  /// No description provided for @periodFormOverlap.
  ///
  /// In en, this message translates to:
  /// **'This range overlaps another record.'**
  String get periodFormOverlap;

  /// No description provided for @periodFormSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Note could not be saved. Please try again.'**
  String get periodFormSaveFailed;

  /// No description provided for @periodFormFlowHapus.
  ///
  /// In en, this message translates to:
  /// **'Remove flow'**
  String get periodFormFlowHapus;

  /// No description provided for @periodFormFlowOutOfRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Flow outside period range'**
  String get periodFormFlowOutOfRangeTitle;

  /// No description provided for @periodFormFlowOutOfRangeMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} flow records are outside the new dates and will be deleted. Continue?'**
  String periodFormFlowOutOfRangeMessage(int count);

  /// No description provided for @periodFormFlowDeleteAndSave.
  ///
  /// In en, this message translates to:
  /// **'Delete and save'**
  String get periodFormFlowDeleteAndSave;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to CycleCare'**
  String get authLoginTitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create CycleCare account'**
  String get authRegisterTitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get authPasswordRepeatLabel;

  /// No description provided for @authLoginAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginAction;

  /// No description provided for @authRegisterAction.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authRegisterAction;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? Sign up'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authHaveAccount;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get authInvalidEmail;

  /// No description provided for @authPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authPasswordMin;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authPasswordMismatch;

  /// No description provided for @authRegisteredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful. Check email for confirmation, then sign in.'**
  String get authRegisteredSuccess;

  /// No description provided for @authGenericFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed. Check connection and try again.'**
  String get authGenericFailure;

  /// No description provided for @tooltipOpenAccount.
  ///
  /// In en, this message translates to:
  /// **'Open account and settings'**
  String get tooltipOpenAccount;

  /// No description provided for @tooltipRecordPeriod.
  ///
  /// In en, this message translates to:
  /// **'Record period'**
  String get tooltipRecordPeriod;

  /// No description provided for @snackbarPeriodFinishedToday.
  ///
  /// In en, this message translates to:
  /// **'Period finished today.'**
  String get snackbarPeriodFinishedToday;

  /// No description provided for @snackbarPeriodStartedToday.
  ///
  /// In en, this message translates to:
  /// **'Period started today.'**
  String get snackbarPeriodStartedToday;

  /// No description provided for @errorDataSafeRetry.
  ///
  /// In en, this message translates to:
  /// **'Your local data is safe. Try reloading to show latest notes.'**
  String get errorDataSafeRetry;

  /// No description provided for @loadingPreparingCycle.
  ///
  /// In en, this message translates to:
  /// **'Preparing your cycle…'**
  String get loadingPreparingCycle;

  /// No description provided for @semanticsCycleHeroEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cycle records yet. Log a period to start.'**
  String get semanticsCycleHeroEmpty;

  /// No description provided for @syncBannerTersinkron.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get syncBannerTersinkron;

  /// No description provided for @syncBannerOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get syncBannerOffline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
