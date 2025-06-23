import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/features/library/domain/repository/library_repository.dart';

class GetCategoriesUsecase
    implements UseCase<DataState<CategoriesListModel?>, Map<String, dynamic>?> {
  final LibraryRepository _libraryRepository;

  GetCategoriesUsecase(this._libraryRepository);

  @override
  Future<DataState<CategoriesListModel?>> call({params}) async {
    return await _libraryRepository.getCategories(params: params);
  }
}
