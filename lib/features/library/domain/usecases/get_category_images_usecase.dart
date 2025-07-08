import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/domain/repository/library_repository.dart';
import '../../../../core/usecase/usecase.dart';

// Parameters class to handle both id and additional params
class GetCategoryImagesParams {
  final int? id;
  final Map<String, dynamic>? additionalParams;

  GetCategoryImagesParams({
    required this.id,
    this.additionalParams,
  });
}

class GetCategoryImagesUsecase
    implements UseCase<DataState<List<CategoriesImagesListModel>?>, GetCategoryImagesParams> {
  final LibraryRepository _libraryRepository;

  GetCategoryImagesUsecase(this._libraryRepository);

  @override
  Future<DataState<List<CategoriesImagesListModel>?>> call({GetCategoryImagesParams? params}) async {
    if (params == null) {
      throw ArgumentError('GetCategoryImagesParams cannot be null');
    }

    return await _libraryRepository.getCategoryImagesById(
      id: params.id,
      params: params.additionalParams,
    );
  }
}