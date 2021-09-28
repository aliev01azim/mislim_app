import 'package:aidar_zakaz/controllers/category_detail_controller.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/utils/theme.dart';
import 'package:aidar_zakaz/widgets/detail_listview_item.dart';
import 'package:aidar_zakaz/widgets/miniplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'audio_screen.dart';

class CategoryDetailScreen extends GetView<CategoryDetailController> {
  const CategoryDetailScreen(this.category, {Key? key}) : super(key: key);
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            stretch: true,
            pinned: true,
            elevation: 0,
            backgroundColor: currentTheme.currentColor().withOpacity(0.5),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                category.title,
                maxLines: 1,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
              background: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    errorWidget: (BuildContext context, _, __) => const Image(
                          image: AssetImage('assets/images/placeholder.jpg'),
                        ),
                    placeholder: (BuildContext context, _) => const Image(
                          image: AssetImage('assets/images/placeholder.jpg'),
                        ),
                    imageUrl: category.image),
              ),
            ),
            centerTitle: true,
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
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                GetBuilder<CategoryDetailController>(
                  initState: (_) =>
                      controller.fetchLecOfCategories(category.id),
                  builder: (_) {
                    return StreamBuilder<QueueState>(
                        stream: getIt<AudioPlayerHandler>().queueState,
                        builder: (context, snapshot) {
                          final queueState = snapshot.data ?? QueueState.empty;
                          return controller.isLoading
                              ? Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white))),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  itemBuilder: (_, index) => DetailListviewItem(
                                      controller.lecturesC[index],
                                      category,
                                      index,
                                      queueState),
                                  itemCount: controller.lecturesC.length,
                                );
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: MiniPlayer(),
      ),
    );
  }
}
