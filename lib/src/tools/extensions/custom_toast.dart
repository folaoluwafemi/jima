// import 'package:flutter/material.dart';
// import 'package:toastification/toastification.dart';
//
// class CustomToast extends StatelessWidget {
//   const CustomToast({
//     required this.message,
//     required this.holder,
//     this.isError = true,
//     super.key,
//   });
//
//   final String message;
//   final ToastificationItem holder;
//   final bool isError;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isError ? ColorName.toastBg : ColorName.success,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(width: 0.5, color: isError ? ColorName.failure : ColorName.success),
//       ),
//       margin: const EdgeInsets.only(right: 16, left: 4),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 16, 8, 10),
//             child: Row(
//               children: [
//                 if (isError)
//                   Assets.svg.alertTriangle.svg()
//                 else
//                   Icon(
//                     Icons.check_circle_outline,
//                     color: context.colorScheme.onPrimary,
//                   ),
//                 Spacing.horizontal8(),
//                 Expanded(
//                   child: Text(
//                     message,
//                     style: context.textTheme.bodyMedium?.copyWith(
//                       color: isError ? ColorName.failure : context.colorScheme.onPrimary,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     toastification.dismiss(holder);
//                   },
//                   child: Icon(
//                     Icons.close,
//                     color: isError ? ColorName.failure : context.colorScheme.onPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ToastTimerAnimationBuilder(
//             item: holder,
//             builder: (context, value, _) {
//               return LinearProgressIndicator(
//                 minHeight: 4,
//                 borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(8),
//                   bottomLeft: Radius.circular(8),
//                 ),
//                 backgroundColor: Colors.transparent,
//                 value: value,
//                 color: isError ? ColorName.failure : Colors.white.withValues(alpha: 0.5),
//               );
//             },
//           ),
//           Spacing.vertical(2),
//         ],
//       ),
//     );
//   }
// }
