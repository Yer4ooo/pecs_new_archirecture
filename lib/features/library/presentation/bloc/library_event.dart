part of 'library_bloc.dart';

@freezed
class LibraryEvent with _$LibraryEvent {
  const factory LibraryEvent.getCategories() = GetCategories;
  const factory LibraryEvent.getCategoryImagesById({int? id}) = GetCategoryImagesById;
  const factory LibraryEvent.createCategory({CategoriesCreateRequestModel? category }) = CreateCategory;
  const factory LibraryEvent.createImage({CateoriesImagesCreateRequestModel? image }) = CreateImage;
}