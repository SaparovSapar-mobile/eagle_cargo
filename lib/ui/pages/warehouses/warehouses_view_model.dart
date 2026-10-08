import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/warehouse_provider.dart';
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'warehouses_page.dart';

abstract class WarehousesViewModel extends State<WarehousesPage>{
  bool isLoading = false;
  final controller = ScrollController();

  Future<void>? _loadMore() {
    final provider = context.read<WarehouseProvider>();
    return widget.isForeign ? provider.getForeign() : provider.getAll();
  }

  @override
  void initState() {
    super.initState();
    setState(() => isLoading = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addListener(() {
        if (controller.position.atEdge) {
          bool isTop = controller.position.pixels == 0;
          if (!isTop) {
            _loadMore();
          }
        }
      });
    });
    final provider = context.read<WarehouseProvider>();
    if (widget.isForeign) {
      provider.resetForeign();
    } else {
      provider.reset();
    }
    void onError() {
      context.showErrorToast(description: context.tr('mb_error_occured'));
      setState(() => isLoading = false);
    }

    void onSuccess() => setState(() => isLoading = false);

    if (widget.isForeign) {
      provider.getForeign(onError: onError, onSuccess: onSuccess);
    } else {
      provider.getAll(onError: onError, onSuccess: onSuccess);
    }
  }
}
