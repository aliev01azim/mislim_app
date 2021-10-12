import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/screens/category_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListviewItem extends StatelessWidget {
  const ListviewItem(this.category, this.isIcon, {Key? key}) : super(key: key);
  final Map<dynamic, dynamic> category;
  final bool isIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(category),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SizedBox(
          width: 180,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 3.0),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 170,
                    child: CachedNetworkImage(
                      imageUrl:
                          category['image'] ?? 'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, _) => const Image(
                        image: AssetImage('assets/images/placeholder.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 170,
                child: Text(
                  category['title'] ?? "Без названия",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isIcon)
                Positioned(
                  right: 0,
                  top: 0,
                  child: ValueListenableBuilder(
                      valueListenable: Hive.box('settings').listenable(),
                      builder: (_, __, ___) {
                        return IconButton(
                          onPressed: () async {
                            category['isFavorite'] == 'false'
                                ? 'true'
                                : 'false';
                            final categories = Hive.box('favorites')
                                    .get('likedCategories', defaultValue: [])
                                as List;
                            if (category['isFavorite'] == 'true') {
                              categories.insert(0, category);
                              await Hive.box('favorites')
                                  .put('likedCategories', categories);
                            } else {
                              categories.remove(category);
                              await Hive.box('favorites')
                                  .put('likedCategories', categories);
                            }
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: currentTheme.currentColor(),
                            size: 25,
                          ),
                        );
                      }),
                )
            ],
          ),
        ),
      ),
    );
  }
}
