import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: EdgeInsets.all(16.r),
        height: 90.r,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            Icon(Icons.cancel, color: Colors.white,),
            10.horizontalSpace,
            Text(message, style: TextStyle(fontSize: 20.sp),maxLines: 2, overflow: TextOverflow.ellipsis,),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: Duration(seconds: 3),
    ),
  );
}
