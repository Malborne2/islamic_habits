import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';

String _calculationMethodLabel(AppLocalizations l10n, CalculationMethod method) {
  switch (method) {
    case CalculationMethod.muslim_world_league:
      return l10n.methodMuslimWorldLeague;
    case CalculationMethod.egyptian:
      return l10n.methodEgyptian;
    case CalculationMethod.karachi:
      return l10n.methodKarachi;
    case CalculationMethod.umm_al_qura:
      return l10n.methodUmmAlQura;
    case CalculationMethod.dubai:
      return l10n.methodDubai;
    case CalculationMethod.moon_sighting_committee:
      return l10n.methodMoonSightingCommittee;
    case CalculationMethod.north_america:
      return l10n.methodNorthAmerica;
    case CalculationMethod.kuwait:
      return l10n.methodKuwait;
    case CalculationMethod.qatar:
      return l10n.methodQatar;
    case CalculationMethod.singapore:
      return l10n.methodSingapore;
    case CalculationMethod.turkey:
      return l10n.methodTurkey;
    case CalculationMethod.tehran:
      return l10n.methodTehran;
    case CalculationMethod.other:
      return l10n.methodOther;
  }
}

String _localizedCityName(AppLocalizations l10n, String name) {
  switch (name) {
    case 'Doha':
      return l10n.cityDoha;
    case 'Mecca':
      return l10n.cityMecca;
    case 'Medina':
      return l10n.cityMedina;
    case 'Cairo':
      return l10n.cityCairo;
    case 'Istanbul':
      return l10n.cityIstanbul;
    case 'Jakarta':
      return l10n.cityJakarta;
    case 'Karachi':
      return l10n.cityKarachi;
    case 'London':
      return l10n.cityLondon;
    case 'New York':
      return l10n.cityNewYork;
    default:
      return l10n.cityCustom;
  }
}

class PrayerSettingsScreen extends StatefulWidget {
  const PrayerSettingsScreen({super.key});
  @override
  _PrayerSettingsScreenState createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  late String _cityName = PrayerSettings.cityName;
  late final _latController =
      TextEditingController(text: PrayerSettings.latitude.toString());
  late final _lonController =
      TextEditingController(text: PrayerSettings.longitude.toString());
  late CalculationMethod _method = PrayerSettings.calculationMethod;
  late Madhab _madhab = PrayerSettings.madhab;
  late final _fajrAdj =
      TextEditingController(text: PrayerSettings.adjustments.fajr.toString());
  late final _dhuhrAdj = TextEditingController(
      text: PrayerSettings.adjustments.dhuhr.toString());
  late final _asrAdj =
      TextEditingController(text: PrayerSettings.adjustments.asr.toString());
  late final _maghribAdj = TextEditingController(
      text: PrayerSettings.adjustments.maghrib.toString());
  late final _ishaAdj =
      TextEditingController(text: PrayerSettings.adjustments.isha.toString());
  late bool _remindersEnabled = PrayerSettings.remindersEnabled;
  late AdhanVoice _adhanVoice = PrayerSettings.adhanVoice;

  bool get _isCustomCity =>
      !kPrayerCities.any((c) => c.name == _cityName && c.name != 'Custom');

  @override
  void dispose() {
    _latController.dispose();
    _lonController.dispose();
    _fajrAdj.dispose();
    _dhuhrAdj.dispose();
    _asrAdj.dispose();
    _maghribAdj.dispose();
    _ishaAdj.dispose();
    super.dispose();
  }

  void _onCityChanged(String? name) {
    if (name == null) return;
    setState(() {
      _cityName = name;
      final city = kPrayerCities.firstWhere((c) => c.name == name,
          orElse: () => kPrayerCities.last);
      if (name != 'Custom') {
        _latController.text = city.latitude.toString();
        _lonController.text = city.longitude.toString();
      }
    });
  }

