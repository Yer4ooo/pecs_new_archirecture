import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/tts_play_request_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';

import '../../../../core/resources/data_state.dart';

class PlayTtsUsecase
    implements UseCase<DataState<dynamic>, TtsPlayRequestModel?> {
  final BoardRepository _boardRepository;
  PlayTtsUsecase(this._boardRepository);

  @override
  Future<DataState<dynamic>> call({params}) async {
    return await _boardRepository.playTts(tts: params);
  }
}
