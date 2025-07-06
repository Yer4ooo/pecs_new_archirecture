import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/stickers/data/datasource/stickers_api_service.dart';
import 'package:pecs_new_arch/features/stickers/data/models/sticker_model.dart';
import 'package:pecs_new_arch/features/stickers/domain/repository/stickers_repository.dart';

class StickersRepositoryImpl implements StickersRepository {
  final StickersApiService _stickersApiService;

  StickersRepositoryImpl(this._stickersApiService);

  @override
  Future<DataState<List<StickerModel>>> getStickers() async {
    try {
      var data = await _stickersApiService.getStickers();
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }
}
