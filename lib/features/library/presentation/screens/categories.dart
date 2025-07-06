import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import 'package:pecs_new_arch/features/library/presentation/screens/add_category_screen.dart';
import 'package:pecs_new_arch/features/library/presentation/screens/inner_catolog.dart';
import 'package:pecs_new_arch/features/library/presentation/widgets/category_card.dart';
import 'package:pecs_new_arch/features/library/presentation/widgets/custom_button.dart';
@RoutePage()
class Categories extends StatefulWidget {

  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(GetCategories());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
        if (state is CategoriesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CategoriesLoaded) {
          final List<CategoryItem>? filteredCategories = _searchQuery.isEmpty
              ? state.categories?.items
              : state.categories?.items
                  .where((category) => category.name
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
                  .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(),
                _buildUploadButton(),
                _buildCategoriesGrid(filteredCategories),
              ],
            ),
          );
        } else if (state is CategoriesError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Offstage(
          child: Text('I am offstage'),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Поиск по категории',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              if (_searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                  child: const Icon(Icons.clear, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: CustomButton(
        text: 'Загрузить изображение',
        color: Colors.green.shade700,
        onPressed: () {
            MaterialPageRoute(
              builder: (_) => const ImageUploadForm(),
            );},
      ),
    );
  }

  Widget _buildCategoriesGrid(List<CategoryItem>? categories) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1,
        ),
        itemCount: categories?.length ?? 0,
        itemBuilder: (context, index) {
          final category = categories?[index];
          return CategoryCard(
            title: category?.name ?? 'Category ${index + 1}',
            imageUrl: category?.imageUrl ?? '',
            onTap: () {
                MaterialPageRoute(
                  builder: (context) => InnerCatolog(id: category?.id ?? -1),
              );
            },
          );
        },
      ),
    );
  }
}
