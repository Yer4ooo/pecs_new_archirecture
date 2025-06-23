import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pecs_new_arch/core/mixin/bloc_operations_mixin.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_respnse_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_global_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_response_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/create_category_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/create_image_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/get_categories_global_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/get_categories_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/get_category_images_usecase.dart';
import 'package:pecs_new_arch/injection_container.dart';

part 'library_event.dart';
part 'library_state.dart';
part 'library_bloc.freezed.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState>
    with BlocEventHandlerMixin<LibraryEvent, LibraryState> {
  LibraryBloc() : super(_Initial()) {
    final GetCategoriesUsecase _getCategoriesUsecase = sl();
    final GetCategoryImagesUsecase _getCategoryImagesUsecase = sl();
    final CreateCategoryUsecase _createCategoryUsecase = sl();
    final CreateImageUsecase _createImageUsecase = sl();
    final GetCategoriesGlobalUsecase _getCategoriesGlobalUsecase = sl();

    on<LibraryEvent>((events, emit) async {
      await events.map(
        getCategoriesGlobal: (GetCategoriesGlobal params) async =>
            await handleEvent<CategoriesGlobalModel?>(
          operation: () =>
              _getCategoriesGlobalUsecase.call(params: params.params),
          emit: emit,
          onLoading: () => const LibraryState.categoriesGlobalLoading(),
          onSuccess: (data) async => LibraryState.categoriesGlobalLoaded(data),
          onFailure: (error) async =>
              LibraryState.categoriesGlobalError(error.message),
        ),
        getCategories: (GetCategories params) async =>
            await handleEvent<CategoriesListModel?>(
          operation: () => _getCategoriesUsecase.call(params: params.params),
          emit: emit,
          onLoading: () => const LibraryState.categoriesLoading(),
          onSuccess: (data) async => LibraryState.categoriesLoaded(data),
          onFailure: (error) async =>
              LibraryState.categoriesError(error.message),
        ),
        getCategoryImagesById: (GetCategoryImagesById id) async =>
            await handleEvent<List<CategoriesImagesListModel>?>(
          operation: () => _getCategoryImagesUsecase.call(params: id.id),
          emit: emit,
          onLoading: () => const LibraryState.categoryImagesLoading(),
          onSuccess: (data) async => LibraryState.categoryImagesLoaded(data),
          onFailure: (error) async =>
              LibraryState.categoryImagesError(error.message),
        ),
        createCategory: (CreateCategory category) async =>
            await handleEvent<CategoriesCreateResponseModel>(
          operation: () =>
              _createCategoryUsecase.call(params: category.category),
          emit: emit,
          onLoading: () => const LibraryState.createCategoryLoading(),
          onSuccess: (data) async => LibraryState.createCategorySuccess(data),
          onFailure: (error) async =>
              LibraryState.createCategoryError(error.message),
        ),
        createImage: (CreateImage image) async =>
            await handleEvent<CategoriesImagesCreateResponseModel>(
          operation: () => _createImageUsecase.call(params: image.image),
          emit: emit,
          onLoading: () => const LibraryState.createImageLoading(),
          onSuccess: (data) async => LibraryState.createImageSuccess(data),
          onFailure: (error) async =>
              LibraryState.createImageError(error.message),
        ),
      );
    });
  }
}
