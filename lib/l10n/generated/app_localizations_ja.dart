// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'イスラム習慣';

  @override
  String get navHome => 'ホーム';

  @override
  String get navPrayerTimes => '礼拝時間';

  @override
  String get navAllHabits => 'すべての習慣';

  @override
  String get navFivePrayers => '五行の礼拝';

  @override
  String get navAddHabit => '新しい習慣を追加';

  @override
  String get editHabitTitle => '習慣を編集';

  @override
  String get editHabitAction => '習慣を編集';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsDarkMode => 'ダークモード';

  @override
  String get settingsStartOfWeek => '週の開始日';

  @override
  String get settingsPrayerTimeSettings => '礼拝時間の設定';

  @override
  String get settingsPrayerTimeSettingsSubtitle => '場所、計算方法、礼拝のリマインダー';

  @override
  String get settingsBackupRestore => 'バックアップと復元';

  @override
  String get settingsBackupRestoreSubtitle => '習慣データをエクスポートまたは復元';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => '端末の言語';

  @override
  String get todayHabits => '今日の習慣';

  @override
  String todayProgress(int completed, int total) {
    return '今日: $completed / $total 件完了';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return '最長連続記録: $daysText ・ $habitName';
  }

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get setValue => '設定';

  @override
  String get exportBackup => 'バックアップをエクスポート';

  @override
  String get restoreFromBackup => 'バックアップから復元';

  @override
  String get habitName => '習慣の名前';

  @override
  String get successMetric => '達成基準';

  @override
  String get yesNo => 'はい / いいえ';

  @override
  String get number => '数値';

  @override
  String get streakTarget => '連続目標';

  @override
  String get targetStreakDays => '目標連続日数';

  @override
  String get schedule => 'スケジュール';

  @override
  String get everyDay => '毎日';

  @override
  String get certainDaysOfWeek => '曜日を指定';

  @override
  String get timesPerWeek => '週に複数回';

  @override
  String get color => '色';

  @override
  String get saveHabit => '習慣を保存';

  @override
  String get habitFajrPrayer => 'ファジュルの礼拝';

  @override
  String get habitDhuhrPrayer => 'ズフルの礼拝';

  @override
  String get habitAsrPrayer => 'アスルの礼拝';

  @override
  String get habitMaghribPrayer => 'マグリブの礼拝';

  @override
  String get habitIshaPrayer => 'イシャーの礼拝';

  @override
  String get habitRecitingQuran => 'クルアーンの朗読';

  @override
  String get todayLabel => '今日';

  @override
  String get prayerFajr => 'ファジュル';

  @override
  String get prayerDhuhr => 'ズフル';

  @override
  String get prayerAsr => 'アスル';

  @override
  String get prayerMaghrib => 'マグリブ';

  @override
  String get prayerIsha => 'イシャー';

  @override
  String get notifyMode => '通知';

  @override
  String get silentMode => 'サイレント';

  @override
  String get adhanMode => 'アザーン';

  @override
  String get weekdayMonday => '月曜日';

  @override
  String get weekdayTuesday => '火曜日';

  @override
  String get weekdayWednesday => '水曜日';

  @override
  String get weekdayThursday => '木曜日';

  @override
  String get weekdayFriday => '金曜日';

  @override
  String get weekdaySaturday => '土曜日';

  @override
  String get weekdaySunday => '日曜日';

  @override
  String get settingsNumerals => '数字表記';

  @override
  String get numeralsWestern => '西洋数字 (0, 1, 2…)';

  @override
  String get numeralsEastern => '東アラビア数字 (٠, ١, ٢…)';

  @override
  String get unitPages => 'ページ';

  @override
  String get deleteEntryTitle => '記録を削除';

  @override
  String get deleteEntryConfirm => 'この記録を完全に削除してもよろしいですか?';

  @override
  String get targetAmountLabel => '目標量';

  @override
  String get unitLabel => '単位';

  @override
  String get timesPerWeekLabel => '週あたりの回数';

  @override
  String get restoreBackupTitle => 'バックアップを復元';

  @override
  String get restoreBackupConfirm =>
      'この端末に保存されているすべての習慣が、選択したバックアップの内容に置き換えられます。続けますか?';

  @override
  String get restoreAction => '復元';

  @override
  String get notificationPermissionDenied => '通知の許可が得られませんでした';

  @override
  String get prayerRemindersLabel => '礼拝リマインダー';

  @override
  String get prayerRemindersSubtitle => '各礼拝の30分後に、礼拝をしたか確認します';

  @override
  String get sendTestReminder => '今すぐテスト通知を送信';

  @override
  String get batteryOptimizationHint =>
      'それでもリマインダーが正しい時間に届かない場合、端末のバッテリー最適化がバックグラウンドでの通知を遅延または妨げている可能性があります。';

  @override
  String get batteryOptimizationButton => 'このアプリをバッテリー最適化の対象外にする';

  @override
  String get exactAlarmButton => '正確なアラーム時刻を許可する(推奨)';

  @override
  String get exactAlarmGranted => '正確なアラームが許可されています — リマインダーは時間どおりに届きます。';

  @override
  String get exactAlarmNotGranted =>
      '正確なアラームはまだ許可されていません — 開いたシステム設定画面でお試しください。';

  @override
  String get adhanTakbeerOnlyLabel => 'タクビールのみ';

  @override
  String get adhanTakbeerOnlyHint => '録音全体を再生せず、冒頭のタクビールの後で停止します';

  @override
  String get adhanVoiceLabel => 'アザーンの声';

  @override
  String get adhanVoiceHint => '礼拝時間画面でスピーカーアイコン(アザーン)に設定した礼拝に使用されます。';

  @override
  String get takbeerOnly => 'タクビールのみ';

  @override
  String get fullAdhan => 'フルアザーン';

  @override
  String get testAdhanVoice => 'この声をテスト';

  @override
  String get adhanAudioMissing =>
      'この声の音声ファイルはまだ同梱されていません — android/app/src/main/res/raw に追加すると再生できます。';

  @override
  String get locationLabel => '場所';

  @override
  String get cityLabel => '都市';

  @override
  String get latitudeLabel => '緯度';

  @override
  String get longitudeLabel => '経度';

  @override
  String get citySearchHint => '都市を検索';

  @override
  String get cityNotFoundPrompt => '都市が見つかりませんか?';

  @override
  String get pickOnMap => '地図で選択';

  @override
  String get noCitiesFound => '都市が見つかりません';

  @override
  String get mapPickerTitle => '場所を選択';

  @override
  String get mapPickerInstructions => '地図上の任意の場所をタップして礼拝時間の場所を設定します';

  @override
  String get useThisLocation => 'この場所を使用';

  @override
  String get customLocationLabel => 'カスタムの場所';

  @override
  String get calculationMethodLabel => '計算方法';

  @override
  String get madhabLabel => 'マズハブ (アスルの計算)';

  @override
  String get shafiLabel => 'シャーフィイー派';

  @override
  String get hanafiLabel => 'ハナフィー派';

  @override
  String get manualCorrectionLabel => '手動補正 (分)';

  @override
  String get adjFajr => 'ファジュル';

  @override
  String get adjDhuhr => 'ズフル';

  @override
  String get adjAsr => 'アスル';

  @override
  String get adjMaghrib => 'マグリブ';

  @override
  String get adjIsha => 'イシャー';

  @override
  String get cityDoha => 'ドーハ';

  @override
  String get cityMecca => 'メッカ';

  @override
  String get cityMedina => 'メディナ';

  @override
  String get cityCairo => 'カイロ';

  @override
  String get cityIstanbul => 'イスタンブール';

  @override
  String get cityJakarta => 'ジャカルタ';

  @override
  String get cityKarachi => 'カラチ';

  @override
  String get cityLondon => 'ロンドン';

  @override
  String get cityNewYork => 'ニューヨーク';

  @override
  String get cityCustom => 'カスタム';

  @override
  String get notificationPrayerTimeTitle => '礼拝の時間';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return '$prayerNameの時間です';
  }

  @override
  String get notificationReminderTitle => '礼拝リマインダー';

  @override
  String notificationReminderBody(String prayerName) {
    return '$prayerNameの礼拝をしましたか?';
  }

  @override
  String get notificationYes => 'はい';

  @override
  String get notificationNo => 'いいえ';

  @override
  String get weekdayMonShort => '月';

  @override
  String get weekdayTueShort => '火';

  @override
  String get weekdayWedShort => '水';

  @override
  String get weekdayThuShort => '木';

  @override
  String get weekdayFriShort => '金';

  @override
  String get weekdaySatShort => '土';

  @override
  String get weekdaySunShort => '日';

  @override
  String get pickAtLeastOneDay => '曜日を少なくとも1つ選んでください';

  @override
  String get setValueTitle => '値を設定';

  @override
  String setUnitTitle(String unit) {
    return '$unitを設定';
  }

  @override
  String get metricCurrentStreak => '現在の連続記録';

  @override
  String get metricStreakTarget => '連続目標';

  @override
  String get metricMaximumStreak => '最長連続記録';

  @override
  String get metricSuccessPercentage => '達成率';

  @override
  String get metricWeeklyAverage => '週平均';

  @override
  String get metricMonthlyAverage => '月平均';

  @override
  String get backupDescription =>
      'すべての習慣データはこの端末にローカル保存されています。バックアップファイルをエクスポートして控えを保持するか、クラウドやメールで共有するなどして他の端末に移すことができます。';

  @override
  String exportFailed(String error) {
    return 'エクスポートに失敗しました: $error';
  }

  @override
  String importFailed(String error) {
    return 'インポートに失敗しました: $error';
  }

  @override
  String restoredCount(int count) {
    return '$count件の習慣を復元しました';
  }

  @override
  String get shareBackupText => 'イスラム習慣 バックアップ';

  @override
  String get valueAddedSuccess => '新しい値が正常に追加されました';

  @override
  String get prayerSunrise => '日の出';

  @override
  String get methodMuslimWorldLeague => 'ムスリム世界連盟';

  @override
  String get methodEgyptian => 'エジプト';

  @override
  String get methodKarachi => 'カラチ';

  @override
  String get methodUmmAlQura => 'ウンムルクラー';

  @override
  String get methodDubai => 'ドバイ';

  @override
  String get methodMoonSightingCommittee => '月の目視委員会';

  @override
  String get methodNorthAmerica => '北米';

  @override
  String get methodKuwait => 'クウェート';

  @override
  String get methodQatar => 'カタール';

  @override
  String get methodSingapore => 'シンガポール';

  @override
  String get methodTurkey => 'トルコ';

  @override
  String get methodTehran => 'テヘラン';

  @override
  String get methodOther => 'その他';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日',
    );
    return '$_temp0';
  }

  @override
  String nextPrayerCountdownHm(int hours, int minutes) {
    return 'あと$hours時間$minutes分';
  }

  @override
  String nextPrayerCountdownM(int minutes) {
    return 'あと$minutes分';
  }
}
