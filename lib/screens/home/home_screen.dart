import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/home/collection_story_item.dart';
import 'package:abo_abed_clothing/widgets/home/filter_chip.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    // Load products when screen initializes
    context.read<ProductCubit>().getAllProducts();
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    if (_activeFilter == 'all') return products;
    if (_activeFilter == 'new') {
      return products.where((p) => p.condition.toLowerCase() == 'new').toList();
    }
    if (_activeFilter == 'used') {
      return products
          .where((p) => p.condition.toLowerCase() == 'used')
          .toList();
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Content
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return _buildLoadingState(context);
                  } else if (state is ProductsLoaded) {
                    final filteredProducts = _filterProducts(state.products);
                    return _buildLoadedState(context, filteredProducts);
                  } else if (state is ProductFailure) {
                    return _buildErrorState(context, state.error.tr);
                  }
                  return _buildEmptyState(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppLightTheme.backgroundWhite.withOpacity(0.95),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Text(
              'home_title'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // letterSpacing: 2,
                color: AppLightTheme.textHeadline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, List<ProductModel> products) {
    return CustomScrollView(
      slivers: [
        // Collection Stories
        SliverToBoxAdapter(child: _buildCollectionStories(context)),

        // Sticky Filters
        SliverPersistentHeader(
          pinned: true,
          delegate: _FilterHeaderDelegate(
            child: Container(
              color: AppLightTheme.backgroundWhite.withOpacity(0.95),
              child: _buildFilters(context),
            ),
          ),
        ),

        // Products Grid or Empty State
        if (products.isEmpty)
          SliverFillRemaining(child: _buildNoProductsState(context))
        else
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,

              itemBuilder: (context, index) {
                return _buildProductCard(context, products[index], index);
              },
              childCount: products.length,
            ),
          ),
      ],
    );
  }

  Widget _buildCollectionStories(BuildContext context) {
    final collections = [
      {'name': 'men', 'icon': Icons.man},
      {'name': 'women', 'icon': Icons.woman},
      {'name': 'kids', 'icon': Icons.child_care},
      {'name': 'summer', 'icon': Icons.wb_sunny_outlined},
      {'name': 'accessories', 'icon': Icons.watch_outlined},
      {'name': 'shoes', 'icon': Icons.shopping_bag_outlined},
      {'name': 'suits', 'icon': Icons.business_center_outlined},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return CollectionStoryItem(
            name: (collection['name'] as String).tr,
            icon: collection['icon'] as IconData,
            onTap: () {
              Get.toNamed(
                Routes.CATEGORY_PRODUCTS,
                parameters: {'category': collection['name'] as String},
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CustomFilterChip(
            label: 'all_products'.tr,
            isActive: _activeFilter == 'all',
            onTap: () => setState(() => _activeFilter = 'all'),
          ),
          const SizedBox(width: 12),
          CustomFilterChip(
            label: 'new_arrivals'.tr,
            icon: Icons.new_releases_outlined,
            isActive: _activeFilter == 'new',
            onTap: () => setState(() => _activeFilter = 'new'),
          ),
          const SizedBox(width: 12),
          CustomFilterChip(
            label: 'rare_pieces'.tr,
            icon: Icons.recycling_outlined,
            isActive: _activeFilter == 'used',
            onTap: () => setState(() => _activeFilter = 'used'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductModel product,
    int index,
  ) {
    return ProductCard(
      product: product,
      onTap: () {
        Get.toNamed(
          Routes.PRODUCT_DETAILS,
          parameters: {'productId': product.id},
        );
      },
      onFavoriteTap: () {
        // TODO: Toggle favorite
      },
      index: index,
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return LoadingState(message: 'loading_products'.tr);
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return ErrorState(
      error: error,
      onRetry: () {
        context.read<ProductCubit>().getAllProducts();
      },
    );
  }

  Widget _buildNoProductsState(BuildContext context) {
    return EmptyState(
      message: 'no_products_found'.tr,
      actionLabel: _activeFilter != 'all' ? 'show_all_products'.tr : null,
      onAction: _activeFilter != 'all'
          ? () => setState(() => _activeFilter = 'all')
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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

// Sticky Filter Header Delegate
class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterHeaderDelegate({required this.child});

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
