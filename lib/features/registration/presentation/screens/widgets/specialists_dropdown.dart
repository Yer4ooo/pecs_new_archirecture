import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecializationDropdown extends StatelessWidget {
  final List<String> allSpecializations;
  final List<String> selected;
  final Function(List<String>) onChanged;

  const SpecializationDropdown({
    super.key,
    required this.allSpecializations,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Специализация", style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        4.verticalSpace,
        DropdownSearch<String>.multiSelection(
          items: allSpecializations,
          selectedItems: selected,
          onChanged: onChanged,
          popupProps: PopupPropsMultiSelection.menu(
            showSelectedItems: true,
            showSearchBox: false,
            constraints: BoxConstraints(maxHeight: 500.h),
            menuProps: const MenuProps(
              elevation: 30,
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            ),
          ),
        ),
      ],
    );
  }
}
