import 'package:dio/dio.dart';

/// An enum that holds names for our custom exceptions.
enum ExceptionType {
  /// The exception for an expired bearer token.
  tokenExpiredException,

  /// The exception for a prematurely cancelled request.
  cancelException,

  /// The exception for a failed connection attempt.
  connectTimeoutException,

  /// The exception for failing to send a request.
  sendTimeoutException,

  /// The exception for failing to receive a response.
  receiveTimeoutException,

  /// The exception for no internet connectivity.
  socketException,

  /// A better name for the socket exception.
  fetchDataException,

  /// The exception for an incorrect parameter in a request/response.
  formatException,

  /// The exception for an unknown type of failure.
  unrecognizedException,

  /// The exception for an unknown exception from the api.
  apiException,

  /// The exception for any parsing failure encountered during
  /// serialization/deserialization of a request.
  serializationException,

  /// Caused by an incorrect certificate as configured by [ValidateCertificate]. (from [dio_exception.dart])
  badSertificateException,

  /// Caused for example by a `xhr.onError` or SocketExceptions. (from [dio_exception.dart])
  connectionException,

  /// The [DioException] was caused by an incorrect status code as configured by
  /// [ValidateStatus].
  badResponseException
}

class CustomException implements Exception {
  final String name, message;
  final String? code;
  final int? statusCode;
  final ExceptionType exceptionType;

  CustomException({
    this.code,
    int? statusCode,
    required this.message,
    this.exceptionType = ExceptionType.apiException,
  })  : statusCode = statusCode ?? 500,
        name = exceptionType.name;

  factory CustomException.fromDioException(Exception error) {
    try {
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.badResponse:
            return CustomException(
              exceptionType: ExceptionType.badResponseException,
              statusCode: error.response?.statusCode,
              message: error.response?.data['message'] ??
                  'The DioException was caused by an incorrect status code as configured by ValidateStatus. ${error.response?.statusCode}',
            );
          case DioExceptionType.badCertificate:
            return CustomException(
              exceptionType: ExceptionType.badSertificateException,
              statusCode: error.response?.statusCode,
              message: 'Bad certificate',
            );
          case DioExceptionType.connectionError:
            return CustomException(
              exceptionType: ExceptionType.connectionException,
              statusCode: error.response?.statusCode,
              message: 'Caused for example by a `xhr.onError` or SocketExceptions.',
            );
          case DioExceptionType.cancel:
            return CustomException(
              exceptionType: ExceptionType.cancelException,
              statusCode: error.response?.statusCode,
              message: 'Request cancelled prematurely',
            );
          case DioExceptionType.connectionTimeout:
            return CustomException(
              exceptionType: ExceptionType.connectTimeoutException,
              statusCode: error.response?.statusCode,
              message: 'Connection not established',
            );
          case DioExceptionType.sendTimeout:
            return CustomException(
              exceptionType: ExceptionType.sendTimeoutException,
              statusCode: error.response?.statusCode,
              message: 'Failed to send',
            );
          case DioExceptionType.receiveTimeout:
            return CustomException(
              exceptionType: ExceptionType.receiveTimeoutException,
              statusCode: error.response?.statusCode,
              message: 'Failed to receive',
            );
          case DioExceptionType.unknown:
            if (error.message?.contains(ExceptionType.socketException.name) ?? false) {
              return CustomException(
                exceptionType: ExceptionType.fetchDataException,
                statusCode: error.response?.statusCode,
                message: 'No internet connectivity',
              );
            }
            if (error.response?.data['headers']['code'] == null) {
              return CustomException(
                exceptionType: ExceptionType.unrecognizedException,
                statusCode: error.response?.statusCode,
                message: error.response?.statusMessage ?? 'Unknown',
              );
            }
            final name = error.response?.data['headers']['code'] as String;
            final message = error.response?.data['headers']['message'] as String;
            if (name == ExceptionType.tokenExpiredException.name) {
              return CustomException(
                exceptionType: ExceptionType.tokenExpiredException,
                code: name,
                statusCode: error.response?.statusCode,
                message: message,
              );
            }
            return CustomException(
              message: message,
              code: name,
              statusCode: error.response?.statusCode,
            );
        }
      } else if (error is CustomException) {
        return error;
      } else {
        return CustomException(
          exceptionType: ExceptionType.unrecognizedException,
          message: 'Error unrecognized',
        );
      }
    } on FormatException catch (e) {
      return CustomException(
        exceptionType: ExceptionType.formatException,
        message: e.message,
      );
    } on Exception catch (_) {
      return CustomException(
        exceptionType: ExceptionType.unrecognizedException,
        message: 'Error unrecognized',
      );
    }
  }

  factory CustomException.fromParsingException(Exception error) {
    return CustomException(
      exceptionType: ExceptionType.serializationException,
      message: 'Failed to parse network response to model or vice versa',
    );
  }
}
