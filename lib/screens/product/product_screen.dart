import 'dart:developer';

import 'package:abo_abed_clothing/blocs/product/product_cubit.dart';
import 'package:abo_abed_clothing/blocs/product/product_state.dart';
import 'package:abo_abed_clothing/core/apis/product/product_api.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/product/add_to_cart_button.dart';
import 'package:abo_abed_clothing/widgets/product/low_stock_indicator.dart';
import 'package:abo_abed_clothing/widgets/product/product_image_carousel.dart';
import 'package:abo_abed_clothing/widgets/product/product_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

/// Screen entry point that provides a scoped [ProductCubit].
/// This prevents state pollution of the global product list.
class ProductScreen extends StatelessWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(context.read<ProductApi>()),
      child: _ProductDetailsBody(productId: productId),
    );
  }
}

class _ProductDetailsBody extends StatefulWidget {
  final String productId;

  const _ProductDetailsBody({required this.productId});

  @override
  State<_ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<_ProductDetailsBody> {
  // Dummy images for when product has no media
  final List<String> _dummyImages = [
    'https://picsum.photos/200/300',
    'https://picsum.photos/200/300',
    'https://picsum.photos/200/300',
  ];

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    context.read<ProductCubit>().getProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: _onProductStateChanged,
        builder: (context, state) {
          ProductModel? product;
          if (state is ProductDetailsLoaded) {
            product = state.product;
          }

          return Stack(
            children: [
              _buildMainContent(state),
              if (product != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AddToCartButton(
                    product: product,
                    onAddToCart: () {
                      context.read<ProductCubit>().addToCart(
                        productId: product!.id,
                        quantity: 1,
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onProductStateChanged(BuildContext context, ProductState state) {
    if (state is ProductAddedToCart) {
      Get.snackbar(
        'success'.tr,
        state.message,
        backgroundColor: AppLightTheme.goldPrimary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } else if (state is ProductFailure) {
      Get.snackbar(
        'error'.tr,
        state.error,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Widget _buildMainContent(ProductState state) {
    if (state is ProductLoading) {
      return const LoadingState();
    } else if (state is ProductDetailsLoaded) {
      return _buildProductSlivers(state.product);
    } else if (state is ProductFailure) {
      log(state.error);
      return ErrorState(error: state.error, onRetry: _loadProduct);
    }
    return const LoadingState();
  }

  Widget _buildProductSlivers(ProductModel product) {
    final images = product.mediaItems.isEmpty
        ? _dummyImages
        : product.mediaItems
              .where((item) => item.type == 'image')
              .map((item) => item.url)
              .toList();

    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImageCarousel(images: images),
              ProductInfoSection(product: product),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LowStockIndicator(stock: product.stock),
              ),
              const SizedBox(height: 150), // Spacer for fixed button
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppLightTheme.backgroundWhite,
      elevation: 0,
      pinned: true,
    );
  }
}
