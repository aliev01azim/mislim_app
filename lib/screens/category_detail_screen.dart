import 'package:aidar_zakaz/controllers/category_detail_controller.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/widgets/detail_listview_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDetailScreen extends GetView<CategoryDetailController> {
  const CategoryDetailScreen(this.category, {Key? key}) : super(key: key);
  final CategoryModel category;
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
                              homeController.addFavoriteCategory(category),
                          icon: category.isFavorite!
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
              backgroundColor: const Color.fromRGBO(29, 185, 84, 0.5),
              pinned: false,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Color.fromRGBO(29, 185, 84, 0.5),
                      Color.fromRGBO(158, 196, 209, 0),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 27,
                    ),
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(category.image),
                        fit: BoxFit.fill,
                      )),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 15,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  category.title,
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
                height: 20,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.play_circle,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.shuffle,
                      size: 30,
                    ),
                    onPressed: () {},
                  )
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              const SizedBox(
                height: 20,
              ),
              GetBuilder<CategoryDetailController>(
                initState: (_) => controller.fetchLecOfCategories(category.id),
                builder: (_) {
                  return controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (_, index) => DetailListviewItem(
                              controller.lecturesC[index], category),
                          itemCount: controller.lecturesC.length,
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
