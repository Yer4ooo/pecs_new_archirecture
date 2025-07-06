import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/features/stickers/data/models/sticker_model.dart';
import 'package:pecs_new_arch/injection_container.dart';

class StickersApiService {
  StickersApiService();
  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<List<StickerModel>> getStickers() =>
      _networkClient.getListData<StickerModel>(
        endpoint: 'api/stickers/',
        parser: (List<dynamic> data) {
          return data
              .where((item) => item != null)
              .map(
                  (item) => StickerModel.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );
}
