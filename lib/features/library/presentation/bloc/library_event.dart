part of 'library_bloc.dart';

@freezed
class LibraryEvent with _$LibraryEvent {
  const factory LibraryEvent.getCategories({Map<String, dynamic>? params}) =
      GetCategories;
  const factory LibraryEvent.getCategoryImagesById({int? id, Map<String, dynamic>? params}) =
      GetCategoryImagesById;
  const factory LibraryEvent.createCategory(
      {CategoriesCreateRequestModel? category}) = CreateCategory;
  const factory LibraryEvent.createImage(
      {CategoriesImagesCreateRequestModel? image}) = CreateImage;
  const factory LibraryEvent.getCategoriesGlobal(
      {Map<String, dynamic>? params}) = GetCategoriesGlobal;
}
