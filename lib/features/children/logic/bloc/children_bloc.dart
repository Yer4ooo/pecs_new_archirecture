import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/utils/key_value_storage_service.dart';
import '../models/children_model_response.dart';
import 'children_event.dart';
import 'children_state.dart';

class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  ChildrenBloc() : super(ChildrenInitial()) {
    final dio = Dio();
    on<FetchChildren>((event, emit) async {
      final token = await GetIt.I<KeyValueStorageService>().getAccessToken();
      emit(ChildrenLoading());
      try {
        final response = await dio.get(
          "https://api.pecs.qys.kz/parent/children",
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
        );

        print("API Response: ${response.data}");

        final ChildrenModel childrenData = ChildrenModel.fromJson(response.data);

        print("Parsed Children Data: ${childrenData.children}");

        emit(ChildrenSuccess(childrenData: childrenData));
      } catch (error, stackTrace) {
        print("Error: $error\nStackTrace: $stackTrace");
        emit(ChildrenFailure(error: error.toString()));
      }
    });
    }
  }