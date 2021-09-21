import 'package:aidar_zakaz/helper/dialog_helper.dart';
import 'package:aidar_zakaz/services/app_exceptions.dart';
import 'package:just_audio/just_audio.dart';

class BaseController {
  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErroDialog(
          description: 'Oops! It took longer to respond.');
    } else if (error is Exception) {
      DialogHelper.showErroDialog(
          description: 'No audio source has been previously set.');
    } else if (error is PlayerException) {
      DialogHelper.showErroDialog(
          description: 'The audio source was unable to be loaded.');
    } else if (error is PlayerInterruptedException) {
      DialogHelper.showErroDialog(
          description:
              'Another audio source was loaded before this call completed or the player was stopped or disposed of before the call completed.');
    }
  }

  showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }
}
