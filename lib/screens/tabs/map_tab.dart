import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/recycling_point.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  // 添加搜索半径参数（单位：米）
  final double searchRadius = 6000;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      // 获取并添加附近回收站标记
      await _searchNearbyRecyclingPoints();

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchNearbyRecyclingPoints() async {
    if (_currentPosition == null) return;

    setState(() {
      _markers.clear();
    });

    try {
      final recyclingPoints = await _searchPlaces(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      setState(() {
        for (var point in recyclingPoints) {
          _markers.add(
            Marker(
              markerId: MarkerId(point.id),
              position: LatLng(point.latitude, point.longitude),
              infoWindow: InfoWindow(
                title: point.name,
                snippet: '${point.address}\n${point.openingHours ?? ""}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ),
          );
        }
      });

      if (recyclingPoints.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No recycling points found nearby')),
        );
      }
    } catch (e) {
      print('Error searching nearby recycling points: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load recycling points')),
      );
    }
  }

  Future<List<RecyclingPoint>> _searchPlaces(double lat, double lng) async {
    // 生成 5 个随机回收站
    final random = math.Random();
    final List<RecyclingPoint> randomPoints = [];
    
    for (int i = 1; i <= 5; i++) {
      // 在当前位置周围随机生成坐标 (范围约 ±2km)
      final randomLat = lat + (random.nextDouble() - 0.5) * 0.02;
      final randomLng = lng + (random.nextDouble() - 0.5) * 0.02;
      
      randomPoints.add(
        RecyclingPoint(
          id: 'random_$i',
          name: 'Recycling Center $i',
          address: '${(random.nextInt(200) + 1)} Random Street',
          latitude: randomLat,
          longitude: randomLng,
          type: 'Recycling Center',
          openingHours: random.nextBool() ? 'Open now' : 'Closed',
        ),
      );
    }
    
    return randomPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Center'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition?.latitude ?? 31.2304,
                  _currentPosition?.longitude ?? 121.4737,
                ),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
    );
  }
}