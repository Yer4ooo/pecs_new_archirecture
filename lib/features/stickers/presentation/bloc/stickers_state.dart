part of 'stickers_bloc.dart';

@freezed
class StickersState with _$StickersState {
  const factory StickersState.initial() = _Initial;
  const factory StickersState.stickersLoading() = StickersLoading;
  const factory StickersState.stickersLoaded(List<StickerModel>? stickers) =
      StickersLoaded;
  const factory StickersState.stickersError(String message) = StickersError;
}
