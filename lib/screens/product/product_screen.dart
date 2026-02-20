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
import 'package:abo_abed_clothing/widgets/product/quantity_selector.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../admin/create_product_screen.dart';

/// Screen entry point that provides a scoped [ProductCubit].
/// This prevents state pollution of the global product list.
class ProductScreen extends StatelessWidget {
  final String productId;
  final bool isAdminMode;

  const ProductScreen({
    super.key,
    required this.productId,
    this.isAdminMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(context.read<ProductApi>()),
      child: _ProductDetailsBody(
        productId: productId,
        isAdminMode: isAdminMode,
      ),
    );
  }
}

class _ProductDetailsBody extends StatefulWidget {
  final String productId;
  final bool isAdminMode;

  const _ProductDetailsBody({
    required this.productId,
    required this.isAdminMode,
  });

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

  int _quantity = 1;

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
            // log(product.toJson().toString(), name: 'loaded product details');
          }

          return Stack(
            children: [
              _buildMainContent(state),
              if (!widget.isAdminMode && product != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: AppLightTheme.dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        QuantitySelector(
                          quantity: _quantity,
                          maxQuantity: product.stock,
                          onChanged: (val) {
                            setState(() {
                              _quantity = val;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AddToCartButton(
                            product: product,
                            onAddToCart: () {
                              context.read<ProductCubit>().addToCart(
                                productId: product!.id,
                                quantity: _quantity,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
      AppSnackbar.showSuccess(message: state.message);
      Get.offAllNamed('/main-home');
    } else if (state is ProductFailure) {
      AppSnackbar.showError(message: state.error.tr);
    }
  }

  Widget _buildMainContent(ProductState state) {
    if (state is ProductLoading) {
      return const LoadingState();
    } else if (state is ProductDetailsLoaded) {
      return _buildProductSlivers(state.product);
    } else if (state is ProductFailure) {
      log(state.error.tr);
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
        _buildAppBar(product),
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
              const SizedBox(height: 150),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(ProductModel product) {
    return SliverAppBar(
      backgroundColor: AppLightTheme.backgroundWhite,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (widget.isAdminMode)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _openEditScreen(product),
          ),
      ],
    );
  }

  Future<void> _openEditScreen(ProductModel product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => ProductCubit(context.read<ProductApi>()),
          child: CreateProductScreen(initialProduct: product),
        ),
      ),
    );

    if (mounted) {
      _loadProduct();
    }
  }
}
