import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_respnse_model.dart';
import 'package:pecs_new_arch/features/library/domain/repository/library_repository.dart';

import '../../../../core/usecase/usecase.dart';

class CreateCategoryUsecase implements UseCase<DataState<CateoriesCreateResponseModel>, CategoriesCreateRequestModel?> {
  final LibraryRepository _libraryRepository;

  CreateCategoryUsecase(this._libraryRepository);

  @override
  Future<DataState<CateoriesCreateResponseModel>> call({params}) async {
    return await _libraryRepository.createCategory(category: params);
  }
}
