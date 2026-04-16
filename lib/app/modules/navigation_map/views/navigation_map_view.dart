import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../theme/app_colors.dart';
import '../controllers/navigation_map_controller.dart';

class NavigationMapView extends GetView<NavigationMapController> {
  const NavigationMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text('Fetching route…',
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }
        return Stack(
          children: [
            _buildMap(),
            _buildTopBar(),
            _buildGpsBanner(),
            _buildBottomSheet(),
          ],
        );
      }),
    );
  }

  Widget _buildGpsBanner() {
    return Obx(() {
      if (controller.riderPosition.value != null) return const SizedBox.shrink();
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 68),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text('Getting your location…',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMap() {
    return Obx(() => GoogleMap(
          onMapCreated: controller.onMapCreated,
          initialCameraPosition: CameraPosition(
            target: controller.initialPosition,
            zoom: 14,
          ),
          markers: controller.markers,
          polylines: controller.polylines,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ));
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 8)
                    ],
                  ),
                  child: const Icon(Icons.arrow_back_ios,
                      size: 18, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 8)
                    ],
                  ),
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivering to Customer',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.textPrimary),
                          ),
                          Text(
                            'Order ${controller.order.value?.orderNumber ?? ''}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      )),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 8)
                  ],
                ),
                child: const Icon(Icons.call_outlined,
                    size: 20, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 2)
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Obx(() {
          final order = controller.order.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on,
                        color: Color(0xFF4CAF50), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order?.customerName ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.textPrimary),
                        ),
                        Text(
                          order?.customerAddress ?? '',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. ${order?.earning.toStringAsFixed(0) ?? '0'}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                      Text(
                        '${order?.distance.toStringAsFixed(1) ?? '0'} km',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.call_outlined, size: 16),
                      label: const Text('Call Customer'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.headset_mic_outlined,
                        color: AppColors.grey, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => ElevatedButton.icon(
                    onPressed: controller.isCompleting.value
                        ? null
                        : controller.onArrived,
                    icon: controller.isCompleting.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.location_on, size: 18),
                    label: const Text("I've Arrived"),
                  )),
            ],
          );
        }),
      ),
    );
  }
}
