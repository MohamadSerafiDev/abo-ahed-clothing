import 'package:abo_abed_clothing/blocs/create_account/create_account_cubit.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/widgets/global/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateAccountCubit(),
      child: const _CreateAccountView(),
    );
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Header / Logo Section
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppLightTheme.backgroundWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppLightTheme.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber[100]!),
                    ),
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.gem, // Approximating DiamondIcon
                        color: AppLightTheme.goldPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'أبو عهد',
                style: TextStyles.headlineMedium(isDark: false).copyWith(
                  color: AppLightTheme.goldPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'إنشاء حساب',
                style: TextStyles.displayLarge(isDark: false).copyWith(
                  color: AppLightTheme.textHeadline,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'انضم إلى السوق المتميز للأزياء الحصرية',
                style: TextStyles.bodyLarge(isDark: false).copyWith(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // Form Section
              CustomInput(
                label: 'الاسم',
                placeholder: 'محمد أحمد',
                controller: _nameController,
              ),
              CustomInput(
                label: 'رقم الهاتف',
                placeholder: '+971 50 000 0000',
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
              CustomInput(
                label: 'العنوان',
                placeholder: 'الشارع، المدينة، الدولة',
                icon: FontAwesomeIcons.locationDot,
                controller: _addressController,
              ),
              CustomInput(
                label: 'كلمة المرور',
                placeholder: '••••••••',
                isPassword: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 16),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    final cubit = context.read<CreateAccountCubit>();
                    cubit.createAccount(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      address: _addressController.text,
                      password: _passwordController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppLightTheme.goldPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'تسجيل',
                    style: TextStyles.buttonText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Footer Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لديك حساب بالفعل؟ ',
                    style: TextStyles.bodyMedium(isDark: false).copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/login'); // Assuming login route exists
                    },
                    child: Text(
                      'تسجيل الدخول',
                      style: TextStyles.bodyMedium(isDark: false).copyWith(
                        color: AppLightTheme.goldPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'من خلال إنشاء حساب، فإنك توافق على\nشروط الخدمة و سياسة الخصوصية في أبو عهد',
                textAlign: TextAlign.center,
                style: TextStyles.labelGold.copyWith(
                  fontSize: 12,
                  color: Colors.grey[400],
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
