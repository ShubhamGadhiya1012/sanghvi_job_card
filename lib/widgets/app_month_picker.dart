// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/extensions/app_size_extensions.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';

class AppMonthPicker extends StatefulWidget {
  const AppMonthPicker({
    super.key,
    required this.monthYearController,
    required this.hintText,
    this.fillColor,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  final TextEditingController monthYearController;
  final String hintText;
  final Color? fillColor;
  final bool enabled;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;

  @override
  State<AppMonthPicker> createState() => _AppMonthPickerState();
}

class _AppMonthPickerState extends State<AppMonthPicker> {
  static const List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime currentDate =
        _parseMonthYear(widget.monthYearController.text) ?? DateTime.now();

    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return _MonthYearPickerDialog(initialDate: currentDate);
      },
    );

    if (pickedDate != null) {
      setState(() {
        widget.monthYearController.text = _formatMonthYear(pickedDate);
      });

      if (widget.onChanged != null) {
        widget.onChanged!(widget.monthYearController.text);
      }
    }
  }

  DateTime? _parseMonthYear(String monthYearString) {
    try {
      if (monthYearString.isEmpty) return null;

      final parts = monthYearString.split(' ');
      if (parts.length == 2) {
        final monthIndex = monthNames.indexOf(parts[0]) + 1;
        final year = int.parse(parts[1]);
        if (monthIndex > 0 && year > 0) {
          return DateTime(year, monthIndex);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String _formatMonthYear(DateTime date) {
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextFormField(
      controller: widget.monthYearController,
      cursorColor: kColorTextPrimary,
      cursorHeight: tablet ? 26 : 20,
      enabled: widget.enabled,
      validator: widget.validator,
      style: TextStyles.kMediumOutfit(
        fontSize: tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize,
        color: kColorTextPrimary,
      ),
      readOnly: true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyles.kRegularOutfit(
          fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
          color: kColorDarkGrey,
        ),
        labelText: widget.hintText,
        labelStyle: TextStyles.kRegularOutfit(
          fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
          color: kColorDarkGrey,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyles.kMediumOutfit(
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k18FontSize,
          color: kColorPrimary,
        ),
        errorStyle: TextStyles.kRegularOutfit(
          fontSize: tablet ? FontSizes.k18FontSize : FontSizes.k14FontSize,
          color: kColorRed,
        ),
        border: outlineInputBorder(
          borderColor: kColorDarkGrey,
          borderWidth: 1,
          tablet: tablet,
        ),
        enabledBorder: outlineInputBorder(
          borderColor: kColorDarkGrey,
          borderWidth: 1,
          tablet: tablet,
        ),
        disabledBorder: outlineInputBorder(
          borderColor: kColorDarkGrey,
          borderWidth: 1,
          tablet: tablet,
        ),
        focusedBorder: outlineInputBorder(
          borderColor: kColorPrimary,
          borderWidth: 1,
          tablet: tablet,
        ),
        errorBorder: outlineInputBorder(
          borderColor: kColorRed,
          borderWidth: 1,
          tablet: tablet,
        ),
        contentPadding: tablet
            ? AppPaddings.combined(horizontal: 20, vertical: 12)
            : AppPaddings.combined(
                horizontal: 16.appWidth,
                vertical: 8.appHeight,
              ),
        filled: true,
        fillColor: widget.fillColor ?? kColorWhite,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.calendar_month,
            size: tablet ? 25 : 20,
            color: kColorPrimary,
          ),
          onPressed: widget.enabled ? () => _selectMonthYear(context) : null,
        ),
        suffixIconColor: kColorPrimary,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color borderColor,
    required double borderWidth,
    required bool tablet,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(tablet ? 20 : 10),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const _MonthYearPickerDialog({required this.initialDate});

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int selectedMonth;
  late int selectedYear;
  late PageController yearPageController;

  static const List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year;
    yearPageController = PageController(initialPage: selectedYear - 2000);
  }

  @override
  void dispose() {
    yearPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: kColorPrimary,
        colorScheme: const ColorScheme.light(
          primary: kColorPrimary,
          onPrimary: kColorWhite,
          surface: kColorWhite,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tablet ? 20 : 12),
          ),
        ),
      ),
      child: Transform.scale(
        scale: tablet ? 1.3 : 1.0,
        child: Dialog(
          backgroundColor: kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tablet ? 20 : 10),
          ),
          child: Container(
            width: tablet ? 0.7.screenWidth : 0.85.screenWidth,
            padding: tablet
                ? AppPaddings.combined(horizontal: 30, vertical: 30)
                : AppPaddings.combined(
                    horizontal: 20.appWidth,
                    vertical: 20.appHeight,
                  ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Month & Year',
                  style: TextStyles.kMediumOutfit(
                    fontSize: tablet
                        ? FontSizes.k24FontSize
                        : FontSizes.k18FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
                SizedBox(height: tablet ? 30 : 20.appHeight),

                // Year Selector
                Container(
                  padding: tablet
                      ? AppPaddings.combined(horizontal: 20, vertical: 16)
                      : AppPaddings.combined(
                          horizontal: 16.appWidth,
                          vertical: 12.appHeight,
                        ),
                  decoration: BoxDecoration(
                    color: kColorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(tablet ? 16 : 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedYear--;
                            yearPageController.animateToPage(
                              selectedYear - 2000,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          color: kColorPrimary,
                          size: tablet ? 32 : 24,
                        ),
                      ),
                      SizedBox(
                        height: tablet ? 50 : 40.appHeight,
                        width: tablet ? 150 : 120.appWidth,
                        child: PageView.builder(
                          controller: yearPageController,
                          onPageChanged: (index) {
                            setState(() {
                              selectedYear = 2000 + index;
                            });
                          },
                          itemCount: 101,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Text(
                                '${2000 + index}',
                                style: TextStyles.kMediumOutfit(
                                  fontSize: tablet
                                      ? FontSizes.k28FontSize
                                      : FontSizes.k20FontSize,
                                  color: kColorPrimary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedYear++;
                            yearPageController.animateToPage(
                              selectedYear - 2000,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        },
                        icon: Icon(
                          Icons.chevron_right,
                          color: kColorPrimary,
                          size: tablet ? 32 : 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tablet ? 30 : 20.appHeight),

                // Month Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: tablet ? 15 : 10.appWidth,
                    mainAxisSpacing: tablet ? 15 : 10.appHeight,
                    childAspectRatio: tablet ? 2.0 : 1.8,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final isSelected = month == selectedMonth;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedMonth = month;
                        });
                      },
                      borderRadius: BorderRadius.circular(tablet ? 16 : 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? kColorPrimary : kColorWhite,
                          borderRadius: BorderRadius.circular(tablet ? 16 : 10),
                          border: Border.all(
                            color: isSelected ? kColorPrimary : kColorDarkGrey,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            monthNames[index],
                            style: TextStyles.kMediumOutfit(
                              fontSize: tablet
                                  ? FontSizes.k20FontSize
                                  : FontSizes.k14FontSize,
                              color: isSelected
                                  ? kColorWhite
                                  : kColorTextPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: tablet ? 30 : 20.appHeight),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: tablet
                            ? AppPaddings.combined(horizontal: 24, vertical: 12)
                            : AppPaddings.combined(
                                horizontal: 16.appWidth,
                                vertical: 8.appHeight,
                              ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyles.kMediumOutfit(
                          fontSize: tablet
                              ? FontSizes.k20FontSize
                              : FontSizes.k16FontSize,
                          color: kColorTextPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: tablet ? 16 : 12.appWidth),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          DateTime(selectedYear, selectedMonth, 1),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(tablet ? 16 : 10),
                        ),
                        padding: tablet
                            ? AppPaddings.combined(horizontal: 32, vertical: 12)
                            : AppPaddings.combined(
                                horizontal: 24.appWidth,
                                vertical: 4.appHeight,
                              ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyles.kMediumOutfit(
                          fontSize: tablet
                              ? FontSizes.k20FontSize
                              : FontSizes.k16FontSize,
                          color: kColorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
