import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Widgets/user_details.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

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
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
    }

    if (_isMapReady && _currentLocation != null) {
      _controller.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: TAppColor.getRandomColor(),
              child: SizedBox.expand(
                child: UserDetails(user: user)
              )
            ),
          ),
          Expanded(
            flex: 2,
            child: GoogleMap(
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
          ),
        ],
      ),
    );
  }
}