  Future<void> _save() async {
    PrayerSettings.cityName = _cityName;
    PrayerSettings.latitude =
        double.tryParse(_latController.text) ?? PrayerSettings.latitude;
    PrayerSettings.longitude =
        double.tryParse(_lonController.text) ?? PrayerSettings.longitude;
    PrayerSettings.calculationMethod = _method;
    PrayerSettings.madhab = _madhab;
    PrayerSettings.adjustments = PrayerAdjustments(
      fajr: int.tryParse(_fajrAdj.text) ?? 0,
      dhuhr: int.tryParse(_dhuhrAdj.text) ?? 0,
      asr: int.tryParse(_asrAdj.text) ?? 0,
      maghrib: int.tryParse(_maghribAdj.text) ?? 0,
      isha: int.tryParse(_ishaAdj.text) ?? 0,
    );
    await PrayerSettings.save();
    await NotificationService.scheduleTodayReminders();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _onRemindersChanged(bool value) async {
    if (value) {
      final granted = await NotificationService.requestPermission();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context).notificationPermissionDenied)));
      }
    }
    setState(() => _remindersEnabled = value);
    await PrayerSettings.setRemindersEnabled(value);
    await NotificationService.scheduleTodayReminders();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPrayerTimeSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.prayerRemindersLabel),
            subtitle: Text(l10n.prayerRemindersSubtitle),
            value: _remindersEnabled,
            onChanged: _onRemindersChanged,
          ),
          TextButton(
            onPressed: NotificationService.sendTestNotification,
            child: Text(l10n.sendTestReminder),
          ),
          const SizedBox(height: 8),
          Text(l10n.adhanVoiceLabel,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            l10n.adhanVoiceHint,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<AdhanVoice>(
            initialValue: _adhanVoice,
            decoration: kTextFieldDecoration,
            items: [
              DropdownMenuItem(
                  value: AdhanVoice.takbeer, child: Text(l10n.takbeerOnly)),
              DropdownMenuItem(
                  value: AdhanVoice.full, child: Text(l10n.fullAdhan)),
            ],
            onChanged: (value) async {
              if (value == null) return;
              setState(() => _adhanVoice = value);
              await PrayerSettings.setAdhanVoice(value);
              await NotificationService.scheduleTodayReminders();
            },
          ),
          const Divider(),
          Text(l10n.locationLabel,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _isCustomCity ? 'Custom' : _cityName,
            decoration: kTextFieldDecoration.copyWith(labelText: l10n.cityLabel),
            items: kPrayerCities
                .map((c) => DropdownMenuItem(
                    value: c.name, child: Text(_localizedCityName(l10n, c.name))))
                .toList(),
            onChanged: _onCityChanged,
          ),
          if (_isCustomCity) ...[
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _latController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: kTextFieldDecoration.copyWith(
                        labelText: l10n.latitudeLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lonController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: kTextFieldDecoration.copyWith(
                        labelText: l10n.longitudeLabel),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          Text(l10n.calculationMethodLabel,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<CalculationMethod>(
            initialValue: _method,
            decoration: kTextFieldDecoration,
            items: CalculationMethod.values
                .map((m) => DropdownMenuItem(
                    value: m, child: Text(_calculationMethodLabel(l10n, m))))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _method = value);
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.madhabLabel,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<Madhab>(
            initialValue: _madhab,
            decoration: kTextFieldDecoration,
            items: [
              DropdownMenuItem(value: Madhab.shafi, child: Text(l10n.shafiLabel)),
              DropdownMenuItem(
                  value: Madhab.hanafi, child: Text(l10n.hanafiLabel)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _madhab = value);
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.manualCorrectionLabel,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _fajrAdj,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration:
                      kTextFieldDecoration.copyWith(labelText: l10n.adjFajr),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _dhuhrAdj,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration:
                      kTextFieldDecoration.copyWith(labelText: l10n.adjDhuhr),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _asrAdj,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration:
                      kTextFieldDecoration.copyWith(labelText: l10n.adjAsr),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _maghribAdj,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: l10n.adjMaghrib),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ishaAdj,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: kTextFieldDecoration.copyWith(labelText: l10n.adjIsha),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _save,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}
