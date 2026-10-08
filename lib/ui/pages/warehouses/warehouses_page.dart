import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/models/warehouse_model.dart';
import 'package:eagle_cargo/core/api/providers/warehouse_provider.dart';
import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/local_translations.dart';
import 'package:eagle_cargo/ui/pages/warehouses/components/warehouse_card.dart';
import 'package:eagle_cargo/ui/pages/warehouses/warehouses_view_model.dart';
import 'package:eagle_cargo/ui/widgets/appbars/default_appbar.dart';
import 'package:eagle_cargo/ui/widgets/empty_state.dart';

class WarehousesPage extends StatefulWidget {
  /// When true the page shows the warehouses located abroad instead of the
  /// regular ones.
  final bool isForeign;

  const WarehousesPage({super.key, this.isForeign = false});

  @override
  State<WarehousesPage> createState() => _WarehousesPageState();
}

class _WarehousesPageState extends WarehousesViewModel {

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WarehouseProvider>();
    List<WarehouseModel> list = widget.isForeign
        ? provider.foreignWarehouses
        : provider.warehouses;
    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.isForeign
            ? context.tl('mb_foreign_warehouses')
            : context.tr('menu_warehouses'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator.adaptive())
          : list.isEmpty
          ? EmptyState(
              icon: Icons.warehouse_outlined,
              title: context.tr('mb_temporary_empty'),
            )
          : ListView(
              controller: controller,
              children: list.map((e) => WarehouseCard(model: e)).toList(),
            ),
    );
  }
}
