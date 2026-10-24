// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'اسلامی عادات';

  @override
  String get navHome => 'ہوم';

  @override
  String get navPrayerTimes => 'اوقاتِ نماز';

  @override
  String get navAllHabits => 'تمام عادات';

  @override
  String get navFivePrayers => 'پانچ نمازیں';

  @override
  String get navAddHabit => 'نئی عادت شامل کریں';

  @override
  String get editHabitTitle => 'عادت میں ترمیم کریں';

  @override
  String get editHabitAction => 'عادت میں ترمیم کریں';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get settingsDarkMode => 'ڈارک موڈ';

  @override
  String get settingsStartOfWeek => 'ہفتے کا آغاز';

  @override
  String get settingsPrayerTimeSettings => 'اوقاتِ نماز کی ترتیبات';

  @override
  String get settingsPrayerTimeSettingsSubtitle =>
      'مقام، حساب کا طریقہ، اور نماز کی یاد دہانیاں';

  @override
  String get settingsBackupRestore => 'بیک اپ اور بحالی';

  @override
  String get settingsBackupRestoreSubtitle =>
      'اپنی عادات کا ڈیٹا ایکسپورٹ یا بحال کریں';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsLanguageSystem => 'فون کی زبان';

  @override
  String get todayHabits => 'آج کی عادات';

  @override
  String todayProgress(int completed, int total) {
    return 'آج: $completed / $total عادات مکمل';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return 'طویل ترین تسلسل: $daysText ۔ $habitName';
  }

  @override
  String get save => 'محفوظ کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get unsavedChangesTitle => 'غیر محفوظ تبدیلیاں';

  @override
  String get unsavedChangesMessage =>
      'نماز کی ترتیبات میں غیر محفوظ تبدیلیاں ہیں۔ کیا آپ جانے سے پہلے انہیں محفوظ کرنا چاہتے ہیں؟';

  @override
  String get discardChanges => 'رد کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get edit => 'ترمیم';

  @override
  String get archive => 'محفوظ کریں';

  @override
  String get unarchive => 'بحال کریں';

  @override
  String get archivedHabits => 'محفوظ شدہ عادات';

  @override
  String get noArchivedHabits => 'کوئی محفوظ شدہ عادت نہیں';

  @override
  String get archivedHabitsHint =>
      'محفوظ شدہ عادات اپنی تاریخ رکھتی ہیں لیکن ہوم اور اعداد و شمار سے پوشیدہ رہتی ہیں۔';

  @override
  String get habitIcon => 'آئیکن';

  @override
  String get chooseIcon => 'آئیکن منتخب کریں';

  @override
  String get removeIcon => 'آئیکن ہٹائیں';

  @override
  String get deleteHabitTitle => 'عادت حذف کریں؟';

  @override
  String deleteHabitMessage(String name) {
    return '\"$name\" اور اس کی تمام تاریخ مستقل طور پر حذف ہو جائے گی۔ اسے واپس نہیں کیا جا سکتا۔';
  }

  @override
  String get habitDeleted => 'عادت حذف ہو گئی';

  @override
  String get habitArchived => 'عادت محفوظ ہو گئی';

  @override
  String get habitRestored => 'عادت بحال ہو گئی';

  @override
  String get setValue => 'مقرر کریں';

  @override
  String get exportBackup => 'بیک اپ ایکسپورٹ کریں';

  @override
  String get restoreFromBackup => 'بیک اپ سے بحال کریں';

  @override
  String get habitName => 'عادت کا نام';

  @override
  String get successMetric => 'کامیابی کا معیار';

  @override
  String get yesNo => 'ہاں / نہیں';

  @override
  String get number => 'عدد';

  @override
  String get streakTarget => 'تسلسل کا ہدف';

  @override
  String get targetStreakDays => 'ہدف تسلسل (دن)';

  @override
  String get schedule => 'شیڈول';

  @override
  String get everyDay => 'ہر روز';

  @override
  String get certainDaysOfWeek => 'ہفتے کے مخصوص دن';

  @override
  String get timesPerWeek => 'ہفتے میں کئی بار';

  @override
  String get color => 'رنگ';

  @override
  String get saveHabit => 'عادت محفوظ کریں';

  @override
  String get habitFajrPrayer => 'نماز فجر';

  @override
  String get habitDhuhrPrayer => 'نماز ظہر';

  @override
  String get habitAsrPrayer => 'نماز عصر';

  @override
  String get habitMaghribPrayer => 'نماز مغرب';

  @override
  String get habitIshaPrayer => 'نماز عشاء';

  @override
  String get habitRecitingQuran => 'قرآن کی تلاوت';

  @override
  String get todayLabel => 'آج';

  @override
  String get prayerFajr => 'فجر';

  @override
  String get prayerDhuhr => 'ظہر';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشاء';

  @override
  String get notifyMode => 'مطلع کریں';

  @override
  String get silentMode => 'خاموش';

  @override
  String get adhanMode => 'اذان';

  @override
  String get weekdayMonday => 'پیر';

  @override
  String get weekdayTuesday => 'منگل';

  @override
  String get weekdayWednesday => 'بدھ';

  @override
  String get weekdayThursday => 'جمعرات';

  @override
  String get weekdayFriday => 'جمعہ';

  @override
  String get weekdaySaturday => 'ہفتہ';

  @override
  String get weekdaySunday => 'اتوار';

  @override
  String get settingsNumerals => 'اعداد کی طرز';

  @override
  String get numeralsWestern => 'مغربی (0, 1, 2…)';

  @override
  String get numeralsEastern => 'مشرقی عربی (٠, ١, ٢…)';

  @override
  String get unitPages => 'صفحات';

  @override
  String get deleteEntryTitle => 'اندراج حذف کریں';

  @override
  String get deleteEntryConfirm =>
      'کیا آپ واقعی اس اندراج کو مستقل طور پر حذف کرنا چاہتے ہیں؟';

  @override
  String get targetAmountLabel => 'ہدف مقدار';

  @override
  String get unitLabel => 'اکائی';

  @override
  String get timesPerWeekLabel => 'ہفتے میں دفعہ';

  @override
  String get restoreBackupTitle => 'بیک اپ بحال کریں';

  @override
  String get restoreBackupConfirm =>
      'اس سے اس آلے پر محفوظ تمام عادات منتخب بیک اپ کی عادات سے بدل جائیں گی۔ جاری رکھیں؟';

  @override
  String get restoreAction => 'بحال کریں';

  @override
  String get notificationPermissionDenied => 'اطلاع کی اجازت نہیں دی گئی';

  @override
  String get prayerRemindersLabel => 'نماز کی یاد دہانیاں';

  @override
  String get prayerRemindersSubtitle =>
      'ہر نماز کے 30 منٹ بعد پوچھا جائے گا کہ آیا آپ نے نماز ادا کی';

  @override
  String get sendTestReminder => 'ابھی ایک آزمائشی یاد دہانی بھیجیں';

  @override
  String get batteryOptimizationHint =>
      'اگر یاد دہانیاں اب بھی صحیح وقت پر موصول نہیں ہو رہیں تو ہو سکتا ہے آپ کے فون کی بیٹری آپٹیمائزیشن انہیں پس منظر میں تاخیر یا بلاک کر رہی ہو۔';

  @override
  String get batteryOptimizationButton =>
      'اس ایپ کو بیٹری آپٹیمائزیشن سے مستثنیٰ کریں';

  @override
  String get exactAlarmButton => 'عین وقت پر الارم کی اجازت دیں (تجویز کردہ)';

  @override
  String get exactAlarmGranted =>
      'عین وقت کے الارم کی اجازت ہے — یاد دہانیاں وقت پر موصول ہوں گی۔';

  @override
  String get exactAlarmNotGranted =>
      'عین وقت کے الارم کی اب بھی اجازت نہیں ہے — ابھی کھلنے والی سسٹم سیٹنگز اسکرین آزمائیں۔';

  @override
  String get adhanTakbeerOnlyLabel => 'صرف تکبیر';

  @override
  String get adhanTakbeerOnlyHint =>
      'مکمل ریکارڈنگ چلانے کے بجائے ابتدائی تکبیر کے بعد رک جائیں';

  @override
  String get adhanVoiceLabel => 'اذان کی آواز';

  @override
  String get adhanVoiceHint =>
      'اوقاتِ نماز کی سکرین پر اسپیکر آئیکن (اذان) پر مقرر نمازوں کے لیے استعمال ہوتی ہے۔';

  @override
  String get takbeerOnly => 'صرف تکبیر';

  @override
  String get fullAdhan => 'مکمل اذان';

  @override
  String get testAdhanVoice => 'یہ آواز آزمائیں';

  @override
  String get adhanAudioMissing =>
      'اس آواز کے لیے ابھی تک کوئی آڈیو فائل شامل نہیں کی گئی — اسے سننے کے لیے android/app/src/main/res/raw میں شامل کریں۔';

  @override
  String get locationLabel => 'مقام';

  @override
  String get cityLabel => 'شہر';

  @override
  String get latitudeLabel => 'عرض بلد';

  @override
  String get longitudeLabel => 'طول بلد';

  @override
  String get citySearchHint => 'شہر تلاش کریں';

  @override
  String get cityNotFoundPrompt => 'اپنا شہر نہیں مل رہا؟';

  @override
  String get pickOnMap => 'نقشے پر منتخب کریں';

  @override
  String get noCitiesFound => 'کوئی شہر نہیں ملا';

  @override
  String get mapPickerTitle => 'مقام منتخب کریں';

  @override
  String get mapPickerInstructions =>
      'نماز کے وقت کا مقام مقرر کرنے کے لیے نقشے پر کہیں بھی ٹیپ کریں';

  @override
  String get useThisLocation => 'یہ مقام استعمال کریں';

  @override
  String get customLocationLabel => 'حسب ضرورت مقام';

  @override
  String get calculationMethodLabel => 'حساب کا طریقہ';

  @override
  String get madhabLabel => 'مذہب (عصر کا حساب)';

  @override
  String get shafiLabel => 'شافعی';

  @override
  String get hanafiLabel => 'حنفی';

  @override
  String get manualCorrectionLabel => 'دستی تصحیح (منٹ)';

  @override
  String get adjFajr => 'فجر';

  @override
  String get adjDhuhr => 'ظہر';

  @override
  String get adjAsr => 'عصر';

  @override
  String get adjMaghrib => 'مغرب';

  @override
  String get adjIsha => 'عشاء';

  @override
  String get cityDoha => 'دوحہ';

  @override
  String get cityMecca => 'مکہ';

  @override
  String get cityMedina => 'مدینہ';

  @override
  String get cityCairo => 'قاہرہ';

  @override
  String get cityIstanbul => 'استنبول';

  @override
  String get cityJakarta => 'جکارتہ';

  @override
  String get cityKarachi => 'کراچی';

  @override
  String get cityLondon => 'لندن';

  @override
  String get cityNewYork => 'نیویارک';

  @override
  String get cityCustom => 'حسب ضرورت';

  @override
  String get notificationPrayerTimeTitle => 'نماز کا وقت';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return '$prayerName کا وقت ہو گیا ہے';
  }

  @override
  String get notificationReminderTitle => 'نماز کی یاد دہانی';

  @override
  String notificationReminderBody(String prayerName) {
    return 'کیا آپ نے $prayerName ادا کی؟';
  }

  @override
  String get notificationYes => 'ہاں';

  @override
  String get notificationNo => 'نہیں';

  @override
  String get weekdayMonShort => 'پیر';

  @override
  String get weekdayTueShort => 'منگل';

  @override
  String get weekdayWedShort => 'بدھ';

  @override
  String get weekdayThuShort => 'جمعرات';

  @override
  String get weekdayFriShort => 'جمعہ';

  @override
  String get weekdaySatShort => 'ہفتہ';

  @override
  String get weekdaySunShort => 'اتوار';

  @override
  String get pickAtLeastOneDay => 'ہفتے کا کم از کم ایک دن منتخب کریں';

  @override
  String get setValueTitle => 'قدر مقرر کریں';

  @override
  String setUnitTitle(String unit) {
    return '$unit مقرر کریں';
  }

  @override
  String get metricCurrentStreak => 'موجودہ تسلسل';

  @override
  String get metricStreakTarget => 'تسلسل کا ہدف';

  @override
  String get metricMaximumStreak => 'طویل ترین تسلسل';

  @override
  String get metricSuccessPercentage => 'کامیابی کا تناسب';

  @override
  String get metricWeeklyAverage => 'ہفتہ وار اوسط';

  @override
  String get metricMonthlyAverage => 'ماہانہ اوسط';

  @override
  String get backupDescription =>
      'تمام عادات کا ڈیٹا اس آلے پر مقامی طور پر محفوظ ہے۔ کاپی رکھنے کے لیے بیک اپ فائل ایکسپورٹ کریں یا اسے کلاؤڈ ڈرائیو یا ای میل پر شیئر کر کے دوسرے آلے پر منتقل کریں۔';

  @override
  String exportFailed(String error) {
    return 'ایکسپورٹ ناکام ہو گیا: $error';
  }

  @override
  String importFailed(String error) {
    return 'درآمد ناکام ہو گئی: $error';
  }

  @override
  String restoredCount(int count) {
    return '$count عادات بحال کی گئیں';
  }

  @override
  String get shareBackupText => 'اسلامی عادات کا بیک اپ';

  @override
  String get valueAddedSuccess => 'نئی قدر کامیابی سے شامل کر دی گئی';

  @override
  String get prayerSunrise => 'طلوع آفتاب';

  @override
  String get methodMuslimWorldLeague => 'رابطہ عالم اسلامی';

  @override
  String get methodEgyptian => 'مصری';

  @override
  String get methodKarachi => 'کراچی';

  @override
  String get methodUmmAlQura => 'ام القریٰ';

  @override
  String get methodDubai => 'دبئی';

  @override
  String get methodMoonSightingCommittee => 'رویت ہلال کمیٹی';

  @override
  String get methodNorthAmerica => 'شمالی امریکہ';

  @override
  String get methodKuwait => 'کویت';

  @override
  String get methodQatar => 'قطر';

  @override
  String get methodSingapore => 'سنگاپور';

  @override
  String get methodTurkey => 'ترکی';

  @override
  String get methodTehran => 'تہران';

  @override
  String get methodOther => 'دیگر';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دن',
      one: '$count دن',
    );
    return '$_temp0';
  }

  @override
  String nextPrayerCountdownHm(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ میں';
  }

  @override
  String nextPrayerCountdownM(int minutes) {
    return '$minutes منٹ میں';
  }

  @override
  String get customColor => 'حسبِ ضرورت رنگ';

  @override
  String get selectColor => 'منتخب کریں';

  @override
  String get navStatistics => 'اعداد و شمار';

  @override
  String get reminderLabel => 'یاد دہانی';

  @override
  String get reminderEnabledLabel => 'عادت کی یاد دہانی';

  @override
  String get reminderEnabledSubtitle =>
      'اپنے منتخب وقت پر اس عادت کے مقررہ دنوں میں اطلاع حاصل کریں';

  @override
  String get reminderTimeLabel => 'یاد دہانی کا وقت';

  @override
  String get reminderIndependentHint =>
      'یہ یاد دہانی نماز کی یاد دہانیوں سے الگ ہے اور نماز کی یاد دہانیاں بند ہونے پر بھی کام کرتی ہے۔';

  @override
  String reminderDailyAt(String time) {
    return '$time بجے';
  }

  @override
  String get reminderOff => 'بند';

  @override
  String get notificationHabitReminderTitle => 'عادت کی یاد دہانی';

  @override
  String notificationHabitReminderBody(String habitName) {
    return '$habitName کا وقت ہو گیا';
  }

  @override
  String get enterName => 'نام درج کریں';

  @override
  String get enterNumberGreaterThanZero => '0 سے بڑا عدد درج کریں';

  @override
  String get enterNumberOneToSeven => '1 سے 7 تک عدد درج کریں';

  @override
  String get onboardingSkip => 'چھوڑ دیں';

  @override
  String get onboardingNext => 'اگلا';

  @override
  String get onboardingGetStarted => 'شروع کریں';

  @override
  String get onboardingWelcomeTitle => 'Islamic Habits میں خوش آمدید';

  @override
  String get onboardingWelcomeBody =>
      'نماز، قرآن اور اپنی اہم عادات کے گرد ایک مستقل معمول بنائیں۔';

  @override
  String get onboardingHabitsTitle => 'دن میں ایک ٹیپ';

  @override
  String get onboardingHabitsBody =>
      'ہاں/نہیں اور عددی عادات کو ٹریک کریں، اپنے رنگ منتخب کریں اور اپنی پیش رفت ایک نظر میں دیکھیں۔';

  @override
  String get onboardingPrayerTitle => 'نماز کے اوقات، جہاں بھی ہوں';

  @override
  String get onboardingPrayerBody =>
      'ہزاروں شہروں میں سے انتخاب کریں یا درست نماز اوقات کے لیے اپنا صحیح مقام منتخب کریں۔';

  @override
  String get onboardingRemindersTitle => 'آپ کے دن کے مطابق یاد دہانیاں';

  @override
  String get onboardingRemindersBody =>
      'کسی بھی عادت کے لیے روزانہ یاد دہانی مقرر کریں اور اطلاع سے ہی ہاں یا نہیں کا جواب دیں۔';

  @override
  String get onboardingStatsTitle => 'اپنی پیش رفت دیکھیں';

  @override
  String get onboardingStatsBody =>
      'چارٹس، تسلسل اور کامیابی کی شرح آپ کو متحرک رہنے اور توجہ طلب چیزوں کی نشاندہی میں مدد دیتے ہیں۔';

  @override
  String get statisticsOverallSuccess => 'مجموعی کامیابی';

  @override
  String get statisticsOverallSuccessSubtitle =>
      'تمام ریکارڈ شدہ عادت کے دنوں میں';

  @override
  String get statisticsBestStreak => 'بہترین تسلسل';

  @override
  String get statisticsTotalHabits => 'عادات';

  @override
  String get statisticsDailyCompletion => 'روزانہ تکمیل';

  @override
  String get statisticsDailyCompletionSubtitle =>
      'گزشتہ 30 دنوں میں آپ کی عادات کی تکمیل';

  @override
  String get statisticsWeeklyProgress => 'ہفتہ وار پیش رفت';

  @override
  String get statisticsWeeklyProgressSubtitle =>
      'گزشتہ چار ہفتوں میں اوسط تکمیل';

  @override
  String get statisticsMonthlyProgress => 'ماہانہ پیش رفت';

  @override
  String get statisticsMonthlyProgressSubtitle => 'گزشتہ چھ ماہ میں اوسط تکمیل';

  @override
  String get statisticsBreakdown => 'عادات کی تفصیل';

  @override
  String get statisticsBreakdownSubtitle =>
      'گزشتہ 30 دنوں میں مکمل، رہ جانے والے اور غیر ریکارڈ شدہ عادت کے دن';

  @override
  String get statisticsSuccess => 'مکمل';

  @override
  String get statisticsMissed => 'رہ گیا';

  @override
  String get statisticsNoData => 'کوئی ڈیٹا نہیں';

  @override
  String get statisticsHabitPerformance => 'عادات کی کارکردگی';

  @override
  String get statisticsNoDataTitle => 'ابھی کوئی ڈیٹا نہیں';

  @override
  String get statisticsNoDataBody =>
      'چارٹس، تسلسل اور کامیابی کی شرح دیکھنے کے لیے اپنی عادات ریکارڈ کرنا شروع کریں۔';
}
