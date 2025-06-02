import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pecs_new_arch/core/network/api_endpoints.dart';
import 'package:pecs_new_arch/core/network/custom_exceptions.dart';


// Services
import './dio_service.dart';

/// A base class containing methods for basic API functionality.
///
/// Should be implemented by any service class that wishes to interact
/// with an API.
abstract class NetworkClientInterface {
  /// Abstract const constructor. This constructor enables subclasses
  /// to provide const constructors so that they can be used in
  /// const expressions.
  const NetworkClientInterface();

  /// Base method for requesting a document of data from the [endpoint].
  ///
  /// The response is deserialized into a single model objects of type [T],
  /// using the [parser] callback.
  ///
  /// [queryParams] holds any query parameters for the request.
  ///
  /// [cancelToken] is used to cancel the request pre-maturely. If null,
  /// the **default** [cancelToken] inside [DioService] is used.
  ///
  /// [requiresAuthToken] is used to decide if a token will be inserted
  /// in the **headers** of the request using an [ApiInterceptor]
  Future<T> getData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> responseBody) parser,
  });

  /// An implementation of the base method for requesting collection of data
  /// from the [endpoint].
  /// The response body must be a [List], else the [converter] fails.
  ///
  /// The [converter] callback is used to **deserialize** the response body
  /// into a [List] of objects of type [T].
  /// The callback is executed on each member of the response `body` List.
  /// [T] is usually set to a `Model`.
  ///
  /// [queryParams] holds any query parameters for the request.
  ///
  /// [cancelToken] is used to cancel the request pre-maturely. If null,
  /// the **default** [cancelToken] inside [DioService] is used.
  ///
  /// [requiresAuthToken] is used to decide if a token will be inserted
  /// in the **headers** of the request using an [ApiInterceptor].
  /// The default value is `true`.
  Future<List<T>> getListData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required List<T> Function(List<dynamic> responseBody) parser,
  });

  /// Base method for inserting [body] at the [endpoint].
  ///
  /// The [body] contains body for the request.
  ///
  /// The response is deserialized into an object of type [T],
  /// using the [parser] callback.
  ///
  /// [cancelToken] is used to cancel the request pre-maturely. If null,
  /// the **default** [cancelToken] inside [DioService] is used.
  ///
  /// [requiresAuthToken] is used to decide if a token will be inserted
  /// in the **headers** of the request using an [ApiInterceptor]
  Future<T?> postData<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response) parser,
  });

  /// Base method for updating [data] at the [endpoint].
  ///
  /// The response is deserialized into an object of type [T],
  /// using the [parser] callback.
  ///
  /// The [data] contains body for the request.
  ///
  /// [cancelToken] is used to cancel the request pre-maturely. If null,
  /// the **default** [cancelToken] inside [DioService] is used.
  ///
  /// [requiresAuthToken] is used to decide if a token will be inserted
  /// in the **headers** of the request using an [ApiInterceptor]
  Future<T?> updateData<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response) parser,
  });

  /// Base method for deleting [data] at the [endpoint].
  ///
  /// The response is deserialized into an object of type [T],
  /// using the [parser] callback.
  ///
  /// The [data] contains body for the request.
  ///
  /// [cancelToken] is used to cancel the request pre-maturely. If null,
  /// the **default** [cancelToken] inside [DioService] is used.
  ///
  /// [requiresAuthToken] is used to decide if a token will be inserted
  /// in the **headers** of the request using an [ApiInterceptor]
  Future<T?> deleteData<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response)? parser,
  });

  /// Base method for cancelling requests pre-maturely
  /// using the [cancelToken].
  ///
  /// If null, the **default** [cancelToken] inside [DioService] is used.
  void cancelRequests({CancelToken? cancelToken});
}

class NetworkClient implements NetworkClientInterface {
  late final DioService _dioService;
  NetworkClient(DioService dioService) : _dioService = dioService;

  @override
  Future<T> getData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    CachePolicy? cachePolicy,
    int? cacheAgeDays,
    bool requiresAuthToken = true,
    required T Function(Map<String, dynamic> response) parser,
  }) async {
    Map<String, dynamic> data;
    try {
      Map<String, dynamic> extra = {};
      final response = await _dioService.get<Map<String, dynamic>>(
        endpoint: ApiEndpoint.baseUrl + endpoint,
        queryParams: queryParams,
        cacheOptions: _dioService.globalCacheOptions?.copyWith(
          policy: cachePolicy,
          maxStale: cacheAgeDays != null ? Duration(days: cacheAgeDays) : null,
        ),
        options: Options(extra: extra),
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

    // deserialize the response
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

  @override
  Future<T?>  postData<T>({
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
      final response = await _dioService.post(
        endpoint: (baseurl ?? ApiEndpoint.baseUrl) + endpoint,
        data: body,
        options: Options(extra: extra, responseType: ResponseType.json),
        cancelToken: cancelToken,
      );

      if (parser == null) {
        // если парсер НЕ передан и запрос прошел успешно, то возвращаем null
        return null;
      } else if (response.data == null) {
        // если парсер передан и запрос прошел успешно, но данные не пришли, то кидаем CustomException
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
        message: 'Failed to parse network response to model or vice versa for "${T.toString()}" model',
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

      final response = await _dioService.put(
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
