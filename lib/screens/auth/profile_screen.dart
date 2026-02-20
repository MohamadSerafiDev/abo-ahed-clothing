import 'package:abo_abed_clothing/blocs/login/auth_cubit.dart';
import 'package:abo_abed_clothing/blocs/login/auth_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('profile'.tr),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedOut) {
            Get.offAllNamed('/login');
          } else if (state is AuthFailure) {
            AppSnackbar.showError(message: state.error.tr);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingState();
          }
          if (state is AuthFailure) {
            return ErrorState(
              error: state.error,
              onRetry: () => context.read<AuthCubit>().getMe(),
            );
          }
          if (state is AuthUserLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Header
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: AppLightTheme.surfaceGrey,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: AppLightTheme.goldPrimary,
                    ),
                  ).animate().scale(
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),
                  const SizedBox(height: 24),

                  // User Name
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppLightTheme.textHeadline,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 40),

                  // User Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppLightTheme.surfaceGrey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppLightTheme.dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.phone_outlined,
                          'phone_number'.tr,
                          user.phone,
                        ),
                        const Divider(height: 32),
                        _buildInfoRow(
                          Icons.location_on_outlined,
                          'address'.tr,
                          user.address,
                        ),
                        const Divider(height: 32),
                        _buildInfoRow(
                          Icons.badge_outlined,
                          'role'.tr,
                          user.role.tr,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 48),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.read<AuthCubit>().logout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 8),
                          Text(
                            'logout'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            );
          }
          return const LoadingState();
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppLightTheme.goldPrimary.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppLightTheme.goldPrimary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppLightTheme.textBody,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppLightTheme.textHeadline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
