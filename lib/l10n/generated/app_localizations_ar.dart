// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'العادات الإسلامية';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navPrayerTimes => 'مواقيت الصلاة';

  @override
  String get navAllHabits => 'جميع العادات';

  @override
  String get navFivePrayers => 'الصلوات الخمس';

  @override
  String get navAddHabit => 'إضافة عادة جديدة';

  @override
  String get editHabitTitle => 'تعديل العادة';

  @override
  String get editHabitAction => 'تعديل العادة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get settingsStartOfWeek => 'بداية الأسبوع';

  @override
  String get settingsPrayerTimeSettings => 'إعدادات مواقيت الصلاة';

  @override
  String get settingsPrayerTimeSettingsSubtitle =>
      'الموقع وطريقة الحساب وتذكيرات الصلاة';

  @override
  String get settingsBackupRestore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get settingsBackupRestoreSubtitle => 'تصدير أو استعادة بيانات عاداتك';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageSystem => 'لغة الهاتف';

  @override
  String get todayHabits => 'عادات اليوم';

  @override
  String todayProgress(int completed, int total) {
    return 'اليوم: $completed / $total عادات مكتملة';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return 'أطول سلسلة: $daysText · $habitName';
  }

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get unsavedChangesTitle => 'تغييرات غير محفوظة';

  @override
  String get unsavedChangesMessage =>
      'لديك تغييرات غير محفوظة في إعدادات الصلاة. هل تريد حفظها قبل المغادرة؟';

  @override
  String get discardChanges => 'تجاهل';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get archive => 'أرشفة';

  @override
  String get unarchive => 'استعادة';

  @override
  String get archivedHabits => 'العادات المؤرشفة';

  @override
  String get noArchivedHabits => 'لا توجد عادات مؤرشفة';

  @override
  String get archivedHabitsHint =>
      'تحتفظ العادات المؤرشفة بسجلها ولكنها تختفي من الرئيسية والإحصائيات.';

  @override
  String get habitIcon => 'الأيقونة';

  @override
  String get chooseIcon => 'اختر أيقونة';

  @override
  String get removeIcon => 'إزالة الأيقونة';

  @override
  String get deleteHabitTitle => 'حذف العادة؟';

  @override
  String deleteHabitMessage(String name) {
    return 'سيتم حذف \"$name\" وكل سجلها نهائيًا. لا يمكن التراجع عن ذلك.';
  }

  @override
  String get habitDeleted => 'تم حذف العادة';

  @override
  String get habitArchived => 'تمت أرشفة العادة';

  @override
  String get habitRestored => 'تمت استعادة العادة';

  @override
  String get setValue => 'تعيين';

  @override
  String get exportBackup => 'تصدير نسخة احتياطية';

  @override
  String get restoreFromBackup => 'استعادة من نسخة احتياطية';

  @override
  String get habitName => 'اسم العادة';

  @override
  String get successMetric => 'مقياس النجاح';

  @override
  String get yesNo => 'نعم / لا';

  @override
  String get number => 'رقم';

  @override
  String get streakTarget => 'هدف التسلسل';

  @override
  String get targetStreakDays => 'هدف التسلسل (أيام)';

  @override
  String get schedule => 'الجدول الزمني';

  @override
  String get everyDay => 'كل يوم';

  @override
  String get certainDaysOfWeek => 'أيام معينة من الأسبوع';

  @override
  String get timesPerWeek => 'عدد مرات في الأسبوع';

  @override
  String get color => 'اللون';

  @override
  String get saveHabit => 'حفظ العادة';

  @override
  String get habitFajrPrayer => 'صلاة الفجر';

  @override
  String get habitDhuhrPrayer => 'صلاة الظهر';

  @override
  String get habitAsrPrayer => 'صلاة العصر';

  @override
  String get habitMaghribPrayer => 'صلاة المغرب';

  @override
  String get habitIshaPrayer => 'صلاة العشاء';

  @override
  String get habitRecitingQuran => 'قراءة القرآن';

  @override
  String get todayLabel => 'اليوم';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get notifyMode => 'تنبيه';

  @override
  String get silentMode => 'صامت';

  @override
  String get adhanMode => 'أذان';

  @override
  String get weekdayMonday => 'الإثنين';

  @override
  String get weekdayTuesday => 'الثلاثاء';

  @override
  String get weekdayWednesday => 'الأربعاء';

  @override
  String get weekdayThursday => 'الخميس';

  @override
  String get weekdayFriday => 'الجمعة';

  @override
  String get weekdaySaturday => 'السبت';

  @override
  String get weekdaySunday => 'الأحد';

  @override
  String get settingsNumerals => 'الأرقام';

  @override
  String get numeralsWestern => 'أرقام غربية (0, 1, 2…)';

  @override
  String get numeralsEastern => 'أرقام هندية (٠, ١, ٢…)';

  @override
  String get unitPages => 'صفحات';

  @override
  String get deleteEntryTitle => 'حذف الإدخال';

  @override
  String get deleteEntryConfirm =>
      'هل أنت متأكد أنك تريد حذف هذا الإدخال نهائيًا؟';

  @override
  String get targetAmountLabel => 'القيمة المستهدفة';

  @override
  String get unitLabel => 'الوحدة';

  @override
  String get timesPerWeekLabel => 'عدد المرات في الأسبوع';

  @override
  String get restoreBackupTitle => 'استعادة النسخة الاحتياطية';

  @override
  String get restoreBackupConfirm =>
      'سيؤدي هذا إلى استبدال جميع العادات المخزنة حاليًا على هذا الجهاز بتلك الموجودة في النسخة الاحتياطية المحددة. هل تريد المتابعة؟';

  @override
  String get restoreAction => 'استعادة';

  @override
  String get notificationPermissionDenied => 'لم يتم منح إذن الإشعارات';

  @override
  String get prayerRemindersLabel => 'تذكيرات الصلاة';

  @override
  String get prayerRemindersSubtitle =>
      'بعد 30 دقيقة من كل صلاة، اسأل عما إذا كنت قد صليت';

  @override
  String get sendTestReminder => 'إرسال تذكير تجريبي الآن';

  @override
  String get batteryOptimizationHint =>
      'إذا كانت التذكيرات لا تصل في الوقت المحدد، فقد يكون تحسين البطارية في هاتفك يؤخرها أو يمنعها في الخلفية.';

  @override
  String get batteryOptimizationButton =>
      'استثناء هذا التطبيق من تحسين البطارية';

  @override
  String get exactAlarmButton => 'السماح بأوقات تنبيه دقيقة (موصى به)';

  @override
  String get exactAlarmGranted =>
      'التنبيهات الدقيقة مسموح بها — ستصل التذكيرات في وقتها.';

  @override
  String get exactAlarmNotGranted =>
      'التنبيهات الدقيقة لا تزال غير مسموح بها — جرّب شاشة إعدادات النظام التي فُتحت للتو.';

  @override
  String get adhanTakbeerOnlyLabel => 'التكبير فقط';

  @override
  String get adhanTakbeerOnlyHint =>
      'التوقف بعد التكبير الافتتاحي بدلاً من تشغيل التسجيل كاملاً';

  @override
  String get adhanVoiceLabel => 'صوت الأذان';

  @override
  String get adhanVoiceHint =>
      'يُستخدم للصلوات المضبوطة على أيقونة مكبر الصوت (الأذان) في شاشة مواقيت الصلاة.';

  @override
  String get takbeerOnly => 'التكبير فقط';

  @override
  String get fullAdhan => 'الأذان كاملاً';

  @override
  String get testAdhanVoice => 'تجربة هذا الصوت';

  @override
  String get adhanAudioMissing =>
      'لا يوجد ملف صوتي لهذا الصوت بعد — أضفه ضمن android/app/src/main/res/raw لسماعه.';

  @override
  String get locationLabel => 'الموقع';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get latitudeLabel => 'خط العرض';

  @override
  String get longitudeLabel => 'خط الطول';

  @override
  String get citySearchHint => 'ابحث عن مدينة';

  @override
  String get cityNotFoundPrompt => 'لم تجد مدينتك؟';

  @override
  String get pickOnMap => 'اختر من الخريطة';

  @override
  String get noCitiesFound => 'لم يتم العثور على مدن';

  @override
  String get mapPickerTitle => 'اختر موقعًا';

  @override
  String get mapPickerInstructions =>
      'اضغط في أي مكان على الخريطة لتحديد موقعك لحساب مواقيت الصلاة';

  @override
  String get useThisLocation => 'استخدم هذا الموقع';

  @override
  String get customLocationLabel => 'موقع مخصص';

  @override
  String get calculationMethodLabel => 'طريقة الحساب';

  @override
  String get madhabLabel => 'المذهب (حساب العصر)';

  @override
  String get shafiLabel => 'شافعي';

  @override
  String get hanafiLabel => 'حنفي';

  @override
  String get manualCorrectionLabel => 'التصحيح اليدوي (بالدقائق)';

  @override
  String get adjFajr => 'الفجر';

  @override
  String get adjDhuhr => 'الظهر';

  @override
  String get adjAsr => 'العصر';

  @override
  String get adjMaghrib => 'المغرب';

  @override
  String get adjIsha => 'العشاء';

  @override
  String get cityDoha => 'الدوحة';

  @override
  String get cityMecca => 'مكة المكرمة';

  @override
  String get cityMedina => 'المدينة المنورة';

  @override
  String get cityCairo => 'القاهرة';

  @override
  String get cityIstanbul => 'إسطنبول';

  @override
  String get cityJakarta => 'جاكرتا';

  @override
  String get cityKarachi => 'كراتشي';

  @override
  String get cityLondon => 'لندن';

  @override
  String get cityNewYork => 'نيويورك';

  @override
  String get cityCustom => 'مخصص';

  @override
  String get notificationPrayerTimeTitle => 'وقت الصلاة';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return 'حان وقت $prayerName';
  }

  @override
  String get notificationReminderTitle => 'تذكير بالصلاة';

  @override
  String notificationReminderBody(String prayerName) {
    return 'هل صليت $prayerName؟';
  }

  @override
  String get notificationYes => 'نعم';

  @override
  String get notificationNo => 'لا';

  @override
  String get weekdayMonShort => 'إث';

  @override
  String get weekdayTueShort => 'ثل';

  @override
  String get weekdayWedShort => 'أر';

  @override
  String get weekdayThuShort => 'خم';

  @override
  String get weekdayFriShort => 'جم';

  @override
  String get weekdaySatShort => 'سب';

  @override
  String get weekdaySunShort => 'أح';

  @override
  String get pickAtLeastOneDay => 'اختر يومًا واحدًا على الأقل من أيام الأسبوع';

  @override
  String get setValueTitle => 'تعيين القيمة';

  @override
  String setUnitTitle(String unit) {
    return 'تعيين $unit';
  }

  @override
  String get metricCurrentStreak => 'السلسلة الحالية';

  @override
  String get metricStreakTarget => 'هدف السلسلة';

  @override
  String get metricMaximumStreak => 'أطول سلسلة';

  @override
  String get metricSuccessPercentage => 'نسبة النجاح';

  @override
  String get metricWeeklyAverage => 'المعدل الأسبوعي';

  @override
  String get metricMonthlyAverage => 'المعدل الشهري';

  @override
  String get backupDescription =>
      'يتم تخزين جميع بيانات العادات محليًا على هذا الجهاز. قم بتصدير ملف نسخة احتياطية للاحتفاظ بنسخة أو نقلها إلى جهاز آخر، على سبيل المثال عن طريق مشاركتها عبر محرك أقراص سحابي أو البريد الإلكتروني.';

  @override
  String exportFailed(String error) {
    return 'فشل التصدير: $error';
  }

  @override
  String importFailed(String error) {
    return 'فشل الاستيراد: $error';
  }

  @override
  String restoredCount(int count) {
    return 'تمت استعادة $count عادة';
  }

  @override
  String get shareBackupText => 'نسخة احتياطية من العادات الإسلامية';

  @override
  String get valueAddedSuccess => 'تمت إضافة القيمة الجديدة بنجاح';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get methodMuslimWorldLeague => 'رابطة العالم الإسلامي';

  @override
  String get methodEgyptian => 'الهيئة المصرية العامة للمساحة';

  @override
  String get methodKarachi => 'جامعة كراتشي';

  @override
  String get methodUmmAlQura => 'أم القرى';

  @override
  String get methodDubai => 'دبي';

  @override
  String get methodMoonSightingCommittee => 'لجنة رؤية الهلال';

  @override
  String get methodNorthAmerica => 'أمريكا الشمالية';

  @override
  String get methodKuwait => 'الكويت';

  @override
  String get methodQatar => 'قطر';

  @override
  String get methodSingapore => 'سنغافورة';

  @override
  String get methodTurkey => 'تركيا';

  @override
  String get methodTehran => 'طهران';

  @override
  String get methodOther => 'أخرى';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم',
      many: '$count يومًا',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: '0 يوم',
    );
    return '$_temp0';
  }

  @override
  String nextPrayerCountdownHm(int hours, int minutes) {
    return 'خلال $hours س $minutes د';
  }

  @override
  String nextPrayerCountdownM(int minutes) {
    return 'خلال $minutes د';
  }

  @override
  String get customColor => 'لون مخصص';

  @override
  String get selectColor => 'اختيار';

  @override
  String get navStatistics => 'الإحصائيات';

  @override
  String get reminderLabel => 'التذكير';

  @override
  String get reminderEnabledLabel => 'تذكير العادة';

  @override
  String get reminderEnabledSubtitle =>
      'احصل على إشعار في الوقت الذي تختاره في أيام العادة المحددة';

  @override
  String get reminderTimeLabel => 'وقت التذكير';

  @override
  String get reminderIndependentHint =>
      'هذا التذكير منفصل عن تذكيرات الصلاة ويعمل حتى عندما تكون تذكيرات الصلاة متوقفة.';

  @override
  String reminderDailyAt(String time) {
    return 'في $time';
  }

  @override
  String get reminderOff => 'متوقف';

  @override
  String get notificationHabitReminderTitle => 'تذكير بعادة';

  @override
  String notificationHabitReminderBody(String habitName) {
    return 'حان وقت $habitName';
  }

  @override
  String get enterName => 'أدخل اسمًا';

  @override
  String get enterNumberGreaterThanZero => 'أدخل رقمًا أكبر من 0';

  @override
  String get enterNumberOneToSeven => 'أدخل رقمًا من 1 إلى 7';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingWelcomeTitle => 'مرحبًا بك في Islamic Habits';

  @override
  String get onboardingWelcomeBody =>
      'ابنِ روتينًا منتظمًا حول الصلاة والقرآن والعادات التي تهمك.';

  @override
  String get onboardingHabitsTitle => 'نقرة واحدة يوميًا';

  @override
  String get onboardingHabitsBody =>
      'تابع العادات بنعم/لا أو بالأرقام، واختر ألوانك، وشاهد تقدمك بلمحة.';

  @override
  String get onboardingPrayerTitle => 'أوقات الصلاة أينما كنت';

  @override
  String get onboardingPrayerBody =>
      'اختر من آلاف المدن أو حدد موقعك بدقة للحصول على أوقات صلاة دقيقة.';

  @override
  String get onboardingRemindersTitle => 'تذكيرات تناسب يومك';

  @override
  String get onboardingRemindersBody =>
      'اضبط تذكيرًا يوميًا لأي عادة وأجب بنعم أو لا مباشرة من الإشعار.';

  @override
  String get onboardingStatsTitle => 'شاهد تقدمك';

  @override
  String get onboardingStatsBody =>
      'تساعدك الرسوم البيانية والسلاسل ونسب النجاح على البقاء متحفزًا ومعرفة ما يحتاج إلى انتباه.';

  @override
  String get statisticsOverallSuccess => 'النجاح الإجمالي';

  @override
  String get statisticsOverallSuccessSubtitle =>
      'عبر جميع أيام العادات المسجلة';

  @override
  String get statisticsBestStreak => 'أفضل سلسلة';

  @override
  String get statisticsTotalHabits => 'العادات';

  @override
  String get statisticsDailyCompletion => 'الإنجاز اليومي';

  @override
  String get statisticsDailyCompletionSubtitle =>
      'إنجاز عاداتك خلال آخر 30 يومًا';

  @override
  String get statisticsWeeklyProgress => 'التقدم الأسبوعي';

  @override
  String get statisticsWeeklyProgressSubtitle =>
      'متوسط الإنجاز خلال الأسابيع الأربعة الماضية';

  @override
  String get statisticsMonthlyProgress => 'التقدم الشهري';

  @override
  String get statisticsMonthlyProgressSubtitle =>
      'متوسط الإنجاز خلال الأشهر الستة الماضية';

  @override
  String get statisticsBreakdown => 'تفصيل العادات';

  @override
  String get statisticsBreakdownSubtitle =>
      'أيام العادات المكتملة والفائتة وغير المسجلة خلال آخر 30 يومًا';

  @override
  String get statisticsSuccess => 'مكتمل';

  @override
  String get statisticsMissed => 'فائت';

  @override
  String get statisticsNoData => 'لا توجد بيانات';

  @override
  String get statisticsHabitPerformance => 'أداء العادات';

  @override
  String get statisticsNoDataTitle => 'لا توجد بيانات بعد';

  @override
  String get statisticsNoDataBody =>
      'ابدأ بتسجيل عاداتك لترى الرسوم البيانية والسلاسل ونسب النجاح هنا.';
}
