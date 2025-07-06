import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/stickers/data/models/sticker_model.dart';
import 'package:pecs_new_arch/features/stickers/domain/repository/stickers_repository.dart';
import '../../../../core/resources/data_state.dart';

class GetStickersUsecase
    implements UseCase<DataState<List<StickerModel>?>, int?> {
  final StickersRepository _stickersRepository;
  GetStickersUsecase(this._stickersRepository);

  @override
  Future<DataState<List<StickerModel>?>> call({params}) async {
    return await _stickersRepository.getStickers();
  }
}
