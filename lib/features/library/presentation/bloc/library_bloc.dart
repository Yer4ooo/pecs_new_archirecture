import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pecs_new_arch/core/mixin/bloc_operations_mixin.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_respnse_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_request_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_create_response_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/create_category_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/create_image_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/get_categories_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/get_category_images_usecase.dart';
import 'package:pecs_new_arch/injection_container.dart';

part 'library_event.dart';
part 'library_state.dart';
part 'library_bloc.freezed.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> with BlocEventHandlerMixin<LibraryEvent, LibraryState> {
  LibraryBloc() : super(_Initial()) {
    final GetCategoriesUsecase _getCategoriesUsecase = sl();
    final GetCategoryImagesUsecase _getCategoryImagesUsecase = sl();
    final CreateCategoryUsecase _createCategoryUsecase = sl();
    final CreateImageUsecase _createImageUsecase = sl();

    on<LibraryEvent>((events, emit) async {
      await events.map(
        getCategories: (GetCategories params) async => await handleEvent<List<CateoriesListModel>?>(
          operation: () => _getCategoriesUsecase.call(),
          emit: emit,
          onLoading: () => const LibraryState.categoriesLoading(),
          onSuccess: (data) async => LibraryState.categoriesLoaded(data),
          onFailure: (error) async => LibraryState.categoriesError(error.message),
        ),
        getCategoryImagesById: (GetCategoryImagesById id) async => await handleEvent<List<CateoriesImagesListModel>?>(
          operation: () => _getCategoryImagesUsecase.call(params: id.id ),
          emit: emit,
          onLoading: () => const LibraryState.categoryImagesLoading(),
          onSuccess: (data) async => LibraryState.categoryImagesLoaded(data),
          onFailure: (error) async => LibraryState.categoryImagesError(error.message),
        ),
        createCategory: (CreateCategory category) async => await handleEvent<CateoriesCreateResponseModel>(
          operation: () => _createCategoryUsecase.call(params: category.category),
          emit: emit,
          onLoading: () => const LibraryState.createCategoryLoading(),
          onSuccess: (data) async => LibraryState.createCategorySuccess(data),
          onFailure: (error) async => LibraryState.createCategoryError(error.message),
        ),
        createImage: (CreateImage image) async => await handleEvent<CateoriesImagesCreateResponseModel>(
          operation: () => _createImageUsecase.call(params: image.image),
          emit: emit,
          onLoading: () => const LibraryState.createImageLoading(),
          onSuccess: (data) async => LibraryState.createImageSuccess(data),
          onFailure: (error) async => LibraryState.createImageError(error.message),
        ),
      );
    });
  }
}
