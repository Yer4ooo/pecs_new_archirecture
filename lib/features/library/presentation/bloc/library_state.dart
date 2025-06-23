part of 'library_bloc.dart';

@freezed
class LibraryState with _$LibraryState {
  const factory LibraryState.initial() = _Initial;
  // States for GetCategories
  const factory LibraryState.categoriesLoading() = CategoriesLoading;
  const factory LibraryState.categoriesLoaded(CategoriesListModel? categories) =
      CategoriesLoaded;
  const factory LibraryState.categoriesError(String message) = CategoriesError;

  // States for GetCategoryImagesById
  const factory LibraryState.categoryImagesLoading() = CategoryImagesLoading;
  const factory LibraryState.categoryImagesLoaded(
      List<CategoriesImagesListModel>? images) = CategoryImagesLoaded;
  const factory LibraryState.categoryImagesError(String message) =
      CategoryImagesError;

  // States for CreateCategory
  const factory LibraryState.createCategoryLoading() = CreateCategoryLoading;
  const factory LibraryState.createCategorySuccess(
      CategoriesCreateResponseModel category) = CreateCategorySuccess;
  const factory LibraryState.createCategoryError(String message) =
      CreateCategoryError;

  // States for CreateImage
  const factory LibraryState.createImageLoading() = CreateImageLoading;
  const factory LibraryState.createImageSuccess(
      CategoriesImagesCreateResponseModel image) = CreateImageSuccess;
  const factory LibraryState.createImageError(String message) =
      CreateImageError;

  const factory LibraryState.categoriesGlobalLoading() =
      CategoriesGlobalLoading;
  const factory LibraryState.categoriesGlobalLoaded(
      CategoriesGlobalModel? category) = CategoriesGlobalLoaded;
  const factory LibraryState.categoriesGlobalError(String message) =
      CategoriesGlobalError;
}
