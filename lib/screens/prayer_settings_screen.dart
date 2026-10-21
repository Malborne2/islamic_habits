import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';

String _calculationMethodLabel(CalculationMethod method) {
  return method.name
      .split('_')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Notification permission was not granted')));
      }
    }
    setState(() => _remindersEnabled = value);
    await PrayerSettings.setRemindersEnabled(value);
    await NotificationService.scheduleTodayReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer time settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Prayer reminders'),
            subtitle: const Text(
                '30 minutes after each prayer, ask whether you prayed'),
            value: _remindersEnabled,
            onChanged: _onRemindersChanged,
          ),
          TextButton(
            onPressed: NotificationService.sendTestNotification,
            child: const Text('Send a test reminder now'),
          ),
          const SizedBox(height: 8),
          const Text('Adhan voice', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text(
            'Used for prayers set to the microphone (adhan) bell icon on '
            'the Prayer times screen.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<AdhanVoice>(
            initialValue: _adhanVoice,
            decoration: kTextFieldDecoration,
            items: const [
              DropdownMenuItem(
                  value: AdhanVoice.takbeer, child: Text('Takbeer only')),
              DropdownMenuItem(
                  value: AdhanVoice.full, child: Text('Full Adhan')),
            ],
            onChanged: (value) async {
              if (value == null) return;
              setState(() => _adhanVoice = value);
              await PrayerSettings.setAdhanVoice(value);
              await NotificationService.scheduleTodayReminders();
            },
          ),
          const Divider(),
          const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _isCustomCity ? 'Custom' : _cityName,
            decoration: kTextFieldDecoration.copyWith(labelText: 'City'),
            items: kPrayerCities
                .map((c) =>
                    DropdownMenuItem(value: c.name, child: Text(c.name)))
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
                    decoration:
                        kTextFieldDecoration.copyWith(labelText: 'Latitude'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lonController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration:
                        kTextFieldDecoration.copyWith(labelText: 'Longitude'),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          const Text('Calculation method',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<CalculationMethod>(
            initialValue: _method,
            decoration: kTextFieldDecoration,
            items: CalculationMethod.values
                .map((m) => DropdownMenuItem(
                    value: m, child: Text(_calculationMethodLabel(m))))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _method = value);
            },
          ),
          const SizedBox(height: 24),
          const Text('Madhab (Asr calculation)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<Madhab>(
            initialValue: _madhab,
            decoration: kTextFieldDecoration,
            items: const [
              DropdownMenuItem(value: Madhab.shafi, child: Text('Shafi')),
              DropdownMenuItem(value: Madhab.hanafi, child: Text('Hanafi')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _madhab = value);
            },
          ),
          const SizedBox(height: 24),
          const Text('Manual correction (minutes)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _fajrAdj,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration: kTextFieldDecoration.copyWith(labelText: 'Fajr'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _dhuhrAdj,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration:
                      kTextFieldDecoration.copyWith(labelText: 'Dhuhr'),
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
                  decoration: kTextFieldDecoration.copyWith(labelText: 'Asr'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _maghribAdj,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration:
                      kTextFieldDecoration.copyWith(labelText: 'Maghrib'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ishaAdj,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: kTextFieldDecoration.copyWith(labelText: 'Isha'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _save,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
