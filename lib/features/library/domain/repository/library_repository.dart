import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_respnse_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_response_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';

abstract class LibraryRepository {
  Future<DataState<List<CateoriesListModel>?>> getCategories();
  Future<DataState<List<CateoriesImagesListModel>?>> getCategoryImagesById({int? id});
    Future<DataState<CateoriesCreateResponseModel>> createCategory({CategoriesCreateRequestModel? category});
    Future<DataState<CateoriesImagesCreateResponseModel>> createImage({CateoriesImagesCreateRequestModel? image});

 
}
