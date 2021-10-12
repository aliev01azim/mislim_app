import 'package:aidar_zakaz/controllers/category_detail_controller.dart';
import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/widgets/category/category_and_shahe_item.dart';
import 'package:aidar_zakaz/widgets/miniplayer.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'audio_screen.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen(this.categoryOrShahe, {Key? key}) : super(key: key);
  final Map<dynamic, dynamic> categoryOrShahe;
  final audioHandler = getIt<AudioPlayerHandler>();
  final controller = Get.put(CategoryDetailController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: categoryOrShahe['image'] != null
                ? MediaQuery.of(context).size.height * 0.4
                : 0,
            stretch: true,
            pinned: true,
            elevation: 0,
            title: categoryOrShahe['image'] != null
                ? null
                : Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            categoryOrShahe['name'] ?? categoryOrShahe['title'],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
            flexibleSpace: categoryOrShahe['image'] != null
                ? FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      categoryOrShahe['title'],
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: categoryOrShahe['image'] != null
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              errorWidget: (BuildContext context, _, __) =>
                                  const Image(
                                    image: AssetImage(
                                        'assets/images/placeholder.jpg'),
                                  ),
                              placeholder: (BuildContext context, _) =>
                                  const Image(
                                    image: AssetImage(
                                        'assets/images/placeholder.jpg'),
                                  ),
                              imageUrl: categoryOrShahe['image'])
                          : const SizedBox(),
                    ),
                  )
                : null,
            centerTitle: true,
            actions: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      categoryOrShahe['isFavorite'] =
                          categoryOrShahe['isFavorite'] == 'false'
                              ? 'true'
                              : 'false';
                      final categories = Hive.box('favorites').get(
                          categoryOrShahe['image'] != null
                              ? 'likedCategories'
                              : 'likedShahes',
                          defaultValue: []) as List;
                      if (categoryOrShahe['isFavorite'] == 'true') {
                        categories.insert(0, categoryOrShahe);
                        await Hive.box('favorites').put(
                            categoryOrShahe['image'] != null
                                ? 'likedCategories'
                                : 'likedShahes',
                            categories);
                      } else {
                        categories.remove(categoryOrShahe);
                        await Hive.box('favorites').put(
                            categoryOrShahe['image'] != null
                                ? 'likedCategories'
                                : 'likedShahes',
                            categories);
                      }
                    },
                    icon: ValueListenableBuilder(
                        valueListenable: Hive.box('favorites').listenable(),
                        builder: (_, __, ___) {
                          return categoryOrShahe['isFavorite'] == 'true'
                              ? Icon(
                                  Icons.favorite,
                                  color: currentTheme.currentColor(),
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  size: 30,
                                );
                        }),
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
                  initState: (_) => controller.fetchLecOfCategoriesOrShahes(
                      categoryOrShahe['image'] != null
                          ? 'category/${categoryOrShahe['id']}'
                          : 'author/${categoryOrShahe['id']}'),
                  builder: (_) {
                    return StreamBuilder<MediaItem?>(
                        stream: audioHandler.mediaItem,
                        builder: (context, snapshot) {
                          final MediaItem? mediaItem = snapshot.data;
                          if (mediaItem == null) return const SizedBox();
                          return controller.isLoading
                              ? Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        currentTheme.currentColor(),
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                    color: currentTheme.currentTheme() ==
                                            ThemeMode.dark
                                        ? Colors.grey[500]
                                        : Colors.grey[300],
                                    indent: 20,
                                    height: 3,
                                    endIndent: 20,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  itemBuilder: (_, index) => DetailListviewItem(
                                    controller.lecturesC[index],
                                    index,
                                    mediaItem.extras!['url'],
                                  ),
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
