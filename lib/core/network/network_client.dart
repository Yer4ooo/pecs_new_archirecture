import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:pecs_new_arch/core/network/api_endpoints.dart';
import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';
import './dio_service.dart';

abstract class NetworkClientInterface {
  const NetworkClientInterface();

  Future<T> getData<T>({
    required String endpoint,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParams,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> responseBody) parser,
  });

  Future<List<T>> getListData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required List<T> Function(List<dynamic> responseBody) parser,
  });

  Future<T?> postData<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response) parser,
  });

  Future<T?> updateData<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response) parser,
  });

  Future<T?> postFormData<T>({
    required String endpoint,
    required FormData formData,
    CancelToken? cancelToken,
    bool requiresAuthToken,
    required T Function(Map<String, dynamic> response) parser,
  });

  Future<T?> deleteData<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response)? parser,
  });

  void cancelRequests({CancelToken? cancelToken});
}

class NetworkClient implements NetworkClientInterface {
  late final DioService _dioService;

  NetworkClient(DioService dioService) : _dioService = dioService;

  @override
  Future<T?> postFormData<T>({
    required String endpoint,
    required FormData formData,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response) parser,
  }) async {
    Map<String, dynamic> data;

    try {
      Map<String, dynamic> extra = {
        'requiresAuthToken': requiresAuthToken,
      };

      final response = await _dioService.post(
        endpoint: ApiEndpoint.baseUrl + endpoint,
        data: formData,
        options: Options(
          extra: extra,
          responseType: ResponseType.json,
          contentType: 'multipart/form-data',
        ),
        cancelToken: cancelToken,
      );

      if (response.data == null) {
        throw CustomException(
          exceptionType: ExceptionType.apiException,
          message: 'Response data is null',
        );
      }

      data = response.data!;
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return parser(data);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  @override
  Future<T> getData<T>({
    required String endpoint,
    CancelToken? cancelToken,
    CachePolicy? cachePolicy,
    Map<String, dynamic>? queryParams,
    int? cacheAgeDays,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response) parser,
  }) async {
    final locale = await GetIt.I<KeyValueStorageService>().getLocale() ?? 'en';
    Map<String, dynamic> data;
    try {
      Map<String, dynamic> extra = {
        'requiresAuthToken': requiresAuthToken,
      };

      final response = await _dioService.get<Map<String, dynamic>>(
        endpoint: ApiEndpoint.baseUrl + endpoint,
        queryParams: queryParams,
        cacheOptions: _dioService.globalCacheOptions?.copyWith(
          policy: cachePolicy,
          maxStale: cacheAgeDays != null ? Duration(days: cacheAgeDays) : null,
        ),
        options: Options(
          extra: extra,
          headers: {
            "Accept-Language": locale,
          },
        ),
        cancelToken: cancelToken,
      );

      if (response.data != null) {
        data = response.data!;
      } else {
        throw CustomException.fromDioException(
          Exception('Response data is null'),
        );
      }
    } on Exception catch (ex) {
      print(ex);
      throw CustomException.fromDioException(ex);
    }

    try {
      return parser(data);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }


  @override
  Future<List<T>> getListData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    CachePolicy? cachePolicy,
    int? cacheAgeDays,
    String? baseurl,
    bool requiresAuthToken = true,
    required List<T> Function(List<dynamic>) parser,
  }) async {
    final locale = await GetIt.I<KeyValueStorageService>().getLocale();
    List<dynamic> data;
    try {
      final response = await _dioService.get<List<dynamic>>(
        endpoint: (baseurl ?? ApiEndpoint.baseUrl) + endpoint,
        queryParams: queryParams,
        cacheOptions: _dioService.globalCacheOptions?.copyWith(
          policy: cachePolicy,
          maxStale: cacheAgeDays != null ? Duration(days: cacheAgeDays) : null,
        ),
        options: Options(
          headers: {"Accept-Language": locale},
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
        cancelToken: cancelToken,
      );

      if (response.data != null) {
        data = response.data!;
      } else {
        throw CustomException.fromDioException(
          Exception('Response data is null'),
        );
      }
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return parser(data);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  Future<Uint8List?> postTtsDataIsolated({
    required String endpoint,
    required Map<String, dynamic> body,
    CancelToken? cancelToken,
  }) async {
    try {
      final freshDio = Dio();
      final token = await GetIt.I<KeyValueStorageService>().getAccessToken();
      final response = await freshDio.post(
        ApiEndpoint.baseUrl + endpoint,
        data: body,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            "Accept-Language": body["voice_language"],
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          validateStatus: (status) => true,
        ),
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200) {
        if (response.data is Uint8List) {
          return response.data as Uint8List;
        } else {
          throw Exception(
              'Expected audio data but got ${response.data.runtimeType}');
        }
      } else {
        String errorMessage = 'TTS API Error: ${response.statusCode}';
        try {
          if (response.data is Uint8List) {
            final errorText = utf8.decode(response.data as Uint8List);
            try {
              final errorJson = json.decode(errorText);
              if (errorJson is Map<String, dynamic> &&
                  errorJson['message'] != null) {
                errorMessage = errorJson['message'];
              }
            } catch (e) {
              errorMessage = errorText;
            }
          }
        } catch (e) {}

        throw Exception(errorMessage);
      }
    } catch (error) {
      if (error is DioException) {
        throw Exception('TTS Network Error: ${error.type} - ${error.message}');
      } else {
        rethrow;
      }
    }
  }

  Future<T?> postData<T>({
    required String endpoint,
    required dynamic body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    String? baseurl,
    required T Function(Map<String, dynamic> response)? parser,
  }) async {
    Map<String, dynamic> data;

    try {
      Map<String, dynamic> extra = {};
      final isFormData = body is FormData;

      final response = await _dioService.post(
        endpoint: (baseurl ?? ApiEndpoint.baseUrl) + endpoint,
        data: body,
        options: Options(
          extra: extra,
          responseType: ResponseType.json,
          contentType: isFormData ? 'multipart/form-data' : 'application/json',
        ),
        cancelToken: cancelToken,
      );

      if (parser == null) {
        return null;
      } else if (response.data == null) {
        throw CustomException(
          exceptionType: ExceptionType.apiException,
          message: 'Response data is null',
        );
      } else {
        data = response.data!;
      }
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return parser(data);
    } catch (ex) {
      throw CustomException(
        exceptionType: ExceptionType.serializationException,
        message:
            'Failed to parse network response to model or vice versa for "${T.toString()}" model',
      );
    }
  }

  @override
  Future<T?> updateData<T>({
    required String endpoint,
    required dynamic body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response)? parser,
  }) async {
    Map<String, dynamic> data;

    try {
      Map<String, dynamic> extra = {};

      final response = await _dioService.patch(
        endpoint: ApiEndpoint.baseUrl + endpoint,
        data: body,
        options: Options(extra: extra),
        cancelToken: cancelToken,
      );

      if (parser == null) {
        // если парсер НЕ передан и запрос прошел успешно, то возвращаем null
        return null;
      } else if (response.data == null) {
        // если парсер передан и запрос прошел успешно, но данные не пришли, то кидаем CustomException
        throw CustomException.fromDioException(
          Exception('Response data is null'),
        );
      } else {
        data = response.data!;
      }
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return parser(data);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  @override
  Future<T?> deleteData<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response)? parser,
  }) async {
    Map<String, dynamic> data;

    try {
      Map<String, dynamic> extra = {};

      final response = await _dioService.delete(
        endpoint: ApiEndpoint.baseUrl + endpoint,
        data: body,
        options: Options(extra: extra),
        cancelToken: cancelToken,
      );

      if (parser == null) {
        // если парсер НЕ передан и запрос прошел успешно, то возвращаем null
        return null;
      } else if (response.data == null) {
        // если парсер передан и запрос прошел успешно, но данные не пришли, то кидаем CustomException
        throw CustomException.fromDioException(
          Exception('Response data is null'),
        );
      } else {
        data = response.data!;
      }
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return parser(data);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  @override
  void cancelRequests({CancelToken? cancelToken}) {
    _dioService.cancelRequests(cancelToken: cancelToken);
  }
}
