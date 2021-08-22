import 'package:aidar_zakaz/bindings/poisk_screen_binding.dart';
import 'package:aidar_zakaz/screens/poisk_screen.dart';
import 'package:aidar_zakaz/widgets/look_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: TextField(
                onTap: () {
                  Get.to(() => const PoiskScreen(),
                      binding: PoiskScreenBinding());
                },
                decoration: InputDecoration(
                  hintText: 'Лекции, шейхи и категории',
                  hintStyle: const TextStyle(color: Colors.black, height: 1.3),
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white.withAlpha(235),
                  border: null,
                  enabledBorder: InputBorder.none,
                  disabledBorder: null,
                  errorBorder: null,
                  focusedBorder: InputBorder.none,
                ),
                readOnly: true,
                showCursor: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90, left: 15, right: 15),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                children: const [
                  LookGridItem('Коран и Тафсир'),
                  LookGridItem('Дуа'),
                  LookGridItem('Фикх'),
                  LookGridItem('Сунна Пророка'),
                  LookGridItem('Хадисы'),
                  LookGridItem('Акыда'),
                  LookGridItem('Жизнь Пророка'),
                  LookGridItem('Мудрость и Наставления'),
                  LookGridItem('Течения и секты'),
                  LookGridItem('История Ислама'),
                  LookGridItem('Оберегания человека'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
