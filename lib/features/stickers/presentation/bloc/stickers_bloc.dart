import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pecs_new_arch/core/mixin/bloc_operations_mixin.dart';
import 'package:pecs_new_arch/features/stickers/data/models/sticker_model.dart';
import 'package:pecs_new_arch/features/stickers/domain/usecases/get_stickers_usecase.dart';
import 'package:pecs_new_arch/injection_container.dart';
import 'package:bloc/bloc.dart';

part 'stickers_event.dart';
part 'stickers_state.dart';
part 'stickers_bloc.freezed.dart';

class StickersBloc extends Bloc<StickersEvent, StickersState>
    with BlocEventHandlerMixin<StickersEvent, StickersState> {
  StickersBloc() : super(_Initial()) {
    final GetStickersUsecase _getStickersUsecase = sl();

    on<StickersEvent>(
      (events, emit) async {
        await events.map(
            getStickers: (GetStickers stcikers) async => await handleEvent(
                  operation: () => _getStickersUsecase.call(),
                  emit: emit,
                  onLoading: () => const StickersState.stickersLoading(),
                  onSuccess: (data) async => StickersState.stickersLoaded(data),
                  onFailure: (error) async =>
                      StickersState.stickersError(error.message),
                ));
      },
    );
  }
}
