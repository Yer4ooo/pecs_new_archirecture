import '../models/children_model_response.dart';

abstract class ChildrenState {}

class ChildrenInitial extends ChildrenState {}

class ChildrenLoading extends ChildrenState {}

class ChildrenSuccess extends ChildrenState {
  final ChildrenModel childrenData;

  ChildrenSuccess({required this.childrenData});
}

class ChildrenFailure extends ChildrenState {
  final String error;

  ChildrenFailure({required this.error});
}