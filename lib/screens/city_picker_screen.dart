import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/map_city_picker_screen.dart';
import 'package:islamic_habits/utility/world_cities.dart';

// Returns either a WorldCity or a CustomLocation via Navigator.pop, or null
// if dismissed without choosing one.
class CityPickerScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  const CityPickerScreen(
      {super.key, required this.initialLatitude, required this.initialLongitude});
  @override
  _CityPickerScreenState createState() => _CityPickerScreenState();
}

class _CityPickerScreenState extends State<CityPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WorldCity> _filtered(BuildContext context) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return kWorldCities;
    return kWorldCities
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.country.toLowerCase().contains(q) ||
            localizedCityName(context, c).toLowerCase().contains(q) ||
            localizedCountryName(context, c.country)
                .toLowerCase()
                .contains(q))
        .toList();
  }

  Future<void> _pickOnMap() async {
    final result = await Navigator.push<CustomLocation>(
      context,
      MaterialPageRoute(
        builder: (context) => MapCityPickerScreen(
          initialCenter:
              LatLng(widget.initialLatitude, widget.initialLongitude),
        ),
      ),
    );
    if (result != null && mounted) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final results = _filtered(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cityLabel),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.citySearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _searchController.clear();
                          _query = '';
                        }),
                      ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: _pickOnMap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    child: Icon(Icons.map,
                        color: Theme.of(context).colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(l10n.cityNotFoundPrompt,
                            style: const TextStyle(fontSize: 12)),
                        Text(l10n.pickOnMap,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Text(l10n.noCitiesFound,
                        style: const TextStyle(fontSize: 14)))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final city = results[i];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.15),
                          child: const Icon(Icons.location_city, size: 20),
                        ),
                        title: Text(localizedCityName(context, city),
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle:
                            Text(localizedCountryName(context, city.country)),
                        onTap: () => Navigator.pop(context, city),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
