import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/domain/repository/library_repository.dart';

import '../../../../core/usecase/usecase.dart';

class GetCategoryImagesUsecase
    implements UseCase<DataState<List<CategoriesImagesListModel>?>, int?> {
  final LibraryRepository _libraryRepository;

  GetCategoryImagesUsecase(this._libraryRepository);

  @override
  Future<DataState<List<CategoriesImagesListModel>?>> call({params}) async {
    return await _libraryRepository.getCategoryImagesById(id: params);
  }
}
