import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_response_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_global_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_response_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/injection_container.dart';

class LibraryApiService {
  LibraryApiService();
  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<CategoriesListModel?> getCategories({Map<String, dynamic>? params}) =>
      _networkClient.getData<CategoriesListModel>(
          endpoint: 'categories',
          queryParams: params,
          parser: (response) => CategoriesListModel.fromJson(response));

  Future<List<CategoriesImagesListModel>?> getCategoryImagesbyId(
          {required int? id, Map<String, dynamic>? params}) {
   return _networkClient.getData<List<CategoriesImagesListModel>>(
       endpoint: 'categories/$id/images',
       queryParams: params,
       parser: (response) =>
           CategoriesImagesListModel.fromList(response['items']));
  }

  Future<CategoriesCreateResponseModel?> createCategory(
          {CategoriesCreateRequestModel? category}) async =>
      _networkClient.postData<CategoriesCreateResponseModel>(
          endpoint: 'categories/',
          body: await category?.toFormData(),
          parser: (response) =>
              CategoriesCreateResponseModel.fromJson(response));

  Future<CategoriesImagesCreateResponseModel?> createImage(
          {CategoriesImagesCreateRequestModel? image}) =>
      _networkClient.postData<CategoriesImagesCreateResponseModel>(
          endpoint: 'categories/${image!.id}/images',
          body: image,
          parser: (response) =>
              CategoriesImagesCreateResponseModel.fromJson(response));
  Future<CategoriesGlobalModel?> getCategoriesGlobal({
    Map<String, dynamic>? params,
  }) async {
    return _networkClient.getData(
      endpoint: 'categories/global',
      queryParams: params,
      parser: (response) {
        return CategoriesGlobalModel.fromJson(response);
      },
    );
  }
}
