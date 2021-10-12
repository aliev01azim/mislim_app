import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/helper/picker.dart';
import 'package:aidar_zakaz/widgets/snackbar.dart';
import 'package:aidar_zakaz/widgets/textinput_dialog.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'tab_screen.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String downloadPath = Hive.box('settings')
      .get('downloadPath', defaultValue: '/storage/emulated/0/Music') as String;
  String canvasColor = Hive.box('settings')
      .get('canvasColor', defaultValue: 'Темно-синий') as String;
  String themeColor =
      Hive.box('settings').get('themeColor', defaultValue: 'Default') as String;
  int colorHue = Hive.box('settings').get('colorHue', defaultValue: 400) as int;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          elevation: 0,
          stretch: true,
          pinned: false,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor.withOpacity(0.6)
              : null,
          expandedHeight: MediaQuery.of(context).size.height / 4.5,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(
                  Rect.fromLTRB(0, 0, rect.width, rect.height),
                );
              },
              blendMode: BlendMode.dstIn,
              child: const Center(
                child: Text(
                  'НАСТРОЙКИ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Text(
                'Темы',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
              child: Column(
                children: [
                  BoxSwitchTile(
                      title: const Text('Темный режим'),
                      keyName: 'darkMode',
                      defaultValue: true,
                      onChanged: (bool val) {
                        currentTheme.switchTheme(isDark: val);
                        themeColor = val ? 'Default' : 'Light Blue';
                        colorHue = 400;
                      }),
                  ListTile(
                    title: const Text('Цвет акцента'),
                    subtitle: Text('$themeColor, $colorHue'),
                    trailing: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Theme.of(context).accentColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[900]!,
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 3.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          const List<String> colors = [
                            'Красный',
                            'Янтарный',
                            'Синий',
                            'Голубой',
                            'Насыщенный Оранжевый',
                            'Темно-фиолетовый',
                            'Индиго',
                            'Светло-Голубой',
                            'Светло-Зеленый',
                            'Лайм',
                            'Оранжевый',
                            'Розовый',
                            'Фиолетовый',
                            'Зеленый',
                            'Желтый',
                          ];
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            itemCount: colors.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (int hue in [100, 200, 400, 700])
                                      GestureDetector(
                                        onTap: () {
                                          themeColor = colors[index];
                                          colorHue = hue;
                                          currentTheme.switchColor(
                                              colors[index], colorHue);

                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.125,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.125,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: currentTheme.getColor(
                                                colors[index], hue),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[900]!,
                                                blurRadius: 5.0,
                                                offset: const Offset(0.0, 3.0),
                                              )
                                            ],
                                          ),
                                          child: (themeColor == colors[index] &&
                                                  colorHue == hue)
                                              ? const Icon(Icons.done_rounded)
                                              : const SizedBox(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    dense: true,
                  ),
                  Visibility(
                    visible: Theme.of(context).brightness == Brightness.dark,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Фон'),
                          subtitle: const Text('Фоновый цвет'),
                          onTap: () {},
                          trailing: DropdownButton(
                            value: canvasColor,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                currentTheme.switchCanvasColor(newValue);
                                canvasColor = newValue;
                                // RestartWidget.of(context).restartApp();
                              }
                            },
                            items: <String>['Темно-синий', 'Черный']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          dense: true,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                      title: const Text('Изменить по умолчанию'),
                      dense: true,
                      onTap: () {
                        Hive.box('settings').put('darkMode', true);

                        currentTheme.switchCanvasColor('Темно-синий');
                        canvasColor = 'Темно-синий';

                        themeColor = 'Default';
                        colorHue = 400;
                        currentTheme.switchTheme(isDark: true);
                        // RestartWidget.of(context).restartApp();
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                'Воспроизведение',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
              child: Column(
                children: const [
                  BoxSwitchTile(
                    title: Text('Натройки повтора'),
                    subtitle: Text(
                        'Сохранять один и тот же параметр повтора для каждого сеанса'),
                    keyName: 'enforceRepeat',
                    defaultValue: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                'Загрузка',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
              child: ListTile(
                title: const Text('Место загрузки'),
                subtitle: Text(downloadPath),
                trailing: TextButton(
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey[700],
                  ),
                  onPressed: () async {
                    downloadPath =
                        await ExtStorage.getExternalStoragePublicDirectory(
                                ExtStorage.DIRECTORY_MUSIC) ??
                            '/storage/emulated/0/Music';
                    Hive.box('settings').put('downloadPath', downloadPath);
                    setState(() {});
                  },
                  child: const Text('Сброс'),
                ),
                onTap: () async {
                  final String temp = await Picker()
                      .selectFolder(context, 'Select Download Location');
                  if (temp.trim() != '') {
                    downloadPath = temp;
                    Hive.box('settings').put('downloadPath', temp);
                    setState(() {});
                  } else {
                    ShowSnackBar().showSnackBar(
                      'Папка не выбрана',
                    );
                  }
                },
                dense: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                'Другое',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
              child: Column(children: [
                ListTile(
                    title: const Text(
                        'Минимальная продолжительность аудио для поиска музыки'),
                    subtitle: const Text(
                        'Файлы с продолжительностью меньше этой не будут отображаться в разделе "Моя музыка"'),
                    dense: true,
                    onTap: () {
                      TextInputDialog().showTextInputDialog(
                          context,
                          'Минимум (в сек)',
                          (Hive.box('settings')
                                  .get('minDuration', defaultValue: 10) as int)
                              .toString(),
                          TextInputType.number, (String value) {
                        if (value.trim() == '') {
                          value = '0';
                        }
                        Hive.box('settings')
                            .put('minDuration', int.parse(value));
                        Navigator.pop(context);
                      });
                    }),
                BoxSwitchTile(
                    title: const Text(
                        'Показывать последние лекции на главном экране'),
                    subtitle: const Text('Default: On'),
                    keyName: 'showRecent',
                    defaultValue: true,
                    onChanged: (val) {
                      // RestartWidget.of(context).restartApp();
                    }),
                const BoxSwitchTile(
                  title: Text('Показывать историю поисков на поисковом экране'),
                  subtitle: Text('Показать историю поиска под строкой поиска'),
                  keyName: 'showHistory',
                  defaultValue: true,
                ),
                const BoxSwitchTile(
                  title: Text('Останавливать аудио при закрытии приложения'),
                  subtitle: Text(
                      "При выключении музыка не остановится даже после закрытия приложения, пока вы не нажмете кнопку Стоп\nПо умолчанию: вкл\n"),
                  isThreeLine: true,
                  keyName: 'stopForegroundService',
                  defaultValue: true,
                ),
                const BoxSwitchTile(
                  title: Text('Автоматическая проверка наличия обновлений'),
                  subtitle: Text(
                      'Если вы загружаете "Исламские Лекции" из любого репозитория программного обеспечения, такого как "F-Droid", "Izzyondroid" и т. д., Отключите это.'),
                  keyName: 'checkUpdate',
                  isThreeLine: true,
                  defaultValue: false,
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                'About',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(5, 30, 5, 20),
              child: Center(
                child: Text(
                  'Made with ♥ by Ankit Sangwan',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class BoxSwitchTile extends StatelessWidget {
  const BoxSwitchTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.keyName,
    required this.defaultValue,
    this.isThreeLine,
    this.onChanged,
  }) : super(key: key);

  final Text title;
  final Text? subtitle;
  final String keyName;
  final bool defaultValue;
  final bool? isThreeLine;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        activeColor: Theme.of(context).accentColor,
        title: title,
        subtitle: subtitle,
        isThreeLine: isThreeLine ?? false,
        dense: true,
        value: Hive.box('settings').get(keyName, defaultValue: defaultValue)
            as bool,
        onChanged: (val) {
          Hive.box('settings').put(keyName, val);
          if (onChanged != null) {
            onChanged!(val);
          }
        });
  }
}
