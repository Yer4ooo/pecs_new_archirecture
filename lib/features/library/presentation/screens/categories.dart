import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pecs_new_arch/features/home/presentation/screens/widgets/home_top_widget.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import 'package:pecs_new_arch/features/library/presentation/screens/add_category_screen.dart';
import 'package:pecs_new_arch/features/library/presentation/screens/inner_catolog.dart';
import 'package:pecs_new_arch/features/library/presentation/widgets/category_card.dart';
import 'package:pecs_new_arch/features/library/presentation/widgets/custom_button.dart';
import 'package:pecs_new_arch/injection_container.dart';



class Categories extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Categories({super.key,required this.navigatorKey});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'Животные',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS385tDupiHCOBy8SFuFCOXojCTme8y3VEgA&s'
    },
    {
      'id': 2,
      'name': 'Мебель ',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtHkb3Zv9sFdbLgzmZXlkFTp_eX1h-WTY5Ag&s'
    },
    {'id': 3, 'name': 'Спорт', 'imageUrl': 'https://img.freepik.com/free-photo/sports-tools_53876-138077.jpg'},
    {
      'id': 4,
      'name': 'Одежда',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7XhKH1r9fqeCn7B5wSdtrQHjBYNvDFzUaAw&s'
    },
    {
      'id': 5,
      'name': 'Игрушки',
      'imageUrl':
          'https://sun9-62.userapi.com/s/v1/ig2/-Qq-5jvRkDtjoY0K_pJ74Wbb99nMaMKiaQgRXb3lRf5iiM7G-TsEsZv7E7TWo9rP-HQa_xJHuhW02ikADr2BwQJM.jpg?quality=95&as=32x32,48x48,72x72,108x108,160x160,240x240,360x360,480x480,540x540,640x640,720x720,1080x1080,1280x1280,1440x1440,2560x2560&from=bu&u=CuHabOxxtRpMM494km5pTyY-2smUJW54bAqQHSAeYgo&cs=807x807'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LibraryBloc>()..add(GetCategories()),
      child: Scaffold(
        body: BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
          
          if (state is CategoriesLoading) {
           
            return Column(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          } else if (state is CategoriesLoaded) {
final List<CateoriesListModel>? filteredCategories = _searchQuery.isEmpty
                ? state.categories
                : state.categories
                    ?.where((category) => (category.name ?? '').toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                 
                  Padding(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CustomButton(
                      text: 'Загрузить изображение',
                      color: Colors.green.shade700,
                      onPressed: () {
                        widget.navigatorKey.currentState?.push(
                          
                          MaterialPageRoute(builder: (_) => const ImageUploadForm()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 cards in a row
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1, // Adjust card proportions
                      ),
                      itemCount: filteredCategories?.length, // Number of categories
                      itemBuilder: (context, index) {
                        final category = filteredCategories?[index];

                        return CategoryCard(
                          title: category?.name ?? 'Category ${index + 1}',
                          imageUrl: category?.imageUrl ?? '',
                          onTap: () {
                            widget.navigatorKey.currentState?.push(
                                MaterialPageRoute(builder: (context) => InnerCatolog(id: category?.id ?? -1)));
                          },
                        );
                      },
                    ),
                  ),
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
      ),
    );
  }
}
