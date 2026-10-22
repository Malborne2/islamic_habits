// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Kebiasaan Islami';

  @override
  String get navHome => 'Beranda';

  @override
  String get navPrayerTimes => 'Waktu salat';

  @override
  String get navAllHabits => 'Semua kebiasaan';

  @override
  String get navFivePrayers => 'Lima salat';

  @override
  String get navAddHabit => 'Tambah kebiasaan baru';

  @override
  String get editHabitTitle => 'Edit kebiasaan';

  @override
  String get editHabitAction => 'Edit kebiasaan';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsDarkMode => 'Mode gelap';

  @override
  String get settingsStartOfWeek => 'Awal minggu';

  @override
  String get settingsPrayerTimeSettings => 'Pengaturan waktu salat';

  @override
  String get settingsPrayerTimeSettingsSubtitle =>
      'Lokasi, metode perhitungan, dan pengingat salat';

  @override
  String get settingsBackupRestore => 'Cadangkan & Pulihkan';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Ekspor atau pulihkan data kebiasaan Anda';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageSystem => 'Bahasa ponsel';

  @override
  String get todayHabits => 'Kebiasaan hari ini';

  @override
  String todayProgress(int completed, int total) {
    return 'Hari ini: $completed / $total kebiasaan selesai';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return 'Rentetan terpanjang: $daysText · $habitName';
  }

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get setValue => 'Atur';

  @override
  String get exportBackup => 'Ekspor cadangan';

  @override
  String get restoreFromBackup => 'Pulihkan dari cadangan';

  @override
  String get habitName => 'Nama kebiasaan';

  @override
  String get successMetric => 'Ukuran keberhasilan';

  @override
  String get yesNo => 'Ya / Tidak';

  @override
  String get number => 'Angka';

  @override
  String get streakTarget => 'Target rentetan';

  @override
  String get targetStreakDays => 'Target rentetan (hari)';

  @override
  String get schedule => 'Jadwal';

  @override
  String get everyDay => 'Setiap hari';

  @override
  String get certainDaysOfWeek => 'Hari tertentu dalam seminggu';

  @override
  String get timesPerWeek => 'Beberapa kali per minggu';

  @override
  String get color => 'Warna';

  @override
  String get saveHabit => 'Simpan kebiasaan';

  @override
  String get habitFajrPrayer => 'Salat Subuh';

  @override
  String get habitDhuhrPrayer => 'Salat Zuhur';

  @override
  String get habitAsrPrayer => 'Salat Asar';

  @override
  String get habitMaghribPrayer => 'Salat Magrib';

  @override
  String get habitIshaPrayer => 'Salat Isya';

  @override
  String get habitRecitingQuran => 'Membaca Al-Qur\'an';

  @override
  String get todayLabel => 'Hari ini';

  @override
  String get prayerFajr => 'Subuh';

  @override
  String get prayerDhuhr => 'Zuhur';

  @override
  String get prayerAsr => 'Asar';

  @override
  String get prayerMaghrib => 'Magrib';

  @override
  String get prayerIsha => 'Isya';

  @override
  String get notifyMode => 'Beri tahu';

  @override
  String get silentMode => 'Senyap';

  @override
  String get adhanMode => 'Azan';

  @override
  String get weekdayMonday => 'Senin';

  @override
  String get weekdayTuesday => 'Selasa';

  @override
  String get weekdayWednesday => 'Rabu';

  @override
  String get weekdayThursday => 'Kamis';

  @override
  String get weekdayFriday => 'Jumat';

  @override
  String get weekdaySaturday => 'Sabtu';

  @override
  String get weekdaySunday => 'Minggu';

  @override
  String get settingsNumerals => 'Angka';

  @override
  String get numeralsWestern => 'Barat (0, 1, 2…)';

  @override
  String get numeralsEastern => 'Arab Timur (٠, ١, ٢…)';

  @override
  String get unitPages => 'halaman';

  @override
  String get deleteEntryTitle => 'Hapus entri';

  @override
  String get deleteEntryConfirm =>
      'Apakah Anda yakin ingin menghapus entri ini secara permanen?';

  @override
  String get targetAmountLabel => 'Jumlah target';

  @override
  String get unitLabel => 'Satuan';

  @override
  String get timesPerWeekLabel => 'Kali per minggu';

  @override
  String get restoreBackupTitle => 'Pulihkan cadangan';

  @override
  String get restoreBackupConfirm =>
      'Tindakan ini akan mengganti semua kebiasaan yang tersimpan di perangkat ini dengan data dari cadangan yang dipilih. Lanjutkan?';

  @override
  String get restoreAction => 'Pulihkan';

  @override
  String get notificationPermissionDenied => 'Izin notifikasi tidak diberikan';

  @override
  String get prayerRemindersLabel => 'Pengingat salat';

  @override
  String get prayerRemindersSubtitle =>
      '30 menit setelah setiap salat, tanyakan apakah Anda sudah salat';

  @override
  String get sendTestReminder => 'Kirim pengingat uji coba sekarang';

  @override
  String get batteryOptimizationHint =>
      'Jika pengingat masih belum muncul tepat waktu, pengoptimalan baterai ponsel Anda mungkin menunda atau memblokirnya di latar belakang.';

  @override
  String get batteryOptimizationButton =>
      'Kecualikan aplikasi ini dari pengoptimalan baterai';

  @override
  String get exactAlarmButton => 'Izinkan waktu alarm tepat (disarankan)';

  @override
  String get exactAlarmGranted =>
      'Alarm tepat waktu diizinkan — pengingat akan muncul tepat waktu.';

  @override
  String get exactAlarmNotGranted =>
      'Alarm tepat waktu masih belum diizinkan — coba layar pengaturan sistem yang baru saja terbuka.';

  @override
  String get adhanTakbeerOnlyLabel => 'Hanya takbir';

  @override
  String get adhanTakbeerOnlyHint =>
      'Berhenti setelah takbir pembuka alih-alih memutar rekaman lengkap';

  @override
  String get adhanVoiceLabel => 'Suara azan';

  @override
  String get adhanVoiceHint =>
      'Digunakan untuk salat yang diatur ke ikon speaker (azan) di layar waktu salat.';

  @override
  String get takbeerOnly => 'Hanya takbir';

  @override
  String get fullAdhan => 'Azan lengkap';

  @override
  String get testAdhanVoice => 'Uji coba suara ini';

  @override
  String get adhanAudioMissing =>
      'Belum ada berkas audio untuk suara ini — tambahkan di android/app/src/main/res/raw untuk mendengarkannya.';

  @override
  String get locationLabel => 'Lokasi';

  @override
  String get cityLabel => 'Kota';

  @override
  String get latitudeLabel => 'Lintang';

  @override
  String get longitudeLabel => 'Bujur';

  @override
  String get citySearchHint => 'Cari kota';

  @override
  String get cityNotFoundPrompt => 'Tidak menemukan kota Anda?';

  @override
  String get pickOnMap => 'Pilih di peta';

  @override
  String get noCitiesFound => 'Tidak ada kota yang ditemukan';

  @override
  String get mapPickerTitle => 'Pilih lokasi';

  @override
  String get mapPickerInstructions =>
      'Ketuk di mana saja pada peta untuk mengatur lokasi waktu salat Anda';

  @override
  String get useThisLocation => 'Gunakan lokasi ini';

  @override
  String get customLocationLabel => 'Lokasi kustom';

  @override
  String get calculationMethodLabel => 'Metode perhitungan';

  @override
  String get madhabLabel => 'Mazhab (perhitungan Asar)';

  @override
  String get shafiLabel => 'Syafi\'i';

  @override
  String get hanafiLabel => 'Hanafi';

  @override
  String get manualCorrectionLabel => 'Koreksi manual (menit)';

  @override
  String get adjFajr => 'Subuh';

  @override
  String get adjDhuhr => 'Zuhur';

  @override
  String get adjAsr => 'Asar';

  @override
  String get adjMaghrib => 'Magrib';

  @override
  String get adjIsha => 'Isya';

  @override
  String get cityDoha => 'Doha';

  @override
  String get cityMecca => 'Mekah';

  @override
  String get cityMedina => 'Madinah';

  @override
  String get cityCairo => 'Kairo';

  @override
  String get cityIstanbul => 'Istanbul';

  @override
  String get cityJakarta => 'Jakarta';

  @override
  String get cityKarachi => 'Karachi';

  @override
  String get cityLondon => 'London';

  @override
  String get cityNewYork => 'New York';

  @override
  String get cityCustom => 'Kustom';

  @override
  String get notificationPrayerTimeTitle => 'Waktu salat';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return 'Sudah waktunya $prayerName';
  }

  @override
  String get notificationReminderTitle => 'Pengingat salat';

  @override
  String notificationReminderBody(String prayerName) {
    return 'Apakah Anda sudah melaksanakan $prayerName?';
  }

  @override
  String get notificationYes => 'Ya';

  @override
  String get notificationNo => 'Tidak';

  @override
  String get weekdayMonShort => 'Sen';

  @override
  String get weekdayTueShort => 'Sel';

  @override
  String get weekdayWedShort => 'Rab';

  @override
  String get weekdayThuShort => 'Kam';

  @override
  String get weekdayFriShort => 'Jum';

  @override
  String get weekdaySatShort => 'Sab';

  @override
  String get weekdaySunShort => 'Min';

  @override
  String get pickAtLeastOneDay => 'Pilih setidaknya satu hari dalam seminggu';

  @override
  String get setValueTitle => 'Atur nilai';

  @override
  String setUnitTitle(String unit) {
    return 'Atur $unit';
  }

  @override
  String get metricCurrentStreak => 'Rentetan Saat Ini';

  @override
  String get metricStreakTarget => 'Target Rentetan';

  @override
  String get metricMaximumStreak => 'Rentetan Terpanjang';

  @override
  String get metricSuccessPercentage => 'Persentase Keberhasilan';

  @override
  String get metricWeeklyAverage => 'Rata-rata Mingguan';

  @override
  String get metricMonthlyAverage => 'Rata-rata Bulanan';

  @override
  String get backupDescription =>
      'Semua data kebiasaan disimpan secara lokal di perangkat ini. Ekspor berkas cadangan untuk menyimpan salinan atau memindahkannya ke perangkat lain, misalnya dengan membagikannya ke penyimpanan cloud atau email.';

  @override
  String exportFailed(String error) {
    return 'Ekspor gagal: $error';
  }

  @override
  String importFailed(String error) {
    return 'Impor gagal: $error';
  }

  @override
  String restoredCount(int count) {
    return '$count kebiasaan dipulihkan';
  }

  @override
  String get shareBackupText => 'Cadangan Kebiasaan Islami';

  @override
  String get valueAddedSuccess => 'Nilai baru berhasil ditambahkan';

  @override
  String get prayerSunrise => 'Matahari terbit';

  @override
  String get methodMuslimWorldLeague => 'Liga Muslim Dunia';

  @override
  String get methodEgyptian => 'Mesir';

  @override
  String get methodKarachi => 'Karachi';

  @override
  String get methodUmmAlQura => 'Umm al-Qura';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodMoonSightingCommittee => 'Komite Rukyatul Hilal';

  @override
  String get methodNorthAmerica => 'Amerika Utara';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodSingapore => 'Singapura';

  @override
  String get methodTurkey => 'Turki';

  @override
  String get methodTehran => 'Teheran';

  @override
  String get methodOther => 'Lainnya';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari',
    );
    return '$_temp0';
  }

  @override
  String nextPrayerCountdownHm(int hours, int minutes) {
    return 'dalam ${hours}j ${minutes}m';
  }

  @override
  String nextPrayerCountdownM(int minutes) {
    return 'dalam ${minutes}m';
  }
}
