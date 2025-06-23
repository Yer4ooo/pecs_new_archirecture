import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pecs_new_arch/core/mixin/bloc_operations_mixin.dart';
import 'package:pecs_new_arch/features/parent/data/models/children_list_response_model_response.dart';
import 'package:pecs_new_arch/features/parent/domain/usecases/get_children_list_usecase.dart';
import 'package:pecs_new_arch/injection_container.dart';

part 'parent_event.dart';
part 'parent_state.dart';
part 'parent_bloc.freezed.dart';

class ParentBloc extends Bloc<ParentEvent, ParentState>
    with BlocEventHandlerMixin<ParentEvent, ParentState> {
  ParentBloc() : super(_Initial()) {
    final GetChildrenListUsecase _getChildrenListUsecase = sl();

    on<ParentEvent>((events, emit) async {
      await events.map(
        getChildrenList: (void _) async =>
            await handleEvent<ChildrenListResponseModel?>(
          operation: () => _getChildrenListUsecase.call(),
          emit: emit,
          onLoading: () => const ParentState.childrenListLoading(),
          onSuccess: (data) async => ParentState.childrenListLoaded(data),
          onFailure: (error) async =>
              ParentState.childrenListError(error.message),
        ),
      );
    });
  }
}
