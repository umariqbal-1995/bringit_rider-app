import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final bool embedded;
  const ProfileView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final content = Obx(() {
      if (controller.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: AppColors.primary));
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAvatar(),
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildMenuCard(),
            const SizedBox(height: 24),
            _buildLogoutButton(),
          ],
        ),
      );
    });

    if (embedded) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text('Profile',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: content,
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        Obx(() => CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary,
              child: Text(
                controller.rider.value?.name.isNotEmpty == true
                    ? controller.rider.value!.name[0].toUpperCase()
                    : 'R',
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700),
              ),
            )),
        const SizedBox(height: 12),
        Obx(() => Text(
              controller.rider.value?.name ?? 'Rider',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            )),
        Obx(() => Text(
              controller.rider.value?.phone ?? '',
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary),
            )),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Edit Profile',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          const Text('Full Name',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          TextField(
            controller: controller.nameController,
            decoration: const InputDecoration(hintText: 'Your name'),
          ),
          const SizedBox(height: 16),
          Obx(() => ElevatedButton(
                onPressed: controller.isSaving.value ? null : controller.saveProfile,
                child: controller.isSaving.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Save Changes'),
              )),
        ],
      ),
    );
  }

  Widget _buildMenuCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
          ),
          const Divider(height: 1, color: AppColors.divider, indent: 56),
          _MenuItem(
            icon: Icons.bar_chart_outlined,
            label: 'Earnings',
            onTap: () => Get.toNamed(Routes.EARNINGS),
          ),
          const Divider(height: 1, color: AppColors.divider, indent: 56),
          _MenuItem(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.logout,
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Logout'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      title: Text(label,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
      onTap: onTap,
    );
  }
}
