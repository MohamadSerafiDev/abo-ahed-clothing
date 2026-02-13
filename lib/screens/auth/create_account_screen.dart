import 'package:abo_abed_clothing/blocs/login/auth_cubit.dart';
import 'package:abo_abed_clothing/blocs/login/auth_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/core/utils/validators.dart';
import 'package:abo_abed_clothing/screens/auth/login_screen.dart';
import 'package:abo_abed_clothing/widgets/auth/auth_header.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:abo_abed_clothing/widgets/global/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateAccountView();
  }
}

class _CreateAccountView extends StatefulWidget {
  const _CreateAccountView();

  @override
  State<_CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<_CreateAccountView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staggerDelay = 100.ms;
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Header / Logo Section
              AuthHeader(isLogin: false),

              // Form Section
              Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInput(
                          label: 'name'.tr,
                          placeholder: 'name_placeholder'.tr,
                          controller: _nameController,
                          validator: (v) =>
                              Validators.validateRequired(v, 'name'.tr),
                        ),
                        CustomInput(
                          label: 'phone_number'.tr,
                          placeholder: '+971 50 000 0000',
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          validator: Validators.validatePhone,
                        ),
                        CustomInput(
                          label: 'address'.tr,
                          placeholder: 'address_placeholder'.tr,
                          icon: FontAwesomeIcons.locationDot,
                          controller: _addressController,
                          validator: (v) =>
                              Validators.validateRequired(v, 'address'.tr),
                        ),
                        CustomInput(
                          label: 'password'.tr,
                          placeholder: 'password_placeholder'.tr,
                          isPassword: true,
                          controller: _passwordController,
                          validator: (v) =>
                              Validators.validateRequired(v, 'password'.tr),
                        ),
                        CustomInput(
                          label: 'confirm_password'.tr,
                          placeholder: 'confirm_password_placeholder'.tr,
                          isPassword: true,
                          controller: _confirmPasswordController,
                          validator: (v) => Validators.validateConfirmPassword(
                            v,
                            _passwordController.text,
                            'confirm_password'.tr,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate(delay: staggerDelay)
                  .fadeIn(delay: 600.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 16),

              // Action Button
              BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Get.offAllNamed('/login');
                      } else if (state is AuthFailure) {
                        AppSnackbar.showError(message: state.error);
                      }
                    },
                    builder: (context, state) {
                      return CustomGoldElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final cubit = context.read<AuthCubit>();
                                  cubit.signup(
                                    name: _nameController.text,
                                    phone: _phoneController.text,
                                    address: _addressController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                        isLoading: state is AuthLoading,
                        child: Text(
                          'register'.tr,
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
                    'already_have_account'.tr,
                    style: TextStyles.bodyMedium(isDark: false).copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/login');
                    },
                    child: Text(
                      'login'.tr,
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
    );
  }
}
