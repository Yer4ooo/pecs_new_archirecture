import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_create_request_model.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';

class ImageUploadForm extends StatefulWidget {
  const ImageUploadForm({super.key});

  @override
  State<ImageUploadForm> createState() => _ImageUploadFormState();
}

class _ImageUploadFormState extends State<ImageUploadForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _imageFile;
  String? _base64Image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      final base64Str = base64Encode(bytes);

      setState(() {
        _imageFile = file;
        _base64Image = base64Str;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _imageFile != null && _base64Image != null) {
      final name = _nameController.text;
      context.read<LibraryBloc>().add(
        LibraryEvent.createCategory(
          category: CategoriesCreateRequestModel(name: name, imageUrl: _base64Image ?? ''),
        ),
      );
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите фото.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return BlocConsumer<LibraryBloc, LibraryState>(
      listener: (context, state) {
        state.whenOrNull(
          createCategorySuccess: (response) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Категория успешно создана: ${response.name}')),
            );
            _nameController.clear();
            setState(() {
              _imageFile = null;
              _base64Image = null;
            });
          },
          createCategoryError: (errorMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка: $errorMessage')),
            );
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          createCategoryLoading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Загрузка изображения'),
            centerTitle: true,
            backgroundColor: Colors.green.shade700,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: isTablet ? 600 : screenWidth * 0.95,
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _imageFile!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: const Center(child: Text('Фото не выбрано')),
                                ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Название фото',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Введите название' : null,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Камера'),
                                onPressed: () => _pickImage(ImageSource.camera),
                              ),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.photo),
                                label: const Text('Галерея'),
                                onPressed: () => _pickImage(ImageSource.gallery),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    )
                                  : const Text(
                                      'Отправить',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
