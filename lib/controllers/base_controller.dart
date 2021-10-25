import 'package:aidar_zakaz/helper/dialog_helper.dart';
import 'package:aidar_zakaz/services/app_exceptions.dart';
import 'package:just_audio/just_audio.dart';

class BaseController {
  void handleError(error) {
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErroDialog(
          description:
              'Для ответа сервера потребовалось больше времени! Попробуйте перезайти в приложение.');
    } else if (error is Exception) {
      DialogHelper.showErroDialog(
          description: 'Попробуйте перезайти в приложение.');
    } else if (error is PlayerException) {
      DialogHelper.showErroDialog(description: 'Не удалось загрузить аудио.');
    } else if (error is PlayerInterruptedException) {
      DialogHelper.showErroDialog(
          description:
              'Другое аудио было загружено до завершения этого вызова, или проигрыватель был остановлен или удален до завершения вызова.');
    }
  }
}
