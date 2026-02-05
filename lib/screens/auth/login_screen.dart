import 'package:abo_abed_clothing/blocs/login/auth_cubit.dart';
import 'package:abo_abed_clothing/blocs/login/auth_state.dart';
import 'package:abo_abed_clothing/core/apis/user/user_api.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/core/utils/validators.dart';
import 'package:abo_abed_clothing/widgets/auth/auth_header.dart';
import 'package:abo_abed_clothing/widgets/global/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginView();
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staggerDelay = 100.ms;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Header / Logo Section
                AuthHeader(isLogin: true),

                Column(
                      children: [
                        CustomInput(
                          label: 'phone_number'.tr,
                          placeholder: '+971 50 000 0000',
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          validator: Validators.validatePhone,
                        ),
                        CustomInput(
                          label: 'password'.tr,
                          placeholder: 'password_placeholder'.tr,
                          isPassword: true,
                          controller: _passwordController,
                          validator: (v) =>
                              Validators.validateRequired(v, 'password'.tr),
                        ),
                      ],
                    )
                    .animate(delay: staggerDelay)
                    .fadeIn(delay: 600.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 32),

                BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          Get.offAllNamed('/home'); // Or dashboard
                        } else if (state is AuthFailure) {
                          Get.snackbar(
                            'Error',
                            state.error,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomGoldElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                      phone: _phoneController.text,
                                      password: _passwordController.text,
                                    );
                                  }
                                },
                          isLoading: state is AuthLoading,
                          child: Text(
                            'login'.tr,
                            style: TextStyles.buttonText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    )
                    .animate(delay: 1100.ms)
                    .fadeIn()
                    .scale(begin: const Offset(0.9, 0.9))
                    .shimmer(
                      blendMode: BlendMode.srcOver,
                      color: const Color.fromARGB(119, 255, 255, 255),
                    ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'no_account'.tr,
                      style: TextStyles.bodyMedium(isDark: false).copyWith(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/create-account');
                      },
                      child: Text(
                        'signup'.tr,
                        style: TextStyles.bodyMedium(isDark: false).copyWith(
                          color: AppLightTheme.goldPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ).animate(delay: 1300.ms).fadeIn(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomGoldElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;

  const CustomGoldElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppLightTheme.goldPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : child,
      ),
    );
  }
}
