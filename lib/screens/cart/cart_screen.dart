import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:abo_abed_clothing/blocs/cart/cart_cubit.dart';
import 'package:abo_abed_clothing/blocs/cart/cart_state.dart';
import 'package:abo_abed_clothing/blocs/order/order_cubit.dart';
import 'package:abo_abed_clothing/blocs/order/order_state.dart';
import 'package:abo_abed_clothing/models/cart_model.dart';
import 'package:abo_abed_clothing/models/order_model.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/cart/index.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final TextEditingController _couponController;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController();
    context.read<CartCubit>().getCart();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      appBar: CartAppBar(),
      body: BlocListener<OrderCubit, OrderState>(
        listener: (context, orderState) {
          if (orderState is OrderLoading) {
            // Show loading
          } else if (orderState is OrderSuccess) {
            // Show success message
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppSnackbar.showSuccess(message: orderState.message);
              // TODO: Navigate to order confirmation page or clear cart
            });
          } else if (orderState is OrderFailure) {
            // Show error message
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppSnackbar.showError(message: orderState.error);
            });
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CartState state) {
    if (state is CartLoading) {
      return const LoadingState();
    }

    if (state is CartFailure) {
      return ErrorState(
        title: 'cart_failed'.tr,
        error: state.error,
        onRetry: () => context.read<CartCubit>().getCart(),
      );
    }

    if (state is CartActionSuccess) {
      // Show a snackbar for success actions
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackbar.showSuccess(message: state.message);
        // Reload cart to show updates
        context.read<CartCubit>().getCart();
      });
      // Show loading while cart reloads
      return const LoadingState();
    }

    if (state is CartLoaded) {
      return state.cart.isEmpty
          ? EmptyState(
              message: 'start_shopping'.tr,
              icon: Icons.shopping_bag_outlined,
            )
          : _CartContent(cart: state.cart, couponController: _couponController);
    }

    if (state is CartInitial) {
      return const EmptyState(icon: Icons.shopping_bag_outlined);
    }

    // Default fallback
    return const EmptyState(icon: Icons.shopping_bag_outlined);
  }
}

/// Cart Content Widget
class _CartContent extends StatefulWidget {
  final CartModel cart;
  final TextEditingController couponController;

  const _CartContent({required this.cart, required this.couponController});

  @override
  State<_CartContent> createState() => _CartContentState();
}

class _CartContentState extends State<_CartContent> {
  late CartModel _localCart;

  @override
  void initState() {
    super.initState();
    _localCart = widget.cart;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, orderState) {
        if (orderState is OrderLoading) {
          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (orderState is OrderSuccess) {
          // Dismiss loading dialog if shown
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        } else if (orderState is OrderFailure) {
          // Dismiss loading dialog if shown
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'cart_title'.tr,
                          style: TextStyles.headlineMedium(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'items_selected'.trParams({
                            'count': _localCart.itemsCount.toString(),
                          }),
                          style: TextStyles.bodyMedium().copyWith(
                            color: AppLightTheme.textBody,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = _localCart.items[index];
                    return CartItemTile(
                      item: item,
                      onRemove: () {
                        context.read<CartCubit>().removeFromCart(item.id);
                      },
                      onQuantityChanged: (newQuantity) {
                        setState(() {
                          _localCart = CartModel(
                            id: _localCart.id,
                            customer: _localCart.customer,
                            items: _localCart.items.map((cartItem) {
                              if (cartItem.id == item.id) {
                                return cartItem.copyWith(quantity: newQuantity);
                              }
                              return cartItem;
                            }).toList(),
                            createdAt: _localCart.createdAt,
                            updatedAt: _localCart.updatedAt,
                          );
                        });
                      },
                    );
                  }, childCount: _localCart.items.length),
                ),
              ],
            ),
          ),
          CartSummary(
            cart: _localCart,
            onCheckout: () {
              // Build checkout request from cart items
              final items = _localCart.items
                  .map(
                    (item) => OrderItemRequest(
                      productId: item.product.id,
                      quantity: item.quantity,
                    ),
                  )
                  .toList();

              final checkoutRequest = CheckoutRequest(
                items: items,
                totalPrice: _localCart.totalPrice,
                screenshot: '', // TODO: Add screenshot upload
              );
              log(checkoutRequest.toJson().toString());
              context.read<OrderCubit>().checkout(checkoutRequest);
            },
          ),
        ],
      ),
    );
  }
}
