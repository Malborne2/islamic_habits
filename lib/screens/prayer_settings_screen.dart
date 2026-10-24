import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/city_picker_screen.dart';
import 'package:islamic_habits/utility/adhan_voice_i18n.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';
import 'package:islamic_habits/utility/world_cities.dart';

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

class PrayerSettingsScreen extends StatefulWidget {
  const PrayerSettingsScreen({super.key});
  @override
  _PrayerSettingsScreenState createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  late String _cityLabel = PrayerSettings.cityName;
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
  late AdhanVoiceOption _adhanVoice = PrayerSettings.adhanVoice;
  late bool _adhanTakbeerOnly = PrayerSettings.adhanTakbeerOnly;
  bool _isTestPlaying = false;
  late final StreamSubscription<void> _testCompleteSub;

  // Snapshot of the values that only take effect when "Save" is pressed.
  // The reminders switch, Adhan voice, and takbeer toggle save immediately,
  // so they are deliberately not part of this comparison.
  late final String _initialCityLabel;
  late final String _initialLatText;
  late final String _initialLonText;
  late final CalculationMethod _initialMethod;
  late final Madhab _initialMadhab;
  late final int _initialFajr;
  late final int _initialDhuhr;
  late final int _initialAsr;
  late final int _initialMaghrib;
  late final int _initialIsha;

  // Lets the screen pop without tripping the unsaved-changes guard after the
  // user has explicitly saved or discarded.
  bool _allowPop = false;
  bool _exitDialogVisible = false;

  @override
  void initState() {
    super.initState();
    _initialCityLabel = _cityLabel;
    _initialLatText = _latController.text;
    _initialLonText = _lonController.text;
    _initialMethod = _method;
    _initialMadhab = _madhab;
    _initialFajr = _adjustmentValue(_fajrAdj);
    _initialDhuhr = _adjustmentValue(_dhuhrAdj);
    _initialAsr = _adjustmentValue(_asrAdj);
    _initialMaghrib = _adjustmentValue(_maghribAdj);
    _initialIsha = _adjustmentValue(_ishaAdj);
    _testCompleteSub = NotificationService.onTestAdhanComplete.listen((_) {
      if (mounted) setState(() => _isTestPlaying = false);
    });
  }

  int _adjustmentValue(TextEditingController controller) =>
      int.tryParse(controller.text) ?? 0;

  bool get _hasUnsavedChanges =>
      _cityLabel != _initialCityLabel ||
      _latController.text != _initialLatText ||
      _lonController.text != _initialLonText ||
      _method != _initialMethod ||
      _madhab != _initialMadhab ||
      _adjustmentValue(_fajrAdj) != _initialFajr ||
      _adjustmentValue(_dhuhrAdj) != _initialDhuhr ||
      _adjustmentValue(_asrAdj) != _initialAsr ||
      _adjustmentValue(_maghribAdj) != _initialMaghrib ||
      _adjustmentValue(_ishaAdj) != _initialIsha;

