import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/api/models/order_model.dart';
import 'package:eagle_cargo/core/api/models/package_model.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/routes/routes.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';
import 'package:eagle_cargo/ui/pages/order_detail/order_detail_page.dart';

class ShipmentTile extends StatelessWidget {
  final String trackingNumber;
  final String rawStatus; // <--- raw value, translated in build()
  final Color statusColor;
  final String deliverableDate;
  final int currentStep;
  final FromLocation? fromLocation;
  final FromLocation? toLocation;
  final String weight;
  final String serviceType;
  final String totalCost;

  const ShipmentTile({
    super.key,
    required this.trackingNumber,
    required this.rawStatus,
    required this.statusColor,
    required this.deliverableDate,
    required this.currentStep,
    required this.fromLocation,
    required this.toLocation,
    required this.weight,
    required this.serviceType,
    required this.totalCost,
  });

  // ---------------- FACTORIES ----------------

  factory ShipmentTile.fromPackage({required PackageModel? package}) {
    return ShipmentTile(
      trackingNumber: package?.order?.orderCode ?? "Unknown",
      rawStatus: package?.status ?? "",
      statusColor: _getStatusColor(package?.status),
      deliverableDate:
          (package?.createdDt.parseTime().split(' ')[0]) ?? "Unknown",
      currentStep: _getStepIndex(package?.status),
      fromLocation: package?.order?.fromLocation,
      toLocation: package?.order?.toLocation,
      weight: package?.weightKg?.toString() ?? "0",
      serviceType: package?.order?.serviceType ?? "...",
      totalCost:
          "${package?.order?.totalCostTmt ?? package?.order?.finalCost ?? package?.order?.estimatedCost ?? 0}",
    );
  }

  factory ShipmentTile.fromOrder({required OrderModel? order}) {
    return ShipmentTile(
      trackingNumber: order?.orderCode ?? "Unknown",
      rawStatus: order?.package?.status ?? "",
      statusColor: _getStatusColor(order?.package?.status),
      deliverableDate:
          (order?.package?.createdDt.parseTime().split(' ')[0]) ?? "Unknown",
      currentStep: _getStepIndex(order?.package?.status),
      fromLocation: order?.fromLocation,
      toLocation: order?.toLocation,
      weight: order?.package?.weightKg.toString() ?? "0",
      serviceType: order?.serviceType ?? "...",
      totalCost:
          "${order?.totalCostTmt ?? order?.finalCost ?? order?.estimatedCost ?? 0}",
    );
  }

  // ---------------- HELPERS ----------------

  static Color _getStatusColor(String? status) {
    switch (status) {
      case 'in_warehouse':
      case 'delivered':
      case 'is_checked':
        return Colors.green;
      case 'in_transit':
      case 'transport':
        return Colors.orange;
      case 'waiting':
      case 'registered':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  static int _getStepIndex(String? status) {
    switch (status) {
      case 'waiting':
      case 'registered':
        return 1;
      case 'in_transit':
      case 'transport':
        return 2;
      case 'is_checked':
      case 'in_warehouse':
        return 3; // Keep warehouse check here
      case 'delivered':
        return 4; // Final step
      default:
        return 1;
    }
  }

  static String getDisplayStatus(BuildContext context, String? status) {
    switch (status?.toLowerCase()) {
      case 'waiting':
        return context.tr('step_registered');
      case 'registered':
        return context.tr('step_registered');
      case 'transport':
        return context.tr("in_transit");
      case 'in_transit':
        return context.tr('in_transit');
      case 'in_warehouse':
        return context.tr('status_completed').toSentenceCase();
      case 'is_checked':
        return context.tr('status_completed').toSentenceCase();
      case 'delivered':
        return context.tr('mb_delivered_to_customer_short').toSentenceCase();
      default:
        return status ?? "";
    }
  }

  Widget _buildStepProgress(BuildContext context) {
    final String from = context
        .tr('mb_in_z_warehouse')
        .replaceAll(
          'zzz',
          fromLocation?.getLocalizedTitle(context.langCode) ?? '',
        );
    final String to = context
        .tr('mb_in_z_warehouse')
        .replaceAll(
          'zzz',
          toLocation?.getLocalizedTitle(context.langCode) ?? '',
        );
    final labels = [
      from,
      context.tr('package_status_transport'),
      to,
      context.tr('mb_delivered_to_customer_short'),
    ];

    const double dotSize = 22.0; // Increased from 14

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double stepWidth = constraints.maxWidth / labels.length;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Connecting Lines
              Positioned(
                top: dotSize / 2, // Perfectly centered to the dots
                left: stepWidth / 2,
                right: stepWidth / 2,
                child: Row(
                  children: List.generate(labels.length - 1, (index) {
                    final bool isCompleted = index + 1 < currentStep;
                    return Expanded(
                      child: Container(
                        height: 2.5, // Slightly thicker line
                        color: isCompleted
                            ? Palette.primaryDark
                            : Palette.primaryLight,
                      ),
                    );
                  }),
                ),
              ),

              // Dots and Wrapped Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(labels.length, (index) {
                  final stepNum = index + 1;
                  final isActive = stepNum <= currentStep;
                  final isCompleted = stepNum < currentStep;

                  return SizedBox(
                    width: stepWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Larger Dot
                        Container(
                          width: dotSize,
                          height: dotSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? Palette.primaryLight
                                : Palette.primaryDark,
                            border: Border.all(
                              color: isActive
                                  ? Palette.primaryLight
                                  : Palette.primaryDark,
                              width: 2,
                            ),
                            // boxShadow: isActive
                            //     ? [
                            //         BoxShadow(
                            //           color: Palette.primary.withValues(
                            //             alpha: 255 * 0.2,
                            //           ),
                            //           blurRadius: 4,
                            //         ),
                            //       ]
                            //     : [],
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : isActive
                                ? Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Wrapped Label
                        Text(
                          labels[index],
                          textAlign: TextAlign.center,
                          maxLines: 3, // Allow more wrapping
                          softWrap: true,
                          style: TextStyle(
                            // fontSize: 10, // Increased from 8
                            height: 1.1,
                            letterSpacing: -0.2,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isActive
                                ? (context.isDark()
                                      ? Colors.white
                                      : Colors.black87)
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    final status = getDisplayStatus(context, rawStatus);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.orderDetail,
          arguments: OrderDetailPageArgs(trackingNumber: trackingNumber),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        clipBehavior: .antiAlias,
        decoration: BoxDecoration(
          color: context.isDark() ? Palette.darkSurface : Colors.white,
          borderRadius: .circular(16),
          boxShadow: context.defaultShadow(),
        ),
        child: Stack(
          children: [
            // Background Logo
            Positioned(
              right: -30,
              bottom: -30,
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/box.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStepProgress(context),
                  const SizedBox(height: 16),
                  // First Row: Order Code and Service Type
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: Palette.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                trackingNumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warehouse,
                              color: Palette.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                serviceType.toSentenceCase(),
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Second Row: Weight and Total Cost
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.scale_outlined,
                              color: Palette.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "$weight kg",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (totalCost != "0" &&
                          totalCost != "0.0" &&
                          totalCost != "0.00" &&
                          totalCost != "null")
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.payments_outlined,
                                color: Palette.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "$totalCost TMT",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.primary,
                                ),
                              ),
                            ],
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
}
