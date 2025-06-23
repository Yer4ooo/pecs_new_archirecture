import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_global_model.dart';
import 'package:pecs_new_arch/features/library/domain/repository/library_repository.dart';

class GetCategoriesGlobalUsecase
    implements
        UseCase<DataState<CategoriesGlobalModel?>, Map<String, dynamic>?> {
  final LibraryRepository _libraryRepository;

  GetCategoriesGlobalUsecase(this._libraryRepository);

  @override
  Future<DataState<CategoriesGlobalModel?>> call({params}) async {
    return await _libraryRepository.getCategoriesGlobal(params: params);
  }
}
