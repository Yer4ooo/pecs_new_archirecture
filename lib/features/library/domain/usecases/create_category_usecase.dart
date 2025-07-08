import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_response_model.dart';
import 'package:pecs_new_arch/features/library/domain/repository/library_repository.dart';

import '../../../../core/usecase/usecase.dart';

class CreateCategoryUsecase
    implements
        UseCase<DataState<CategoriesCreateResponseModel>,
            CategoriesCreateRequestModel?> {
  final LibraryRepository _libraryRepository;

  CreateCategoryUsecase(this._libraryRepository);

  @override
  Future<DataState<CategoriesCreateResponseModel>> call({params}) async {
    return await _libraryRepository.createCategory(category: params);
  }
}
