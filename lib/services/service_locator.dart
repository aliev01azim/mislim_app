import 'package:aidar_zakaz/all_about_audio/services/audio_handler.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<AudioPlayerHandler>(await initAudioService());
}
