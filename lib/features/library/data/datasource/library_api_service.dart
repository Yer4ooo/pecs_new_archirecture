import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_respnse_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_response_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/injection_container.dart';

class LibraryApiService {
  LibraryApiService();
  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<List<CateoriesListModel>?> getCategories() => _networkClient.getData<List<CateoriesListModel>>(
        endpoint: 'categories',
        parser: (response) =>CateoriesListModel.fromList(response['categories'])
      );
       Future<List<CateoriesImagesListModel>?> getCategoryImagesbyId({required int? id}) => _networkClient.getData<List<CateoriesImagesListModel>>(
        endpoint: 'categories/$id/images',
        parser: (response) =>CateoriesImagesListModel.fromList(response['images'])
      );
      Future<CateoriesCreateResponseModel?> createCategory({CategoriesCreateRequestModel? category}) => _networkClient.postData<CateoriesCreateResponseModel>
      (endpoint: 'categories',
       body: category, parser: (response) =>CateoriesCreateResponseModel.fromJson(response));

       Future<CateoriesImagesCreateResponseModel?> createImage({CateoriesImagesCreateRequestModel? image}) => _networkClient.postData<CateoriesImagesCreateResponseModel>
      (endpoint: 'categories/${image!.id}/images',
       body: image, parser: (response) =>CateoriesImagesCreateResponseModel.fromJson(response));
      
      
      

}