import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../core/utils/api_service.dart';
import '../../l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  String? _selectedName;
  bool _loading = true;
  bool _searching = false;
  bool _loadingPois = false;
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _nearbyPois = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() => _loading = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = latLng;
        _loading = false;
      });
      _mapController.move(latLng, 16);
      _loadNearbyPois(latLng);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadNearbyPois(LatLng point) async {
    setState(() => _loadingPois = true);
    final pois = await ApiService.nearbyPois(point.latitude, point.longitude);
    if (mounted) {
      setState(() {
        _nearbyPois = pois;
        _loadingPois = false;
      });
    }
  }

  Future<void> _onMapTap(LatLng point) async {
    setState(() {
      _selectedLocation = point;
      _selectedName = null;
      _nearbyPois = [];
    });

    // Fetch nearby POIs and reverse geocode in parallel
    final poiFuture = ApiService.nearbyPois(point.latitude, point.longitude);
    final geocodeFuture = ApiService.reverseGeocode(point.latitude, point.longitude);

    final results = await Future.wait([poiFuture, geocodeFuture]);

    if (mounted) {
      final pois = results[0] as List<Map<String, dynamic>>;
      final geocode = results[1] as Map<String, dynamic>?;
      setState(() {
        _nearbyPois = pois;
        if (pois.isEmpty) {
          _selectedName = geocode?['display_name'] as String?;
        }
      });
    }
  }

  void _selectPoi(Map<String, dynamic> poi) {
    final lat = poi['lat'] as double?;
    final lon = poi['lon'] as double?;
    if (lat == null || lon == null) return;

    final name = ApiService.poiDisplayName(poi);
    final point = LatLng(lat, lon);
    setState(() {
      _selectedLocation = point;
      _selectedName = name;
      _nearbyPois = [];
    });
    _mapController.move(point, 18);
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _searching = true;
      _nearbyPois = [];
    });

    final results = await ApiService.searchPlaces(query);
    if (mounted) {
      setState(() {
        _searchResults = results;
        _searching = false;
      });
    }
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    final lat = double.tryParse(result['lat']?.toString() ?? '');
    final lon = double.tryParse(result['lon']?.toString() ?? '');
    if (lat == null || lon == null) return;

    final point = LatLng(lat, lon);
    setState(() {
      _selectedLocation = point;
      _selectedName = result['display_name'] as String?;
      _searchResults = [];
      _searchController.clear();
    });
    _mapController.move(point, 16);
  }

  void _confirmSelection() {
    if (_selectedLocation == null && _selectedName == null) return;
    final info = ApiService.extractPlaceInfo({
      'display_name': _selectedName ?? '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
    });
    Navigator.pop(context, info);
  }

  IconData _poiIcon(String type) {
    return switch (type) {
      'restaurant' => Icons.restaurant,
      'cafe' => Icons.coffee,
      'bar' || 'pub' => Icons.local_bar,
      'fast_food' => Icons.fastfood,
      'bakery' => Icons.bakery_dining,
      'supermarket' || 'convenience' => Icons.shopping_cart,
      'pharmacy' => Icons.local_pharmacy,
      'hotel' || 'hostel' || 'guest_house' => Icons.hotel,
      'museum' => Icons.museum,
      'cinema' || 'theatre' => Icons.theaters,
      'park' || 'garden' => Icons.park,
      'fuel' || 'charging_station' => Icons.local_gas_station,
      'parking' => Icons.local_parking,
      'gym' || 'fitness_centre' => Icons.fitness_center,
      'hairdresser' || 'beauty' => Icons.content_cut,
      'clothes' || 'shoes' => Icons.checkroom,
      'books' => Icons.menu_book,
      'electronics' => Icons.devices,
      _ => Icons.place,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final center = _currentLocation ?? const LatLng(51.0, 10.0);
    final initialZoom = _currentLocation != null ? 16.0 : 4.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchPlace),
      ),
      body: Stack(
        children: [
          // Map
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: initialZoom,
                onTap: (_, point) => _onMapTap(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'de.langenk.ilike',
                ),
                MarkerLayer(
                  markers: [
                    if (_currentLocation != null)
                      Marker(
                        point: _currentLocation!,
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    if (_selectedLocation != null)
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.place, color: Colors.red, size: 40),
                      ),
                    // Show POI markers
                    for (final poi in _nearbyPois)
                      if (poi['lat'] != null && poi['lon'] != null)
                        Marker(
                          point: LatLng(poi['lat'] as double, poi['lon'] as double),
                          width: 30,
                          height: 30,
                          child: GestureDetector(
                            onTap: () => _selectPoi(poi),
                            child: Icon(
                              _poiIcon(ApiService.poiType(poi)),
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),

          // Search bar
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchEllipsis,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searching
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: _search,
                  ),
                  if (_searchResults.isNotEmpty)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return ListTile(
                            title: Text(
                              result['display_name'] as String? ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            dense: true,
                            onTap: () => _selectSearchResult(result),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom panel: nearby POIs list or selected place
          if (_nearbyPois.isNotEmpty && _selectedName == null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Card(
                margin: const EdgeInsets.all(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_loadingPois)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        )
                      else
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _nearbyPois.length,
                            itemBuilder: (context, index) {
                              final poi = _nearbyPois[index];
                              final name = ApiService.poiDisplayName(poi);
                              final type = ApiService.poiType(poi);
                              return ListTile(
                                leading: Icon(_poiIcon(type)),
                                title: Text(name),
                                subtitle: type.isNotEmpty ? Text(type) : null,
                                dense: true,
                                onTap: () => _selectPoi(poi),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          else if (_selectedName != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _selectedName!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _confirmSelection,
                        icon: const Icon(Icons.check),
                        label: Text(l10n.add),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _loading
          ? null
          : FloatingActionButton.small(
              onPressed: () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 16);
                  _loadNearbyPois(_currentLocation!);
                }
              },
              child: const Icon(Icons.my_location),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
