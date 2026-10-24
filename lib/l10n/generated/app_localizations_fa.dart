// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'عادات اسلامی';

  @override
  String get navHome => 'خانه';

  @override
  String get navPrayerTimes => 'اوقات نماز';

  @override
  String get navAllHabits => 'همه عادات';

  @override
  String get navFivePrayers => 'پنج نماز';

  @override
  String get navAddHabit => 'افزودن عادت جدید';

  @override
  String get editHabitTitle => 'ویرایش عادت';

  @override
  String get editHabitAction => 'ویرایش عادت';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get settingsDarkMode => 'حالت تاریک';

  @override
  String get settingsStartOfWeek => 'آغاز هفته';

  @override
  String get settingsPrayerTimeSettings => 'تنظیمات اوقات نماز';

  @override
  String get settingsPrayerTimeSettingsSubtitle =>
      'مکان، روش محاسبه و یادآورهای نماز';

  @override
  String get settingsBackupRestore => 'پشتیبان‌گیری و بازیابی';

  @override
  String get settingsBackupRestoreSubtitle =>
      'داده‌های عادات خود را برون‌بری یا بازیابی کنید';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsLanguageSystem => 'زبان گوشی';

  @override
  String get todayHabits => 'عادات امروز';

  @override
  String todayProgress(int completed, int total) {
    return 'امروز: $completed از $total عادت انجام شد';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return 'طولانی‌ترین زنجیره: $daysText · $habitName';
  }

  @override
  String get save => 'ذخیره';

  @override
  String get cancel => 'لغو';

  @override
  String get unsavedChangesTitle => 'تغییرات ذخیره‌نشده';

  @override
  String get unsavedChangesMessage =>
      'تغییرات ذخیره‌نشده‌ای در تنظیمات نماز دارید. آیا می‌خواهید پیش از خروج آن‌ها را ذخیره کنید؟';

  @override
  String get discardChanges => 'نادیده گرفتن';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'ویرایش';

  @override
  String get archive => 'بایگانی';

  @override
  String get unarchive => 'بازگردانی';

  @override
  String get archivedHabits => 'عادت‌های بایگانی‌شده';

  @override
  String get noArchivedHabits => 'عادت بایگانی‌شده‌ای نیست';

  @override
  String get archivedHabitsHint =>
      'عادت‌های بایگانی‌شده سابقه خود را نگه می‌دارند اما از صفحه اصلی و آمار پنهان می‌شوند.';

  @override
  String get habitIcon => 'نماد';

  @override
  String get chooseIcon => 'انتخاب نماد';

  @override
  String get removeIcon => 'حذف نماد';

  @override
  String get deleteHabitTitle => 'حذف عادت؟';

  @override
  String deleteHabitMessage(String name) {
    return '«$name» و تمام سابقه آن برای همیشه حذف می‌شود. این کار قابل بازگشت نیست.';
  }

  @override
  String get habitDeleted => 'عادت حذف شد';

  @override
  String get habitArchived => 'عادت بایگانی شد';

  @override
  String get habitRestored => 'عادت بازگردانده شد';

  @override
  String get setValue => 'تنظیم';

  @override
  String get exportBackup => 'برون‌بری پشتیبان';

  @override
  String get restoreFromBackup => 'بازیابی از پشتیبان';

  @override
  String get habitName => 'نام عادت';

  @override
  String get successMetric => 'معیار موفقیت';

  @override
  String get yesNo => 'بله / خیر';

  @override
  String get number => 'عدد';

  @override
  String get streakTarget => 'هدف زنجیره';

  @override
  String get targetStreakDays => 'هدف زنجیره (روز)';

  @override
  String get schedule => 'برنامه';

  @override
  String get everyDay => 'هر روز';

  @override
  String get certainDaysOfWeek => 'روزهای مشخصی از هفته';

  @override
  String get timesPerWeek => 'چند بار در هفته';

  @override
  String get color => 'رنگ';

  @override
  String get saveHabit => 'ذخیره عادت';

  @override
  String get habitFajrPrayer => 'نماز فجر';

  @override
  String get habitDhuhrPrayer => 'نماز ظهر';

  @override
  String get habitAsrPrayer => 'نماز عصر';

  @override
  String get habitMaghribPrayer => 'نماز مغرب';

  @override
  String get habitIshaPrayer => 'نماز عشاء';

  @override
  String get habitRecitingQuran => 'تلاوت قرآن';

  @override
  String get todayLabel => 'امروز';

  @override
  String get prayerFajr => 'فجر';

  @override
  String get prayerDhuhr => 'ظهر';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشاء';

  @override
  String get notifyMode => 'اعلان';

  @override
  String get silentMode => 'بی‌صدا';

  @override
  String get adhanMode => 'اذان';

  @override
  String get weekdayMonday => 'دوشنبه';

  @override
  String get weekdayTuesday => 'سه‌شنبه';

  @override
  String get weekdayWednesday => 'چهارشنبه';

  @override
  String get weekdayThursday => 'پنجشنبه';

  @override
  String get weekdayFriday => 'جمعه';

  @override
  String get weekdaySaturday => 'شنبه';

  @override
  String get weekdaySunday => 'یکشنبه';

  @override
  String get settingsNumerals => 'شکل اعداد';

  @override
  String get numeralsWestern => 'غربی (0, 1, 2…)';

  @override
  String get numeralsEastern => 'عربی شرقی (٠, ١, ٢…)';

  @override
  String get unitPages => 'صفحه';

  @override
  String get deleteEntryTitle => 'حذف مورد';

  @override
  String get deleteEntryConfirm =>
      'آیا مطمئن هستید که می‌خواهید این مورد را برای همیشه حذف کنید؟';

  @override
  String get targetAmountLabel => 'مقدار هدف';

  @override
  String get unitLabel => 'واحد';

  @override
  String get timesPerWeekLabel => 'دفعات در هفته';

  @override
  String get restoreBackupTitle => 'بازیابی پشتیبان';

  @override
  String get restoreBackupConfirm =>
      'این کار همه عادات ذخیره‌شده در این دستگاه را با عادات پشتیبان انتخاب‌شده جایگزین می‌کند. ادامه می‌دهید؟';

  @override
  String get restoreAction => 'بازیابی';

  @override
  String get notificationPermissionDenied => 'اجازه اعلان داده نشد';

  @override
  String get prayerRemindersLabel => 'یادآورهای نماز';

  @override
  String get prayerRemindersSubtitle =>
      '۳۰ دقیقه پس از هر نماز، پرسیده می‌شود که آیا نماز خوانده‌اید';

  @override
  String get sendTestReminder => 'ارسال یک یادآور آزمایشی اکنون';

  @override
  String get batteryOptimizationHint =>
      'اگر یادآورها هنوز در زمان درست نمی‌رسند، ممکن است بهینه‌سازی باتری گوشی شما آن‌ها را در پس‌زمینه به تأخیر بیندازد یا مسدود کند.';

  @override
  String get batteryOptimizationButton =>
      'این برنامه را از بهینه‌سازی باتری مستثنی کنید';

  @override
  String get exactAlarmButton => 'اجازه زمان‌بندی دقیق هشدار (توصیه‌شده)';

  @override
  String get exactAlarmGranted =>
      'زمان‌های دقیق مجاز است — یادآوری‌ها به‌موقع فعال می‌شوند.';

  @override
  String get exactAlarmNotGranted =>
      'زمان‌های دقیق هنوز مجاز نیست — صفحه تنظیمات سیستم که اکنون باز شد را امتحان کنید.';

  @override
  String get adhanTakbeerOnlyLabel => 'فقط تکبیر';

  @override
  String get adhanTakbeerOnlyHint =>
      'به‌جای پخش کامل ضبط، بعد از تکبیر ابتدایی متوقف شود';

  @override
  String get adhanVoiceLabel => 'صدای اذان';

  @override
  String get adhanVoiceHint =>
      'برای نمازهایی که روی نماد بلندگو (اذان) در صفحه اوقات نماز تنظیم شده‌اند استفاده می‌شود.';

  @override
  String get takbeerOnly => 'فقط تکبیر';

  @override
  String get fullAdhan => 'اذان کامل';

  @override
  String get testAdhanVoice => 'آزمایش این صدا';

  @override
  String get adhanAudioMissing =>
      'هنوز فایل صوتی برای این صدا اضافه نشده است — برای شنیدن آن، آن را در android/app/src/main/res/raw قرار دهید.';

  @override
  String get locationLabel => 'مکان';

  @override
  String get cityLabel => 'شهر';

  @override
  String get latitudeLabel => 'عرض جغرافیایی';

  @override
  String get longitudeLabel => 'طول جغرافیایی';

  @override
  String get citySearchHint => 'جستجوی شهر';

  @override
  String get cityNotFoundPrompt => 'شهر خود را پیدا نمی‌کنید؟';

  @override
  String get pickOnMap => 'انتخاب روی نقشه';

  @override
  String get noCitiesFound => 'هیچ شهری یافت نشد';

  @override
  String get mapPickerTitle => 'انتخاب مکان';

  @override
  String get mapPickerInstructions =>
      'برای تعیین مکان محاسبه اوقات نماز، هر جایی از نقشه را لمس کنید';

  @override
  String get useThisLocation => 'استفاده از این مکان';

  @override
  String get customLocationLabel => 'مکان سفارشی';

  @override
  String get calculationMethodLabel => 'روش محاسبه';

  @override
  String get madhabLabel => 'مذهب (محاسبه عصر)';

  @override
  String get shafiLabel => 'شافعی';

  @override
  String get hanafiLabel => 'حنفی';

  @override
  String get manualCorrectionLabel => 'تصحیح دستی (دقیقه)';

  @override
  String get adjFajr => 'فجر';

  @override
  String get adjDhuhr => 'ظهر';

  @override
  String get adjAsr => 'عصر';

  @override
  String get adjMaghrib => 'مغرب';

  @override
  String get adjIsha => 'عشاء';

  @override
  String get cityDoha => 'دوحه';

  @override
  String get cityMecca => 'مکه';

  @override
  String get cityMedina => 'مدینه';

  @override
  String get cityCairo => 'قاهره';

  @override
  String get cityIstanbul => 'استانبول';

  @override
  String get cityJakarta => 'جاکارتا';

  @override
  String get cityKarachi => 'کراچی';

  @override
  String get cityLondon => 'لندن';

  @override
  String get cityNewYork => 'نیویورک';

  @override
  String get cityCustom => 'سفارشی';

  @override
  String get notificationPrayerTimeTitle => 'وقت نماز';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return 'وقت $prayerName فرا رسیده است';
  }

  @override
  String get notificationReminderTitle => 'یادآور نماز';

  @override
  String notificationReminderBody(String prayerName) {
    return 'آیا $prayerName را خوانده‌اید؟';
  }

  @override
  String get notificationYes => 'بله';

  @override
  String get notificationNo => 'خیر';

  @override
  String get weekdayMonShort => 'دوشنبه';

  @override
  String get weekdayTueShort => 'سه‌شنبه';

  @override
  String get weekdayWedShort => 'چهارشنبه';

  @override
  String get weekdayThuShort => 'پنجشنبه';

  @override
  String get weekdayFriShort => 'جمعه';

  @override
  String get weekdaySatShort => 'شنبه';

  @override
  String get weekdaySunShort => 'یکشنبه';

  @override
  String get pickAtLeastOneDay => 'حداقل یک روز از هفته را انتخاب کنید';

  @override
  String get setValueTitle => 'تنظیم مقدار';

  @override
  String setUnitTitle(String unit) {
    return 'تنظیم $unit';
  }

  @override
  String get metricCurrentStreak => 'زنجیره فعلی';

  @override
  String get metricStreakTarget => 'هدف زنجیره';

  @override
  String get metricMaximumStreak => 'طولانی‌ترین زنجیره';

  @override
  String get metricSuccessPercentage => 'درصد موفقیت';

  @override
  String get metricWeeklyAverage => 'میانگین هفتگی';

  @override
  String get metricMonthlyAverage => 'میانگین ماهانه';

  @override
  String get backupDescription =>
      'تمام داده‌های عادات به‌صورت محلی روی این دستگاه ذخیره می‌شوند. برای نگه‌داشتن یک نسخه یا انتقال آن به دستگاه دیگر، مثلاً با اشتراک‌گذاری در فضای ابری یا ایمیل، یک فایل پشتیبان برون‌بری کنید.';

  @override
  String exportFailed(String error) {
    return 'برون‌بری ناموفق بود: $error';
  }

  @override
  String importFailed(String error) {
    return 'درون‌ریزی ناموفق بود: $error';
  }

  @override
  String restoredCount(int count) {
    return '$count عادت بازیابی شد';
  }

  @override
  String get shareBackupText => 'پشتیبان عادات اسلامی';

  @override
  String get valueAddedSuccess => 'مقدار جدید با موفقیت افزوده شد';

  @override
  String get prayerSunrise => 'طلوع آفتاب';

  @override
  String get methodMuslimWorldLeague => 'رابطه جهانی اسلامی';

  @override
  String get methodEgyptian => 'مصری';

  @override
  String get methodKarachi => 'کراچی';

  @override
  String get methodUmmAlQura => 'ام القری';

  @override
  String get methodDubai => 'دبی';

  @override
  String get methodMoonSightingCommittee => 'کمیته رؤیت هلال';

  @override
  String get methodNorthAmerica => 'آمریکای شمالی';

  @override
  String get methodKuwait => 'کویت';

  @override
  String get methodQatar => 'قطر';

  @override
  String get methodSingapore => 'سنگاپور';

  @override
  String get methodTurkey => 'ترکیه';

  @override
  String get methodTehran => 'تهران';

  @override
  String get methodOther => 'سایر';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز',
      one: '$count روز',
    );
    return '$_temp0';
  }

  @override
  String nextPrayerCountdownHm(int hours, int minutes) {
    return '$hours ساعت و $minutes دقیقه دیگر';
  }

  @override
  String nextPrayerCountdownM(int minutes) {
    return '$minutes دقیقه دیگر';
  }

  @override
  String get customColor => 'رنگ سفارشی';

  @override
  String get selectColor => 'انتخاب';

  @override
  String get navStatistics => 'آمار';

  @override
  String get reminderLabel => 'یادآور';

  @override
  String get reminderEnabledLabel => 'یادآور عادت';

  @override
  String get reminderEnabledSubtitle =>
      'در زمان انتخابی خود و در روزهای تعیین‌شدهٔ این عادت اعلان دریافت کنید';

  @override
  String get reminderTimeLabel => 'زمان یادآور';

  @override
  String get reminderIndependentHint =>
      'این یادآور جدا از یادآورهای نماز است و حتی وقتی یادآورهای نماز خاموش باشند کار می‌کند.';

  @override
  String reminderDailyAt(String time) {
    return 'ساعت $time';
  }

  @override
  String get reminderOff => 'خاموش';

  @override
  String get notificationHabitReminderTitle => 'یادآور عادت';

  @override
  String notificationHabitReminderBody(String habitName) {
    return 'وقت $habitName است';
  }

  @override
  String get enterName => 'نامی وارد کنید';

  @override
  String get enterNumberGreaterThanZero => 'عددی بزرگ‌تر از ۰ وارد کنید';

  @override
  String get enterNumberOneToSeven => 'عددی از ۱ تا ۷ وارد کنید';

  @override
  String get onboardingSkip => 'رد کردن';

  @override
  String get onboardingNext => 'بعدی';

  @override
  String get onboardingGetStarted => 'شروع کنید';

  @override
  String get onboardingWelcomeTitle => 'به Islamic Habits خوش آمدید';

  @override
  String get onboardingWelcomeBody =>
      'روتینی منظم حول نماز، قرآن و عاداتی که برایتان مهم‌اند بسازید.';

  @override
  String get onboardingHabitsTitle => 'روزی یک لمس';

  @override
  String get onboardingHabitsBody =>
      'عادت‌های بله/خیر و عددی را دنبال کنید، رنگ خود را انتخاب کنید و پیشرفتتان را در یک نگاه ببینید.';

  @override
  String get onboardingPrayerTitle => 'اوقات نماز، هر جا که باشید';

  @override
  String get onboardingPrayerBody =>
      'از میان هزاران شهر انتخاب کنید یا مکان دقیق خود را برای اوقات نماز دقیق مشخص کنید.';

  @override
  String get onboardingRemindersTitle => 'یادآورهایی متناسب با روز شما';

  @override
  String get onboardingRemindersBody =>
      'برای هر عادت یادآور روزانه تنظیم کنید و مستقیماً از اعلان بله یا خیر پاسخ دهید.';

  @override
  String get onboardingStatsTitle => 'پیشرفت خود را ببینید';

  @override
  String get onboardingStatsBody =>
      'نمودارها، زنجیره‌ها و نرخ موفقیت به شما کمک می‌کنند انگیزه بمانید و بدانید چه چیزی نیاز به توجه دارد.';

  @override
  String get statisticsOverallSuccess => 'موفقیت کلی';

  @override
  String get statisticsOverallSuccessSubtitle => 'در تمام روزهای ثبت‌شده عادت';

  @override
  String get statisticsBestStreak => 'بهترین زنجیره';

  @override
  String get statisticsTotalHabits => 'عادت‌ها';

  @override
  String get statisticsDailyCompletion => 'تکمیل روزانه';

  @override
  String get statisticsDailyCompletionSubtitle =>
      'تکمیل عادت‌های شما در ۳۰ روز گذشته';

  @override
  String get statisticsWeeklyProgress => 'پیشرفت هفتگی';

  @override
  String get statisticsWeeklyProgressSubtitle =>
      'میانگین تکمیل در چهار هفته گذشته';

  @override
  String get statisticsMonthlyProgress => 'پیشرفت ماهانه';

  @override
  String get statisticsMonthlyProgressSubtitle =>
      'میانگین تکمیل در شش ماه گذشته';

  @override
  String get statisticsBreakdown => 'تفکیک عادت‌ها';

  @override
  String get statisticsBreakdownSubtitle =>
      'روزهای تکمیل‌شده، ازدست‌رفته و ثبت‌نشده در ۳۰ روز گذشته';

  @override
  String get statisticsSuccess => 'تکمیل‌شده';

  @override
  String get statisticsMissed => 'ازدست‌رفته';

  @override
  String get statisticsNoData => 'بدون داده';

  @override
  String get statisticsHabitPerformance => 'عملکرد عادت‌ها';

  @override
  String get statisticsNoDataTitle => 'هنوز داده‌ای نیست';

  @override
  String get statisticsNoDataBody =>
      'برای دیدن نمودارها، زنجیره‌ها و نرخ موفقیت، ثبت عادت‌هایتان را شروع کنید.';
}
