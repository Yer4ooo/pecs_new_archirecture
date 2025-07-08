import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class CategoriesCreateRequestModel {
  final String name;
  final bool public;
  final File? image;

  CategoriesCreateRequestModel({
    required this.name,
    required this.public,
    this.image,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'name': name,
      'public': public.toString(),
    };

    if (image != null) {
      map['image'] = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
    }

    return FormData.fromMap(map);
  }
}
