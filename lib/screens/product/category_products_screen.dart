import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:abo_abed_clothing/blocs/product/product_cubit.dart';
import 'package:abo_abed_clothing/blocs/product/product_state.dart';
import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/routes/app_router.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getAllProducts();
  }

  List<ProductModel> _filterProductsByCategory(List<ProductModel> products) {
    return products
        .where((p) => p.category.toLowerCase() == widget.category.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      appBar: _buildAppBar(),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return _buildLoadingState();
          } else if (state is ProductsLoaded) {
            final filteredProducts = _filterProductsByCategory(state.products);
            return _buildProductsGrid(filteredProducts);
          } else if (state is ProductFailure) {
            return _buildErrorState(state.error.tr);
          }
          return _buildEmptyState();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppLightTheme.backgroundWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppLightTheme.textHeadline),
        onPressed: () => Get.back(),
      ),
      title: Text(
        widget.category.tr,
        style: const TextStyle(
          color: AppLightTheme.textHeadline,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0xFFF5F5F5), height: 1),
      ),
    );
  }

  Widget _buildProductsGrid(List<ProductModel> products) {
    if (products.isEmpty) {
      return EmptyState(
        message: 'no_products_found'.tr,
        actionLabel: 'retry'.tr,
        onAction: () {
          context.read<ProductCubit>().getAllProducts();
        },
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                onTap: () {
                  Get.toNamed(
                    Routes.PRODUCT_DETAILS,
                    parameters: {'productId': products[index].id},
                  );
                },
                onFavoriteTap: () {
                  // TODO: Toggle favorite
                },
                index: index,
              );
            },
            childCount: products.length,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return LoadingState(message: 'loading_products'.tr);
  }

  Widget _buildErrorState(String error) {
    return ErrorState(
      error: error,
      onRetry: () {
        context.read<ProductCubit>().getAllProducts();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: AppLightTheme.textBody,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductCubit>().getAllProducts();
            },
            child: Text('retry'.tr),
          ),
        ],
      ),
    );
  }
}
