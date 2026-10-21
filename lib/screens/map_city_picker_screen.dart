import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/world_cities.dart';

// Lets the user tap a point on a map to set their prayer-time location by
// hand — used only as a fallback when their city isn't in kWorldCities.
// This never reads the device's actual location; it only fetches map tile
// images over the network for display.
class MapCityPickerScreen extends StatefulWidget {
  final LatLng initialCenter;
  const MapCityPickerScreen({super.key, required this.initialCenter});
  @override
  _MapCityPickerScreenState createState() => _MapCityPickerScreenState();
}

class _MapCityPickerScreenState extends State<MapCityPickerScreen> {
  late LatLng _picked = widget.initialCenter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mapPickerTitle)),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
            padding: const EdgeInsets.all(12),
            child: Text(
              l10n.mapPickerInstructions,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _picked,
                    initialZoom: 4,
                    onTap: (tapPosition, point) =>
                        setState(() => _picked = point),
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'dev.smoothchocolate.islamic_habits',
                    ),
                    MarkerLayer(markers: <Marker>[
                      Marker(
                        point: _picked,
                        width: 44,
                        height: 44,
                        alignment: Alignment.topCenter,
                        child: Icon(Icons.location_on,
                            color: Theme.of(context).colorScheme.primary,
                            size: 44),
                      ),
                    ]),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: Center(
                    child: Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        child: Text(
                          '${_picked.latitude.toStringAsFixed(4)}, '
                          '${_picked.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(
                      context,
                      CustomLocation(_picked.latitude, _picked.longitude)),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(l10n.useThisLocation),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
