import 'package:pecs_new_arch/features/library/data/models/categories_images_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_response_model.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/library_repository.dart';

class CreateImageUsecase
    implements
        UseCase<DataState<CategoriesImagesCreateResponseModel>,
            CategoriesImagesCreateRequestModel?> {
  final LibraryRepository _libraryRepository;

  CreateImageUsecase(this._libraryRepository);

  @override
  Future<DataState<CategoriesImagesCreateResponseModel>> call({params}) async {
    return await _libraryRepository.createImage(image: params);
  }
}
