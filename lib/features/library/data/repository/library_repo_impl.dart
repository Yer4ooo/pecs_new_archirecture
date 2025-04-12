import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/library/data/datasource/library_api_service.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_respnse_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_response_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/features/library/domain/repository/library_repository.dart';

class LibraryRepoImpl implements LibraryRepository {
  final LibraryApiService _libraryApiService;

  LibraryRepoImpl(this._libraryApiService);

  @override
  Future<DataState<CateoriesCreateResponseModel>> createCategory({CategoriesCreateRequestModel? category}) async {
    try {
      var data = await _libraryApiService.createCategory(category: category);
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CateoriesImagesCreateResponseModel>> createImage({CateoriesImagesCreateRequestModel? image}) async {
    try {
      var data = await _libraryApiService.createImage(image: image);
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<CateoriesListModel>?>> getCategories() async {
        try {
      var data = await _libraryApiService.getCategories();
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<CateoriesImagesListModel>?>> getCategoryImagesById({int? id}) async {
           try {
      var data = await _libraryApiService.getCategoryImagesbyId(id: id);
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }


}
