import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/package_model.dart';
import 'package:eagle_cargo/core/api/providers/order_provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/local_translations.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';
import 'package:eagle_cargo/ui/pages/order_detail/components/order_detail_card.dart';
import 'package:eagle_cargo/ui/pages/order_detail/components/order_detail_chip.dart';
import 'package:eagle_cargo/ui/pages/order_detail/components/order_detail_route.dart';
import 'package:eagle_cargo/ui/pages/order_detail/components/order_detail_vertical_steps.dart';
import 'package:eagle_cargo/ui/pages/order_detail/order_detail_view_model.dart';
import 'package:eagle_cargo/ui/widgets/cached_image.dart';
import 'package:eagle_cargo/ui/widgets/zoom_image.dart';

class OrderDetailPageArgs {
  final String? trackingNumber;

  OrderDetailPageArgs({this.trackingNumber});
}

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends OrderDetailViewModel {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PackageModel? item = context.watch<OrderProvider>().current;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.textColor()),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.textColor()),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('package_details').toSentenceCase(),
          style: TextStyle(
            color: context.textColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SafeArea(
              child: Column(
                children: [
                  // Scrollable content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Top icon
                        Center(
                          child: Container(
                            width: size.width / 3,
                            height: size.width / 3,
                            decoration: const BoxDecoration(
                              color: Color(0xFFECF8F3),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/box.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SelectableText(
                          '${item?.order?.orderCode}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 32),

                        // SHIPMENT STEPS (Vertical)
                        OrderDetailCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('status'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 24),
                              OrderDetailVerticalSteps(item: item),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ROUTE — countries on the way; absent for most
                        // shipments, then the page looks as before.
                        if (item?.route != null && !item!.route!.isEmpty) ...[
                          OrderDetailCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tl('mb_route'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                OrderDetailRoute(route: item.route!),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // DETAILS CARD
                        OrderDetailCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('mb_details'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  OrderDetailChip(
                                    icon: Icons.scale,
                                    label: "${item?.weightKg} kg",
                                  ),
                                  OrderDetailChip(
                                    icon: Icons.warehouse_rounded,
                                    label:
                                        item?.order?.serviceType
                                            ?.toSentenceCase() ??
                                        "...",
                                  ),
                                  if (item?.lengthCm != null ||
                                      item?.heightCm != null ||
                                      item?.widthCm != null)
                                    OrderDetailChip(
                                      icon: Icons.straighten,
                                      label:
                                          "${item?.lengthCm ?? 0} x ${item?.widthCm ?? 0} x ${item?.heightCm ?? 0}",
                                    ),
                                  OrderDetailChip(
                                    icon: Icons.payments,
                                    label:
                                        "${item?.order?.totalCostTmt ?? item?.order?.finalCost ?? item?.order?.estimatedCost ?? 0} TMT",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (item?.photos?.isNotEmpty ?? false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              sectionTitle(context.tr('mb_photos')),
                              SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: item?.photos?.length,
                                  itemBuilder: (context, i) {
                                    final url = item?.photos?[i].photoUrl;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ZoomImage(
                                              images: [
                                                "${API.host}/uploads$url",
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: size.width / 4,
                                        height: size.width / 4,
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: CachedImage(
                                            imageUrl: "${API.host}/uploads$url",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
