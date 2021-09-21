import 'package:aidar_zakaz/controllers/category_detail_controller.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:aidar_zakaz/widgets/shahe_detail_listview_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryShaheDetailScreen extends GetView<CategoryDetailController> {
  const CategoryShaheDetailScreen(this.shahe, {Key? key}) : super(key: key);
  final ShaheModel shahe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: (_, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              actions: [
                Row(
                  children: [
                    GetBuilder<HomeScreenController>(
                      builder: (homeController) {
                        return IconButton(
                          onPressed: () =>
                              homeController.addFavoriteShahes(shahe),
                          icon: shahe.isFavorite!
                              ? const Icon(
                                  Icons.favorite,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  size: 30,
                                ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
              elevation: 0,
              backgroundColor: Colorss.dark,
              pinned: false,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  shahe.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: const [
                  Icon(Icons.play_circle),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.shuffle)
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              const SizedBox(
                height: 20,
              ),
              GetBuilder<CategoryDetailController>(
                initState: (_) => controller.fetchLecOfAuthors(shahe.id),
                builder: (_) {
                  return controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (_, index) => ShaheDetailListviewItem(
                              controller.lecturesA[index]),
                          itemCount: controller.lecturesA.length,
                        );
                },
              ),
            ],
          ),
        ),
      ),
      // bottomSheet: GetBuilder<HomeScreenController>(
      //   builder: (_) {
      //     return Container(
      //       width: double.infinity,
      //       decoration: BoxDecoration(
      //         color: const Color.fromRGBO(18, 18, 18, 1),
      //         border: Border.all(color: Colors.black, width: 1),
      //         borderRadius: BorderRadius.circular(0),
      //       ),
      //       height: !controller.isShowing ? 0 : 50,
      //       child: Text('asdadsadadad'),
      //     );
      //   },
      // ),
    );
  }
}
