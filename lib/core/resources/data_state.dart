import 'dart:async';

import 'package:pecs_new_arch/core/network/custom_exceptions.dart';

abstract class DataState<T> {
  final T? data;
  final CustomException? error;

  const DataState({this.data, this.error});

  FutureOr<R> when<R>({
    required FutureOr<R> Function(T data) success,
    required FutureOr<R> Function(CustomException error) failure,
  }) {
    if (this is DataSuccess<T>) {
      return success((this as DataSuccess<T>).data as T);
    } else if (this is DataFailed<T>) {
      return failure((this as DataFailed<T>).error as CustomException);
    }
    throw AssertionError('Unhandled DataState: $this');
  }
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(CustomException error) : super(error: error);
}
