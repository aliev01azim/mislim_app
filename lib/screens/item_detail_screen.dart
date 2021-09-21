// import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
// import 'package:aidar_zakaz/controllers/item_detail_controller.dart';
// import 'package:aidar_zakaz/models/lecture_model.dart';
// import 'package:aidar_zakaz/utils/colors.dart';
// import 'package:aidar_zakaz/utils/images.dart';
// // import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// class ItemDetailScreen extends GetView<ItemDetailController> {
//   const ItemDetailScreen(this.item, {Key? key}) : super(key: key);
//   final LectureModel item;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: Colorss.dark,
//           appBar: AppBar(
//             leading: Padding(
//               padding: const EdgeInsets.only(left: 8.0, top: 8),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(40.0)),
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_drop_down,
//                   ),
//                   onPressed: () => Get.back(),
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (Get.arguments != null)
//                     Text(
//                       'Категория:',
//                       style: TextStyle(
//                           color: Colors.white.withOpacity(0.6), fontSize: 16),
//                     ),
//                   if (Get.arguments != null)
//                     Text(
//                       item.categoryTitle,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                   if (Get.arguments == null)
//                     Text(
//                       'Проповедник:',
//                       style: TextStyle(
//                           color: Colors.white.withOpacity(0.6), fontSize: 16),
//                     ),
//                   if (Get.arguments == null)
//                     Text(
//                       item.author.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                 ],
//               ),
//             ),
//             actions: [
//               IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
//             ],
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.blueGrey[700]),
//                     height: 200,
//                     width: 200,
//                     child: Icon(
//                       Icons.headphones,
//                       color: Colors.grey[300],
//                       size: 100,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 22.0,
//               ),
//               Text(
//                 item.title,
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     overflow: TextOverflow.ellipsis,
//                     fontSize: 22.0),
//               ),
//               Text(
//                 Get.arguments == null
//                     ? 'из категории : ${item.categoryTitle}'
//                     : 'проповедник : ${item.author.title}',
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.6),
//                     fontStyle: FontStyle.italic,
//                     fontSize: 16.0),
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: GetBuilder<ItemDetailController>(
//                     initState: controller.initState(item.lectureFile),
//                     builder: (_) {
//                       return Slider.adaptive(
//                           inactiveColor: Colors.grey[600],
//                           activeColor: Colors.white,
//                           //change value after 11 step, and add min and max
//                           value: controller.timeProgress.toDouble(),
//                           // min: 0.0,
//                           max: controller.audioDuration.toDouble(),
//                           onChanged: (value) {
//                             controller.seekToSec(value.toInt());
//                           });
//                     }),
//               ),
//               GetBuilder<ItemDetailController>(
//                 builder: (_) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Row(
//                       children: [
//                         Text(
//                           controller.getTimeString(controller.timeProgress),
//                           style: const TextStyle(fontSize: 12, height: 0.6),
//                         ),
//                         Text(
//                           controller.getTimeString(controller.audioDuration),
//                           style: const TextStyle(fontSize: 12, height: 0.6),
//                         )
//                       ],
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     ),
//                   );
//                 },
//               ),
//               GetBuilder<ItemDetailController>(
//                 builder: (_) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.skip_previous_rounded,
//                           size: 45,
//                         ),
//                         color: Colors.white54,
//                       ),
//                       const SizedBox(
//                         width: 30,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           controller.audioPlayerState == PlayerState.PLAYING
//                               ? controller.pauseMusic(context)
//                               : controller.playMusic(item.lectureFile);
//                         },
//                         iconSize: 80.0,
//                         icon: Icon(
//                           controller.audioPlayerState == PlayerState.PLAYING
//                               ? Icons.pause_rounded
//                               : Icons.play_arrow_rounded,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 30,
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.skip_next_rounded,
//                           size: 45,
//                         ),
//                         color: Colors.white54,
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 30.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Icon(
//                     Icons.download_rounded,
//                   ),
//                   Icon(
//                     Icons.repeat,
//                   ),
//                   GetBuilder<HomeScreenController>(
//                     builder: (homeController) {
//                       return IconButton(
//                         onPressed: () =>
//                             homeController.addFavoriteLecture(item),
//                         icon: item.isFavorite!
//                             ? const Icon(
//                                 Icons.favorite,
//                                 size: 25,
//                               )
//                             : const Icon(
//                                 Icons.favorite_border,
//                                 size: 25,
//                               ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10.0),
//             ],
//           ),
//           ),
//     );
//   }
// }
