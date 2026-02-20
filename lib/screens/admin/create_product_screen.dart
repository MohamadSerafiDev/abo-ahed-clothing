import 'dart:io';

import 'package:abo_abed_clothing/blocs/product/product_cubit.dart';
import 'package:abo_abed_clothing/blocs/product/product_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:abo_abed_clothing/widgets/global/chip_selector.dart';
import 'package:abo_abed_clothing/widgets/global/custom_input.dart';
import 'package:abo_abed_clothing/widgets/global/image_picker_grid.dart';
import 'package:abo_abed_clothing/widgets/global/section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CreateProductScreen extends StatefulWidget {
  final ProductModel? initialProduct;

  const CreateProductScreen({super.key, this.initialProduct});

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
  List<File> _selectedImages = [];

  // ── Data ──

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

  // ── Label Maps ──

  static const _categoryLabels = {
    'Men': 'men',
    'Women': 'women',
    'Kids': 'kids',
    'summer': 'summer',
    'accessories': 'accessories',
    'shoes': 'shoes',
    'suits': 'suits',
  };

  static const _conditionLabels = {'New': 'new', 'Used': 'used'};

  static const _sizeLabels = {
    'baby': 'Baby',
    'midum': 'Medium',
    'large': 'Large',
    'x_large': 'XL',
    'xx_large': 'XXL',
    'xxx_large': '3XL',
    'xxxx_large': '4XL',
    'xxxxx_large': '5XL',
  };

  bool get _isEditMode => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    final product = widget.initialProduct;
    if (product != null) {
      _titleController.text = product.title;
      _priceController.text = product.price.toString();
      _descriptionController.text = product.description ?? '';
      _stockController.text = product.stock.toString();
      _selectedCondition = _conditions.contains(product.condition)
          ? product.condition
          : _selectedCondition;
      _selectedCategory = _categories.contains(product.category)
          ? product.category
          : _selectedCategory;
      _selectedSize = product.size;
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

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      appBar: AppBar(
        title: Text(
          (_isEditMode ? 'update_product' : 'create_product').tr,
          style: TextStyles.headlineMedium(),
        ),
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
            AppSnackbar.showSuccess(message: state.message.tr);
            Navigator.pop(context);
          } else if (state is ProductFailure) {
            AppSnackbar.showError(message: state.error.tr);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !_isEditMode
                    ?
                      // ── Media ──
                      Column(
                        children: [
                          SectionLabel(label: 'product_media'.tr),
                          const SizedBox(height: 8),
                          ImagePickerGrid(
                            files: _selectedImages,
                            onChanged: (files) =>
                                setState(() => _selectedImages = files),
                          ),
                          const SizedBox(height: 24),
                        ],
                      )
                    : const SizedBox(),

                // ── Title ──
                CustomInput(
                  label: 'product_title'.tr,
                  placeholder: 'enter_product_title'.tr,
                  controller: _titleController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'field_required'.tr : null,
                ),

                // ── Price ──
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

                // ── Condition ──
                SectionLabel(label: 'condition'.tr),
                const SizedBox(height: 8),
                ChipSelector(
                  options: _conditions,
                  selected: _selectedCondition,
                  labelBuilder: (o) => (_conditionLabels[o] ?? o).tr,
                  onSelected: (v) => setState(
                    () => _selectedCondition = v ?? _selectedCondition,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Category ──
                SectionLabel(label: 'category'.tr),
                const SizedBox(height: 8),
                ChipSelector(
                  options: _categories,
                  selected: _selectedCategory,
                  labelBuilder: (o) => (_categoryLabels[o] ?? o).tr,
                  onSelected: (v) => setState(
                    () => _selectedCategory = v ?? _selectedCategory,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Size ──
                SectionLabel(label: 'size'.tr),
                const SizedBox(height: 8),
                ChipSelector(
                  options: _sizes,
                  selected: _selectedSize,
                  allowDeselect: true,
                  labelBuilder: (o) => _sizeLabels[o] ?? o,
                  onSelected: (v) => setState(() => _selectedSize = v),
                ),
                const SizedBox(height: 24),

                // ── Description ──
                CustomInput(
                  label: 'description'.tr,
                  placeholder: 'enter_description'.tr,
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                ),

                // ── Stock ──
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

                // ── Submit ──
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
                                (_isEditMode
                                        ? 'update_product'
                                        : 'create_product')
                                    .tr,
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

  // ── Submit ──

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();
    final stock = int.parse(_stockController.text.trim());

    if (_isEditMode) {
      context.read<ProductCubit>().updateProduct(
        widget.initialProduct!.id,
        title: title,
        price: price,
        condition: _selectedCondition,
        category: _selectedCategory,
        size: _selectedSize,
        description: description,
        stock: stock,
      );
      return;
    }

    final imagePaths = _selectedImages.map((f) => f.path).toList();

    context.read<ProductCubit>().createProduct(
      title: title,
      price: price,
      condition: _selectedCondition,
      category: _selectedCategory,
      size: _selectedSize,
      description: description,
      stock: stock,
      imagePaths: imagePaths,
    );
  }
}
