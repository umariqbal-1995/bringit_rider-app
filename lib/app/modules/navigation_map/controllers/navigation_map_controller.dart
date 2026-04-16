import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/order_model.dart';
import '../../../data/repositories/rider_repository.dart';
import '../../../utils/constants.dart';
import '../../home/controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';

class NavigationMapController extends GetxController {
  final RiderRepository _repo = RiderRepository();

  final order = Rxn<OrderModel>();
  final riderPosition = Rxn<LatLng>();
  final routePoints = <LatLng>[].obs;
  final isLoading = true.obs;
  final isCompleting = false.obs;
  GoogleMapController? mapController;
  Timer? _locationTimer;

  String get orderId => Get.arguments?['orderId'] ?? order.value?.id ?? '';

  LatLng? get destination {
    final o = order.value;
    if (o == null) return null;
    if (o.customerLat != null && o.customerLng != null) {
      return LatLng(o.customerLat!, o.customerLng!);
    }
    return null;
  }

  Set<Polyline> get polylines {
    if (routePoints.isEmpty) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: const Color(0xFF4CAF50),
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  Set<Marker> get markers {
    final result = <Marker>{};
    if (order.value?.storeLat != null && order.value?.storeLng != null) {
      result.add(Marker(
        markerId: const MarkerId('store'),
        position: LatLng(order.value!.storeLat!, order.value!.storeLng!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: order.value!.storeName),
      ));
    }
    if (destination != null) {
      result.add(Marker(
        markerId: const MarkerId('customer'),
        position: destination!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: order.value!.customerName),
      ));
    }
    if (riderPosition.value != null) {
      result.add(Marker(
        markerId: const MarkerId('rider'),
        position: riderPosition.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'You'),
      ));
    }
    return result;
  }

  LatLng get initialPosition {
    if (riderPosition.value != null) return riderPosition.value!;
    if (order.value?.storeLat != null) {
      return LatLng(order.value!.storeLat!, order.value!.storeLng!);
    }
    return const LatLng(24.8607, 67.0011); // Karachi default
  }

  @override
  void onInit() {
    super.onInit();
    order.value = Get.arguments?['order'] as OrderModel?;
    _init();
  }

  Future<void> _init() async {
    isLoading.value = true;
    await _fetchCurrentPosition();
    await _fetchDirections();
    _startLocationTracking();
    isLoading.value = false;
  }

  Future<void> _fetchCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Required',
          'Enable location in Settings to show your position on the map.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
        return;
      }
      if (permission == LocationPermission.denied) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
      );
      riderPosition.value = LatLng(pos.latitude, pos.longitude);
      await _repo.updateLocation(pos.latitude, pos.longitude);
    } catch (_) {}
  }

  Future<void> _fetchDirections() async {
    final origin = riderPosition.value;
    final dest = destination;
    if (origin == null || dest == null) return;

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${dest.latitude},${dest.longitude}'
        '&mode=driving'
        '&key=${ApiConstants.googleMapsApiKey}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final encoded =
              routes[0]['overview_polyline']['points'] as String? ?? '';
          routePoints.value = _decodePolyline(encoded);
        } else {
          // API key invalid or no route found — draw a straight line
          routePoints.value = [origin, dest];
        }
      }
    } catch (_) {
      // If Directions API fails, draw a straight line as fallback
      routePoints.value = [origin, dest];
    }
    _fitMapToBounds();
  }

  void _fitMapToBounds() {
    final points = [
      if (riderPosition.value != null) riderPosition.value!,
      if (destination != null) destination!,
    ];
    if (points.length < 2 || mapController == null) return;

    final sw = LatLng(
      points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
      points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
    );
    final ne = LatLng(
      points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
      points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(LatLngBounds(southwest: sw, northeast: ne), 80),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fitMapToBounds();
  }

  void _startLocationTracking() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest,
        );
        riderPosition.value = LatLng(pos.latitude, pos.longitude);
        await _repo.updateLocation(pos.latitude, pos.longitude);
        await _fetchDirections();
      } catch (_) {}
    });
  }

  Future<void> onArrived() async {
    isCompleting.value = true;
    try {
      await _repo.completeOrder(orderId);
      // Refresh order lists so stale cards are removed immediately
      try { Get.find<OrdersController>().loadOrders(); } catch (_) {}
      try { Get.find<HomeController>().loadOrders(); } catch (_) {}
      Get.back();
      Get.snackbar('Delivery Completed', 'Great job! Order delivered successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    isCompleting.value = false;
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    mapController?.dispose();
    super.onClose();
  }

  /// Decodes a Google Maps encoded polyline string into a list of LatLng points.
  List<LatLng> _decodePolyline(String encoded) {
    final result = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result0 = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result0 |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dLat = (result0 & 1) != 0 ? ~(result0 >> 1) : (result0 >> 1);
      lat += dLat;

      shift = 0;
      result0 = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result0 |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dLng = (result0 & 1) != 0 ? ~(result0 >> 1) : (result0 >> 1);
      lng += dLng;

      result.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return result;
  }
}
