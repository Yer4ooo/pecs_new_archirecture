import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../translations/locale_keys.g.dart';

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
        Text(
          LocaleKeys.registration_page_spec.tr(),
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        4.verticalSpace,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: DropdownSearch<String>.multiSelection(
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
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
