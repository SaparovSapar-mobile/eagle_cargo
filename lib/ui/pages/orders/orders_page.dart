// import 'package:flutter/material.dart';
// import 'package:eagle_cargo/core/api/models/order_model.dart';
// import 'package:eagle_cargo/core/api/providers/order_provider.dart';
// import 'package:eagle_cargo/ui/pages/main/components/page_lifecycle.dart';
// import 'package:eagle_cargo/ui/pages/orders/components/order_card.dart';
// import 'package:eagle_cargo/ui/widgets/appbars/default_appbar.dart';
// import 'package:provider/provider.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});

//   @override
//   State<OrdersPage> createState() => OrdersPageState();
// }

// class OrdersPageState extends State<OrdersPage> with PageLifecycle {
//   bool isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     setState(() => isLoading = true);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<OrderProvider>().getOrders(
//         onSuccess: () {
//           setState(() => isLoading = false);
//         },
//       );
//     });
//   }

//   void onTabOpen() {
//     debugPrint("Home page tab re-opened");
//     // refresh logic here
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<OrderModel> orders = context.watch<OrderProvider>().orders;
//     return Scaffold(
//       // bottomNavigationBar: BottomNavigation(selectedMenu: MenuState.orders),
//       appBar: DefaultAppBar(title: "Orders"),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator.adaptive())
//           : ListView(children: orders.map((e) => OrderCard(model: e)).toList()),
//     );
//   }
// }
