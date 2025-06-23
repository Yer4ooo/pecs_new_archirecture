part of 'parent_bloc.dart';

@freezed
class ParentEvent with _$ParentEvent {
  const factory ParentEvent.getChildrenList() = GetChildrenList;
}
