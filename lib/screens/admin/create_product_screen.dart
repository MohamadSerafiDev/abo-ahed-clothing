import 'package:abo_abed_clothing/blocs/product/product_cubit.dart';
import 'package:abo_abed_clothing/blocs/product/product_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:abo_abed_clothing/widgets/global/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController(text: '1');

  String _selectedCondition = 'New';
  String _selectedCategory = 'Men';
  String? _selectedSize;

  static const List<String> _conditions = ['New', 'Used'];
  static const List<String> _categories = [
    'Men',
    'Women',
    'Kids',
    'summer',
    'accessories',
    'shoes',
    'suits',
  ];
  static const List<String> _sizes = [
    'baby',
    'midum',
    'large',
    'x_large',
    'xx_large',
    'xxx_large',
    'xxxx_large',
    'xxxxx_large',
  ];

  // Localized labels for categories
  String _categoryLabel(String cat) {
    switch (cat) {
      case 'Men':
        return 'men'.tr;
      case 'Women':
        return 'women'.tr;
      case 'Kids':
        return 'children'.tr;
      case 'summer':
        return 'summer'.tr;
      case 'accessories':
        return 'accessories'.tr;
      case 'shoes':
        return 'shoes'.tr;
      case 'suits':
        return 'suits'.tr;
      default:
        return cat;
    }
  }

  // Display labels for sizes
  String _sizeLabel(String size) {
    switch (size) {
      case 'baby':
        return 'Baby';
      case 'midum':
        return 'Medium';
      case 'large':
        return 'Large';
      case 'x_large':
        return 'XL';
      case 'xx_large':
        return 'XXL';
      case 'xxx_large':
        return '3XL';
      case 'xxxx_large':
        return '4XL';
      case 'xxxxx_large':
        return '5XL';
      default:
        return size;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('create_product'.tr, style: TextStyles.headlineMedium()),
        backgroundColor: AppLightTheme.backgroundWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppLightTheme.textHeadline,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductActionSuccess) {
            AppSnackbar.showSuccess(message: state.message);
            Navigator.pop(context);
          } else if (state is ProductFailure) {
            AppSnackbar.showError(message: state.error);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                CustomInput(
                  label: 'product_title'.tr,
                  placeholder: 'enter_product_title'.tr,
                  controller: _titleController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'field_required'.tr : null,
                ),

                // Price
                CustomInput(
                  label: 'price'.tr,
                  placeholder: 'enter_price'.tr,
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'field_required'.tr;
                    if (double.tryParse(v) == null) return 'invalid_price'.tr;
                    return null;
                  },
                ),

                // Condition Selector
                _buildSectionLabel('condition'.tr),
                const SizedBox(height: 8),
                Row(
                  children: _conditions.map((condition) {
                    final isSelected = _selectedCondition == condition;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            condition == 'New' ? 'new'.tr : 'used'.tr,
                          ),
                          selected: isSelected,
                          selectedColor: AppLightTheme.goldPrimary,
                          backgroundColor: AppLightTheme.surfaceGrey,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppLightTheme.textBody,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) {
                            setState(() => _selectedCondition = condition);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Category Selector
                _buildSectionLabel('category'.tr),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return ChoiceChip(
                      label: Text(_categoryLabel(category)),
                      selected: isSelected,
                      selectedColor: AppLightTheme.goldPrimary,
                      backgroundColor: AppLightTheme.surfaceGrey,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppLightTheme.textBody,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        setState(() => _selectedCategory = category);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Size Selector
                _buildSectionLabel('size'.tr),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _sizes.map((size) {
                    final isSelected = _selectedSize == size;
                    return ChoiceChip(
                      label: Text(_sizeLabel(size)),
                      selected: isSelected,
                      selectedColor: AppLightTheme.goldPrimary,
                      backgroundColor: AppLightTheme.surfaceGrey,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppLightTheme.textBody,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedSize = isSelected ? null : size;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Description
                CustomInput(
                  label: 'description'.tr,
                  placeholder: 'enter_description'.tr,
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                ),

                // Stock
                CustomInput(
                  label: 'stock'.tr,
                  placeholder: 'enter_stock'.tr,
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'field_required'.tr;
                    if (int.tryParse(v) == null) return 'invalid_stock'.tr;
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Submit Button
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    final isLoading = state is ProductLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppLightTheme.goldPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'create_product'.tr,
                                style: TextStyles.buttonText.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyles.bodyMedium(
        isDark: false,
      ).copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ProductCubit>().createProduct(
      title: _titleController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      condition: _selectedCondition,
      category: _selectedCategory,
      size: _selectedSize,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      stock: int.parse(_stockController.text.trim()),
    );
  }
}
