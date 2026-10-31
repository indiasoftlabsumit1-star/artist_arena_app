
import 'dart:io';

import 'package:get/get.dart';

import '../Service/apiException.dart';

class Errorhandel {
  void showApiError(String action, Object error) {
    String title = 'Error';
    String message = 'Unable to $action. Please try again.';

    if (error is SocketException) {
      title = 'No Internet';
      message = 'Please check your internet connection.';
    } else if (error is HttpException) {
      title = 'Network Error';
      message = 'Unable to connect to the server.';
    } else if (error is FormatException) {
      title = 'Data Error';
      message = 'Invalid response received from server.';
    }


    else if (error.toString().contains('SocketException') ||
        error.toString().contains('Failed host lookup')) {
      title = 'No Internet';
      message = 'Please check your internet connection.';
    }

    else if (error is ApiException) {
      title = 'API Error';

      switch (error.statusCode) {
        case 400:
          title = 'Bad Request';
          message = error.message;
          break;

        case 401:
          title = 'Session Expired';
          message = 'Please login again.';
          break;

        case 403:
          title = 'Access Denied';
          message = 'You do not have permission to perform this action.';
          break;

        case 404:
          title = 'Not Found';
          message = 'The requested data was not found.';
          break;

        case 422:
          title = 'Validation Error';
          message = error.message;
          break;

        case 500:
          title = 'Server Error';
          message = 'Something went wrong on the server.';
          break;

        case 503:
          title = 'Service Unavailable';
          message = 'Server is temporarily unavailable. Please try again later.';
          break;

        default:
          message = error.message;
      }
    }
    else {
      final errorMessage = error.toString()
          .replaceFirst('Exception: ', '')
          .trim();

      if (errorMessage.isNotEmpty) {
        message = errorMessage;
      }
    }

    Get.snackbar(
      title,
      message,
      // snackPosition: SnackPosition.BOTTOM,
    );

    print('$action failed: $error');
  }
}
