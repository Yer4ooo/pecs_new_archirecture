import 'package:bloc/bloc.dart';
import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/resources/data_state.dart';

mixin BlocEventHandlerMixin<Event, State> on Bloc<Event, State> {
  Future<void> handleEvent<T>({
    required Future<DataState<T>> Function() operation,
    required Emitter<State> emit,
    required State Function() onLoading,
    required Future<State> Function(T data) onSuccess,
    required Future<State> Function(CustomException error) onFailure,
  }) async {
    emit(onLoading());
    final result = await operation();

    await result.when(
      success: (data) async => emit(await onSuccess(data)),
      failure: (error) async => emit(await onFailure(error)),
    );
  }
}

class SuccessState<T> {
  final T data;
  SuccessState(this.data);
}
