import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:eagle_cargo/core/utils/palette.dart';

// The map websites (google.com/maps, yandex.ru/maps) are unreachable on
// some networks here — they either redirect into the blocked native Maps
// app or fail to load their own JS. The raw tile servers below, however,
// are reachable, so we render the map ourselves instead of embedding
// somebody's map site. Verified working from a device on that network;
// tile.openstreetmap.org and CartoCDN are blocked, these two are not.
const _osmFranceTiles = 'https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png';
const _arcgisTiles =
    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}';

class WarehouseMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? title;

  const WarehouseMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    this.title,
  });

  @override
  State<WarehouseMapPage> createState() => _WarehouseMapPageState();
}

class _WarehouseMapPageState extends State<WarehouseMapPage> {
  final _mapController = MapController();

  // Falls back to ArcGIS if the OSM-France tiles fail to load.
  bool _useFallbackTiles = false;

  LatLng get _point => LatLng(widget.latitude, widget.longitude);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? 'Kartada görkez')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _point, initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate: _useFallbackTiles ? _arcgisTiles : _osmFranceTiles,
                subdomains: _useFallbackTiles ? const [] : const ['a', 'b', 'c'],
                userAgentPackageName: 'tm.com.sanlyteklip.eagle',
                errorTileCallback: (tile, error, stackTrace) {
                  if (!_useFallbackTiles && mounted) {
                    setState(() => _useFallbackTiles = true);
                  }
                },
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _point,
                    width: 44,
                    height: 44,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 44,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Zoom controls
          Positioned(
            right: 16,
            bottom: 32,
            child: Column(
              children: [
                _zoomButton(
                  icon: Icons.add,
                  onTap: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                ),
                const SizedBox(height: 8),
                _zoomButton(
                  icon: Icons.remove,
                  onTap: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                ),
                const SizedBox(height: 8),
                _zoomButton(
                  icon: Icons.my_location,
                  onTap: () => _mapController.move(_point, 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _zoomButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Palette.primaryLight),
        ),
      ),
    );
  }
}
