part of 'parent_bloc.dart';

@freezed
class ParentState with _$ParentState {
  const factory ParentState.initial() = _Initial;
  const factory ParentState.childrenListLoading() = ChildrenListLoading;
  const factory ParentState.childrenListLoaded(
      ChildrenListResponseModel? childrenList) = ChildrenListLoaded;
  const factory ParentState.childrenListError(String message) =
      ChildrenListError;
}
