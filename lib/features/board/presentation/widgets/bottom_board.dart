import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FolderWidget extends StatelessWidget {
  final String? labelText;
  final String? imageUrl;

  const FolderWidget({
    super.key,
    required this.labelText,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.r,
      height: 150.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.r,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Card(
          color: Colors.white,
          elevation: 4.r,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12).r,
                    topRight: Radius.circular(12).r,
                  ),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
              8.verticalSpace,
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    labelText!,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String? labelText;
  final String? imageUrl;

  const CategoryWidget({
    super.key,
    required this.labelText,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10).r,
          child: Card(
              color: Colors.white.withOpacity(0.5),
              elevation: 4.r,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12).r,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Padding(
          padding: EdgeInsets.all(5.r),
          child: Card(
              color: Colors.white.withOpacity(0.7),
              elevation: 4.r,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12).r,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 10).r,
          child: Card(
              color: Colors.white,
              elevation: 4.r,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12).r,
                        topRight: Radius.circular(12).r,
                      ),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  8.verticalSpace,
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        labelText!,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
