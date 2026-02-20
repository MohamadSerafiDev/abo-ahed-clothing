import 'package:abo_abed_clothing/blocs/product/product_cubit.dart';
import 'package:abo_abed_clothing/blocs/product/product_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:abo_abed_clothing/widgets/global/confirm_dialog.dart';
import 'package:abo_abed_clothing/widgets/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'create_product_screen.dart';
import '../product/product_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('products'.tr, style: TextStyles.headlineMedium()),
        backgroundColor: AppLightTheme.backgroundWhite,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateProductScreen()),
          );
          // Reload products when returning from create screen
          if (mounted) {
            context.read<ProductCubit>().getAllProducts();
          }
        },
        backgroundColor: AppLightTheme.goldPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'add_product'.tr,
          style: TextStyles.buttonText.copyWith(fontSize: 14),
        ),
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductDeleted) {
            AppSnackbar.showSuccess(message: state.message);
            context.read<ProductCubit>().getAllProducts();
          } else if (state is ProductActionSuccess) {
            AppSnackbar.showSuccess(message: state.message);
            context.read<ProductCubit>().getAllProducts();
          } else if (state is ProductFailure) {
            AppSnackbar.showError(message: state.error.tr);
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const LoadingState();
          }

          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return EmptyState(
                message: 'no_products_found'.tr,
                icon: Icons.inventory_2_outlined,
              );
            }
            return _buildProductGrid(state.products);
          }

          if (state is ProductFailure) {
            return ErrorState(
              error: state.error.tr,
              onRetry: () => context.read<ProductCubit>().getAllProducts(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Stack(
            children: [
              ProductCard(
                product: product,
                index: index,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductScreen(
                        productId: product.id,
                        isAdminMode: true,
                      ),
                    ),
                  );
                },
              ),
              // Admin delete button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _confirmDelete(context, product),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductModel product,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'delete_product'.tr,
      content: '${'confirm_delete_product'.tr}\n"${product.title}"',
      confirmText: 'delete'.tr,
      cancelText: 'cancel'.tr,
      confirmColor: Colors.redAccent,
      icon: Icons.delete_forever,
    );

    if (confirmed == true && context.mounted) {
      context.read<ProductCubit>().deleteProduct(product.id);
    }
  }
}
