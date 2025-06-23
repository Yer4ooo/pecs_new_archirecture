import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_images_list_model.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import 'package:pecs_new_arch/features/library/presentation/widgets/category_card.dart';
import 'package:pecs_new_arch/features/library/presentation/widgets/custom_button.dart';
import 'package:pecs_new_arch/injection_container.dart';

class InnerCatolog extends StatefulWidget {
  final int? id;
  const InnerCatolog({super.key, required this.id});

  @override
  State<InnerCatolog> createState() => _InnerCatologState();
}

class _InnerCatologState extends State<InnerCatolog> {
  bool _showMyCards = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> images = [
    {
      'id': 1,
      'name': 'Лев',
      'imageUrl':
          'https://cdn.pixabay.com/photo/2017/10/25/16/54/african-lion-2888519_640.jpg',
      'isMy': false
    },
    {
      'id': 2,
      'name': 'Жираф ',
      'imageUrl':
          'https://cdn.pixabay.com/photo/2023/06/03/17/11/giraffe-8038107_640.jpg',
      'isMy': false
    },
    {
      'id': 3,
      'name': 'Зебра',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAheYsrTCldWDhGR3aKktvMF1_nEe5yffEQQ&s',
      'isMy': true
    },
    {
      'id': 4,
      'name': 'Слон',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbg204zYIE1oiXZYVOuBPmsw_UpVA40fMCRA&s',
      'isMy': true
    },
    {
      'id': 5,
      'name': 'Гиена',
      'imageUrl':
          'https://cdn.pixabay.com/photo/2022/05/25/07/23/animal-7219905_640.jpg',
      'isMy': true
    },
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<LibraryBloc>()..add(GetCategoryImagesById(id: widget.id)),
      child: Scaffold(
        body: BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
          if (state is CategoriesLoading) {
            return const Column(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          } else if (state is CategoryImagesLoaded) {
            List<CategoriesImagesListModel>? filteredImages =
                state.images?.where((image) {
              // Check for null before using 'public'
              if (_showMyCards && (image.public != true)) return false;

              // Check if name is not null before using 'contains'
              if (_searchQuery.isNotEmpty &&
                  !(image.name
                          ?.toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ??
                      false)) {
                return false;
              }

              return true;
            }).toList(); // convert Iterable to List

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
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
                                  hintText: 'Поиск в фотках',
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
                                child:
                                    const Icon(Icons.clear, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CustomButton(
                          text: "Все карточки",
                          onPressed: () {
                            setState(() {
                              _showMyCards = false;
                            });
                          },
                          color: const Color.fromRGBO(97, 148, 81, 1),
                          width: 200,
                          height: 45,
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        const SizedBox(width: 20),
                        CustomButton(
                          text: "Мои карточки",
                          onPressed: () {
                            setState(() {
                              _showMyCards = true;
                            });
                          },
                          color: Colors.grey,
                          width: 200,
                          height: 45,
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        const SizedBox(width: 20),
                        CustomButton(
                          text: "Добавить карточку",
                          onPressed: () {},
                          color: Colors.grey,
                          width: 200,
                          height: 45,
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 cards in a row
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1, // Adjust card proportions
                      ),
                      itemCount: filteredImages?.length, // Number of categories
                      itemBuilder: (context, index) {
                        final image = filteredImages?[index];
                        return CategoryCard(
                          title: image?.name ?? '-',
                          imageUrl: image?.imageUrl ?? '-',
                          onTap: () {},
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
