import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/stickers/data/models/sticker_model.dart';

abstract class StickersRepository {
  Future<DataState<List<StickerModel>>> getStickers();
}
