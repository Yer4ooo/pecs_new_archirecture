import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecs_new_arch/core/constants/app_icons.dart';
import 'package:pecs_new_arch/features/library/data/models/categories_list_model.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/categories_create_request_model.dart';

@RoutePage()
class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  int limit = 29;
  int offset = 0;
  late List<CategoryItem>? categories = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  Timer? _searchDebounce;
  bool isChecked = false;
  final _picker = ImagePicker();
  final TextEditingController _searchController = TextEditingController();
  File? _imageFile;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !isLoadingMore &&
          hasMoreData) {
        _fetchMoreCategories();
      }
    });
    context.read<LibraryBloc>().add(GetCategories(params: {
          'limit': limit,
          'offset': offset,
        }));
  }

  void _pickImage(Function(void Function()) dialogSetState) async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final file = File(pickedImage.path);
      final bytes = await file.readAsBytes();
      final base64Str = base64Encode(bytes);
      dialogSetState(() {
        _imageFile = file;
        _base64Image = base64Str;
      });
    }
  }

  void _showCreateDialog(
    BuildContext context,
  ) {
    _imageFile = null;
    String catName = 'untitled';
    final TextEditingController textController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      LocaleKeys.library_new_cat.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    LocaleKeys.library_name.tr(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: textController,
                                      decoration: InputDecoration(
                                        hintText: LocaleKeys.boards_enter.tr(),
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.all(16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          catName = value;
                                        });
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    LocaleKeys.library_image.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                          radius: Radius.circular(10).r,
                                          color: Color(0xFF619451)),
                                      child: _imageFile == null
                                          ? Container(
                                              width: double.infinity,
                                              height: 200.h,
                                              color: Color(0xFF619451)
                                                  .withOpacity(0.1),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.r),
                                                    child: SvgPicture.asset(
                                                        AppIcons.upload),
                                                  ),
                                                  Text(
                                                    LocaleKeys.library_upload
                                                        .tr(),
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      LocaleKeys.library_limits
                                                          .tr(),
                                                      textAlign:
                                                          TextAlign.center),
                                                  10.verticalSpace,
                                                  GestureDetector(
                                                    onTap: () {
                                                      _pickImage(setState);
                                                    },
                                                    child: Container(
                                                      height: 40.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        color:
                                                            Color(0xFF619451),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        child: Text(
                                                          LocaleKeys
                                                              .library_upload_button
                                                              .tr(),
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              width: double.infinity,
                                              child: Image.file(_imageFile!,
                                                  fit: BoxFit.contain),
                                            )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        LocaleKeys.library_public.tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                      ),
                                      SizedBox(
                                        width: 300,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 40.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xFF619451)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    LocaleKeys.library_cancel
                                                        .tr(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF619451),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context.read<LibraryBloc>().add(
                                                    CreateCategory(
                                                        category:
                                                            CategoriesCreateRequestModel(
                                                                name: catName,
                                                                image: _imageFile,
                                                                public:
                                                                    isChecked)));
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 40.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: Color(0xFF619451),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    LocaleKeys.library_save
                                                        .tr(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ])))));
          });
        });
  }

  void _fetchMoreCategories() {
    isLoadingMore = true;
    offset += limit;

    context.read<LibraryBloc>().add(
          GetCategories(
            params: {
              'limit': limit,
              'offset': offset,
              if (_searchQuery.isNotEmpty) 'search': _searchQuery,
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocConsumer<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is CategoriesLoading && categories!.isEmpty || state is CreateCategoryLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is CategoriesLoading && categories!.isNotEmpty) {
                  isLoadingMore = true;
                }
                if (state is CategoriesLoaded) {
                  if (offset == 0) {
                    categories = List.from(state.categories!.items);
                  } else {
                    categories!.addAll(state.categories!.items);
                  }
                  isLoadingMore = false;
                  if (state.categories!.items.isEmpty) {
                    hasMoreData = false;
                  }
                } else if (state is CategoriesError) {
                  return Center(child: Text(state.message));
                }

                return _buildGrid(); // ← always return the same widget tree
              },
              listener: (context, state){
                if (state is CreateCategorySuccess){
                  setState(() {
                    offset = 0;
                  });
                  context.read<LibraryBloc>().add(GetCategories(params: {
                    'limit': limit,
                    'offset': offset,
                  }));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: EdgeInsets.all(40.0).r,
      child: GridView.builder(
        controller: _scrollController,
        itemCount: categories!.length + 2,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 45.w,
          mainAxisSpacing: 45.h,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          if (index == categories!.length + 1) {
            return isLoadingMore
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                _showCreateDialog(context);
              },
              child: Container(
                color: Colors.transparent,
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(10).r,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 50.r,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.w),
                  borderRadius: BorderRadius.circular(10.r)),
              child: Column(children: [
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Image.network(
                      categories![index - 1].imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Text(
                            'Не удалось загрузить\nизображение',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Text(
                      categories![index - 1]
                          .getLocalizedName(context.locale.languageCode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    )),
              ]),
            );
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(20.0).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.library_library.tr(),
            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          SizedBox(
            height: 48.h,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(97, 148, 81, 1),
                  width: 1.5.w,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  SizedBox(
                    width: 300.w,
                    child: TextField(
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "${LocaleKeys.library_search.tr()}...",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16.sp),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (_searchDebounce?.isActive ?? false)
                            _searchDebounce?.cancel();
                          _searchDebounce =
                              Timer(Duration(milliseconds: 400), () {
                            setState(() {
                              _searchQuery = value;
                              offset = 0;
                              categories = [];
                              hasMoreData = true;
                              isLoadingMore = false;
                            });
                            _scrollController.jumpTo(0);
                            context
                                .read<LibraryBloc>()
                                .add(GetCategories(params: {
                                  'limit': limit,
                                  'offset': 0,
                                  if (_searchQuery.isNotEmpty)
                                    'search': _searchQuery,
                                }));
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
          10.horizontalSpace,
          IntrinsicWidth(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(97, 148, 81, 1),
                  width: 1.5.w,
                ),
                borderRadius: BorderRadius.circular(10).r,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.r),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(AppIcons.filter),
                    10.horizontalSpace,
                    Text(
                      LocaleKeys.library_filter.tr(),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
