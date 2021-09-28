import 'package:aidar_zakaz/utils/theme.dart';
import 'package:aidar_zakaz/widgets/textinput_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? appVersion;
  Box settingsBox = Hive.box('settings');
  String downloadPath = Hive.box('settings')
      .get('downloadPath', defaultValue: '/storage/emulated/0/Music') as String;

  String canvasColor =
      Hive.box('settings').get('canvasColor', defaultValue: 'Grey') as String;
  String cardColor =
      Hive.box('settings').get('cardColor', defaultValue: 'Grey850') as String;
  String themeColor =
      Hive.box('settings').get('themeColor', defaultValue: 'Teal') as String;
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
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: const Center(
                child: Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 80,
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
                'Theme',
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
                      title: const Text('Dark Mode'),
                      keyName: 'darkMode',
                      defaultValue: true,
                      onChanged: (bool val) {
                        currentTheme.switchTheme(isDark: val);
                        themeColor = val ? 'Teal' : 'Light Blue';
                        colorHue = 400;
                        RestartWidget.of(context).restartApp();
                        setState(() {});
                      }),
                  ListTile(
                    title: const Text('Accent Color & Hue'),
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
                          final List<String> colors = [
                            'Amber',
                            'Blue',
                            'Cyan',
                            'Deep Orange',
                            'Deep Purple',
                            'Green',
                            'Indigo',
                            'Light Blue',
                            'Light Green',
                            'Lime',
                            'Orange',
                            'Pink',
                            'Purple',
                            'Red',
                            'Teal',
                            'Yellow',
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
                                          RestartWidget.of(context)
                                              .restartApp();
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
                                            color: MyTheme()
                                                .getColor(colors[index], hue),
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
                          title: const Text('Background Gradient'),
                          subtitle: const Text(
                              'Gradient used as background everywhere'),
                          trailing: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                color: Theme.of(context).accentColor,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Theme.of(context).canvasColor,
                                  ],
                                ),
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
                                final List<List<Color>> gradients =
                                    currentTheme.backOpt;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    itemCount: gradients.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              settingsBox.put(
                                                  'backGrad', index);
                                              currentTheme.backGrad = index;

                                              RestartWidget.of(context)
                                                  .restartApp();
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
                                                      BorderRadius.circular(
                                                          100.0),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: gradients[index],
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[900]!,
                                                      blurRadius: 5.0,
                                                      offset: const Offset(
                                                          0.0, 3.0),
                                                    )
                                                  ],
                                                ),
                                                child: const Icon(
                                                    Icons.done_rounded))),
                                      );
                                    });
                              },
                            );
                          },
                          dense: true,
                        ),
                        ListTile(
                          title: const Text('Card Gradient'),
                          subtitle: const Text('Gradient used in Cards'),
                          trailing: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                color: Theme.of(context).accentColor,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? currentTheme.getCardGradient()
                                      : [
                                          Colors.white,
                                          Theme.of(context).canvasColor,
                                        ],
                                ),
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
                                final List<List<Color>> gradients =
                                    currentTheme.cardOpt;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    itemCount: gradients.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              settingsBox.put(
                                                  'cardGrad', index);
                                              currentTheme.cardGrad = index;

                                              RestartWidget.of(context)
                                                  .restartApp();
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
                                                    BorderRadius.circular(
                                                        100.0),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: gradients[index],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey[900]!,
                                                    blurRadius: 5.0,
                                                    offset:
                                                        const Offset(0.0, 3.0),
                                                  )
                                                ],
                                              ),
                                              child: (currentTheme
                                                          .getCardGradient() ==
                                                      gradients[index])
                                                  ? const Icon(
                                                      Icons.done_rounded)
                                                  : const SizedBox(),
                                            )),
                                      );
                                    });
                              },
                            );
                          },
                          dense: true,
                        ),
                        ListTile(
                          title: const Text('Bottom Sheets Gradient'),
                          subtitle:
                              const Text('Gradient used in Bottom Sheets'),
                          trailing: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                color: Theme.of(context).accentColor,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? currentTheme.getBottomGradient()
                                      : [
                                          Colors.white,
                                          Theme.of(context).canvasColor,
                                        ],
                                ),
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
                                final List<List<Color>> gradients =
                                    currentTheme.backOpt;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    itemCount: gradients.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              settingsBox.put(
                                                  'bottomGrad', index);
                                              currentTheme.bottomGrad = index;
                                              Navigator.pop(context);
                                              RestartWidget.of(context)
                                                  .restartApp();
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
                                                    BorderRadius.circular(
                                                        100.0),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: gradients[index],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey[900]!,
                                                    blurRadius: 5.0,
                                                    offset:
                                                        const Offset(0.0, 3.0),
                                                  )
                                                ],
                                              ),
                                              child: (currentTheme
                                                          .getBottomGradient() ==
                                                      gradients[index])
                                                  ? const Icon(
                                                      Icons.done_rounded)
                                                  : const SizedBox(),
                                            )),
                                      );
                                    });
                              },
                            );
                          },
                          dense: true,
                        ),
                        ListTile(
                          title: const Text('Canvas Color'),
                          subtitle: const Text('Color of Background Canvas'),
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
                                RestartWidget.of(context).restartApp();
                              }
                            },
                            items: <String>['Grey', 'Black']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          dense: true,
                        ),
                        ListTile(
                          title: const Text('Card Color'),
                          subtitle: const Text(
                              'Color of Search Bar, Alert Dialogs, Cards'),
                          onTap: () {},
                          trailing: DropdownButton(
                            value: cardColor,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                currentTheme.switchCardColor(newValue);
                                cardColor = newValue;
                                RestartWidget.of(context).restartApp();
                              }
                            },
                            items: <String>[
                              'Grey800',
                              'Grey850',
                              'Grey900',
                              'Black'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                      title: const Text('Change to Default'),
                      dense: true,
                      onTap: () {
                        Hive.box('settings').put('darkMode', true);

                        settingsBox.put('backGrad', 1);
                        currentTheme.backGrad = 1;
                        settingsBox.put('cardGrad', 3);
                        currentTheme.cardGrad = 3;
                        settingsBox.put('bottomGrad', 2);
                        currentTheme.bottomGrad = 2;

                        currentTheme.switchCanvasColor('Grey');
                        canvasColor = 'Grey';

                        currentTheme.switchCardColor('Grey850');
                        cardColor = 'Grey900';

                        themeColor = 'Teal';
                        colorHue = 400;
                        currentTheme.switchTheme(isDark: true);
                        RestartWidget.of(context).restartApp();
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                'Music & Playback',
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
                    title: Text('Enforce Repeating'),
                    subtitle:
                        Text('Keep the same repeat option for every session'),
                    keyName: 'enforceRepeat',
                    defaultValue: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                'Download',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            const BoxSwitchTile(
              title: Text('Create different folder for YouTube Downloads'),
              subtitle: Text(
                  'Creates a different folder for Songs downloaded from YouTube'),
              keyName: 'createYoutubeFolder',
              isThreeLine: true,
              defaultValue: false,
            ),
            const BoxSwitchTile(
              title: Text('Download Lyrics'),
              subtitle: Text('Default: Off'),
              keyName: 'downloadLyrics',
              defaultValue: false,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                'Others',
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
                    title: const Text('Min Audio Length to search music'),
                    subtitle: const Text(
                        'Files with audio length smaller than this will not be shown in "My Music" Section'),
                    dense: true,
                    onTap: () {
                      TextInputDialog().showTextInputDialog(
                          context,
                          'Min Audio Length (in sec)',
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
                const BoxSwitchTile(
                  title: Text('Support Equalizer'),
                  subtitle: Text(
                      'Turn this off if you are unable to play songs (in both online and offline mode)'),
                  keyName: 'supportEq',
                  isThreeLine: true,
                  defaultValue: true,
                ),
                BoxSwitchTile(
                    title: const Text('Show Last Session on Home Screen'),
                    subtitle: const Text('Default: On'),
                    keyName: 'showRecent',
                    defaultValue: true,
                    onChanged: (val) {
                      RestartWidget.of(context).restartApp();
                    }),
                const BoxSwitchTile(
                  title: Text('Show Search History'),
                  subtitle: Text('Show Search History below Search Bar'),
                  keyName: 'showHistory',
                  defaultValue: true,
                ),
                const BoxSwitchTile(
                  title: Text('Stop music on App Close'),
                  subtitle: Text(
                      "If turned off, music won't stop even after app close until you press stop button\nDefault: On\n"),
                  isThreeLine: true,
                  keyName: 'stopForegroundService',
                  defaultValue: true,
                ),
                const BoxSwitchTile(
                  title: Text('Auto check for Updates'),
                  subtitle: Text(
                      "If you download BlackHole from any software repository like 'F-Droid', 'IzzyOnDroid', etc keep this OFF. Whereas, If you download it from 'GitHub' or any other source which doesn't provide auto updates then turn this ON, so as to recieve update alerts"),
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
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (BuildContext context, Box box, Widget? widget) {
          return SwitchListTile(
              activeColor: Theme.of(context).accentColor,
              title: title,
              subtitle: subtitle,
              isThreeLine: isThreeLine ?? false,
              dense: true,
              value: box.get(keyName, defaultValue: defaultValue) as bool,
              onChanged: (val) {
                box.put(keyName, val);
                if (onChanged != null) {
                  onChanged!(val);
                }
              });
        });
  }
}
