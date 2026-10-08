// import 'package:flutter/material.dart';
// import 'package:eagle_cargo/core/api/models/order_model.dart';
// import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
// import 'package:eagle_cargo/core/routes/routes.dart';
// import 'package:eagle_cargo/core/utils/palette.dart';
// import 'package:eagle_cargo/ui/widgets/default_button.dart';

// class OrderCard extends StatelessWidget {
//   final OrderModel model;
//   const OrderCard({super.key, required this.model});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(5),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.white,
//         boxShadow: context.defaultShadow()
//       ),
//       child: Column(
//         mainAxisSize: .min,
//         children: [
//           Row(
//             mainAxisAlignment: .spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: .start,
//                 children: [
//                   Text('Yuk kody'),
//                   Text(
//                     model.orderCode ?? "",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.amberAccent.withValues(alpha: 255*0.3),
//                 ),
//                 child: Text('Pending', style: TextStyle(color: Colors.orange)),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: .spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: .start,
//                 children: [
//                   Text('Sender'),
//                   Text(
//                     model.senderName ?? "",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: .start,
//                 children: [
//                   Text('Service'),
//                   Text(
//                     model.serviceType ?? "",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: .spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: .start,
//                 children: [
//                   Text('Estimated cost'),
//                   Text(
//                     "${model.estimatedCost?.toString()} TMT",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: .start,
//                 children: [
//                   Text('Firma'),
//                   Text(
//                     model.firm?.name ?? "",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           DefaultButton(
//             text: 'Details',
//             onTap: () {
//               Navigator.pushNamed(context, Routes.orderDetail);
//             },
//             textColor: Colors.white,
//             color: Palette.primary,
//           ),
//         ],
//       ),
//     );
//   }
// }
