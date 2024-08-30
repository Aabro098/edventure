import 'package:edventure/Services/map_services.dart';
import 'package:edventure/constants/variable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _pKathmandu = LatLng(27.7172, 85.3240);
  late GoogleMapController _controller;
  LatLng? _currentLocation;
  final Location _locationService = Location();
  bool _isMapReady = false;
  final TextEditingController _searchController = TextEditingController();
  final MapService _mapService = MapService(uri);

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  Future<void> _getLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await _locationService.getLocation();
    setState(() {
      _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });

    if (_isMapReady) {
      _controller.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      final data = await _mapService.searchLocation(query);
      if (data['predictions'] != null && data['predictions'].isNotEmpty) {
        final placeId = data['predictions'][0]['place_id'];
        final detailsData = await _mapService.getPlaceDetails(placeId);
        final location = detailsData['result']['geometry']['location'];

        _controller.animateCamera(CameraUpdate.newLatLng(LatLng(location['lat'], location['lng'])));
        setState(() {
          _currentLocation = LatLng(location['lat'], location['lng']);
        });
      }
    } catch (e) {
      print('Error searching for location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation ?? _pKathmandu,
              zoom: 17,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _isMapReady = true;
              if (_currentLocation != null) {
                _controller.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
              }
            },
            markers: _currentLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentLocation!,
                      infoWindow: const InfoWindow(
                        title: 'Your Location',
                      ),
                    )
                  }
                : {},
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Location',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchLocation(_searchController.text);
                    },
                  ),
                ),
                onSubmitted: (value) {
                  _searchLocation(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
