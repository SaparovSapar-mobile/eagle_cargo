import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/order_provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys, VersionUtil;
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/ui/pages/home/components/home_order_list.dart';
import 'package:eagle_cargo/ui/pages/home/components/home_search_card.dart';
import 'package:eagle_cargo/ui/pages/home/components/shipment_tile.dart';
import 'package:eagle_cargo/ui/pages/home/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final searchResult = provider.searchResult;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.unfocus();
          }
        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            SliverAppBar(
              backgroundColor: Palette.primaryLight,
              pinned: true,
              elevation: 0,
              title: Text(
                "👋 ${context.t('welcome_title_1')}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: HomeSearchCard(
                  controller: codeController,
                  onSubmitted: searchByCode,
                  onScanQr: scanQr,
                ),
              ),
            ),

            if (searchResult != null) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ShipmentTile.fromPackage(package: searchResult),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],

            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                tabBar: TabBar(
                  controller: tabController,
                  labelColor: Palette.primaryLight,
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: Palette.primaryLight,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  tabs: [
                    Tab(text: context.t('status_pending')),
                    Tab(text: context.t('mb_status_completed')),
                  ],
                ),
              ),
            ),
          ],

          body: TabBarView(
            controller: tabController,
            children: [
              HomeOrderList(
                onRefresh: () async => loadTabData(tabController.index),
                status: 'confirmed',
              ),
              HomeOrderList(
                onRefresh: () async => loadTabData(tabController.index),
                status: 'completed',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _StickyTabBarDelegate({required this.tabBar});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          tabBar,
          Divider(height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height + 1;
  @override
  double get minExtent => tabBar.preferredSize.height + 1;
  @override
  bool shouldRebuild(_) => true;
}