  // Pops after the current frame so PopScope sees canPop == true.
  void _exitNow() {
    if (!mounted) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<void> _handleBack() async {
    if (_exitDialogVisible) return;
    if (!_hasUnsavedChanges) {
      _exitNow();
      return;
    }
    final l10n = AppLocalizations.of(context);
    _exitDialogVisible = true;
    final String? action = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.unsavedChangesTitle),
        content: Text(l10n.unsavedChangesMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'cancel'),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'discard'),
            child: Text(l10n.discardChanges),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, 'save'),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    _exitDialogVisible = false;
    if (!mounted) return;
    if (action == 'save') {
      await _save();
    } else if (action == 'discard') {
      _exitNow();
    }
  }

  @override
  void dispose() {
    _latController.dispose();
    _lonController.dispose();
    _fajrAdj.dispose();
    _dhuhrAdj.dispose();
    _asrAdj.dispose();
    _maghribAdj.dispose();
    _ishaAdj.dispose();
    _testCompleteSub.cancel();
    NotificationService.stopTestAdhan();
    super.dispose();
  }

  Future<void> _toggleTestAdhan() async {
    if (_isTestPlaying) {
      await NotificationService.stopTestAdhan();
      if (mounted) setState(() => _isTestPlaying = false);
      return;
    }
    try {
      await NotificationService.playTestAdhan(_adhanVoice);
      if (mounted) setState(() => _isTestPlaying = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).adhanAudioMissing)));
      }
    }
  }

  Future<void> _openCityPicker() async {
    final result = await Navigator.push<Object>(
      context,
      MaterialPageRoute(
        builder: (context) => CityPickerScreen(
          initialLatitude:
              double.tryParse(_latController.text) ?? PrayerSettings.latitude,
          initialLongitude:
              double.tryParse(_lonController.text) ?? PrayerSettings.longitude,
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (result is WorldCity) {
        _cityLabel = localizedCityLabel(context, result);
        _latController.text = result.latitude.toString();
        _lonController.text = result.longitude.toString();
      } else if (result is CustomLocation) {
        _cityLabel = AppLocalizations.of(context).customLocationLabel;
        _latController.text = result.latitude.toString();
        _lonController.text = result.longitude.toString();
      }
    });
  }

  Future<void> _save() async {
    PrayerSettings.cityName = _cityLabel;
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
    if (mounted) _exitNow();
  }

  Future<void> _onRemindersChanged(bool value) async {
    if (value) {
      final granted = await NotificationService.requestPermission();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context).notificationPermissionDenied)));
      }
      // Prompt for exact-alarm access right away too, so reminders are
      // reliable from the start instead of only after the user notices
      // they're late and digs for the button below.
      await NotificationService.requestExactAlarmPermission();
    }
    setState(() => _remindersEnabled = value);
    await PrayerSettings.setRemindersEnabled(value);
    await NotificationService.scheduleTodayReminders();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      // Back with unsaved changes asks whether to save, discard, or cancel.
      // Everything on this screen (city, method, madhab, corrections) only
      // takes effect after Save, so silently losing it was surprising.
      canPop: _allowPop,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                l10n.batteryOptimizationHint,
                style: const TextStyle(fontSize: 11),
              ),
            ),
            TextButton(
              onPressed: NotificationService.requestIgnoreBatteryOptimizations,
              child: Text(l10n.batteryOptimizationButton),
            ),
            TextButton(
              onPressed: () async {
                final granted =
                    await NotificationService.requestExactAlarmPermission();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(granted
                        ? l10n.exactAlarmGranted
                        : l10n.exactAlarmNotGranted)));
              },
              child: Text(l10n.exactAlarmButton),
            ),
            const SizedBox(height: 8),
            Text(l10n.adhanVoiceLabel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              l10n.adhanVoiceHint,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonFormField<AdhanVoiceOption>(
                    initialValue: _adhanVoice,
                    decoration: habitTextFieldDecoration(context),
                    items: kAdhanVoices
                        .map((voice) => DropdownMenuItem(
                              value: voice,
                              child:
                                  Text(localizedAdhanVoiceName(context, voice)),
                            ))
                        .toList(),
                    onChanged: (value) async {
                      if (value == null) return;
                      await NotificationService.stopTestAdhan();
                      setState(() {
                        _adhanVoice = value;
                        _isTestPlaying = false;
                      });
                      await PrayerSettings.setAdhanVoice(value);
                      await NotificationService.scheduleTodayReminders();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: l10n.testAdhanVoice,
                  icon: Icon(_isTestPlaying
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline),
                  onPressed: _toggleTestAdhan,
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.adhanTakbeerOnlyLabel),
              subtitle: Text(l10n.adhanTakbeerOnlyHint),
              value: _adhanTakbeerOnly,
              onChanged: (value) async {
                await NotificationService.stopTestAdhan();
                setState(() {
                  _adhanTakbeerOnly = value;
                  _isTestPlaying = false;
                });
                await PrayerSettings.setAdhanTakbeerOnly(value);
                await NotificationService.scheduleTodayReminders();
              },
            ),
            const Divider(),
            Text(l10n.locationLabel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _openCityPicker,
                child: InputDecorator(
                  decoration: habitTextFieldDecoration(context)
                      .copyWith(labelText: l10n.cityLabel),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.location_on,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_cityLabel,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 4),
              child: Text(
                '${double.tryParse(_latController.text)?.toStringAsFixed(4) ?? _latController.text}, '
                '${double.tryParse(_lonController.text)?.toStringAsFixed(4) ?? _lonController.text}',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6)),
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.calculationMethodLabel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<CalculationMethod>(
              initialValue: _method,
              decoration: habitTextFieldDecoration(context),
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
              decoration: habitTextFieldDecoration(context),
              items: [
                DropdownMenuItem(
                    value: Madhab.shafi, child: Text(l10n.shafiLabel)),
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
                    decoration: habitTextFieldDecoration(context)
                        .copyWith(labelText: l10n.adjFajr),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _dhuhrAdj,
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    decoration: habitTextFieldDecoration(context)
                        .copyWith(labelText: l10n.adjDhuhr),
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
                    decoration: habitTextFieldDecoration(context)
                        .copyWith(labelText: l10n.adjAsr),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _maghribAdj,
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    decoration: habitTextFieldDecoration(context)
                        .copyWith(labelText: l10n.adjMaghrib),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _ishaAdj,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: habitTextFieldDecoration(context)
                  .copyWith(labelText: l10n.adjIsha),
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
      ),
    );
  }
}
