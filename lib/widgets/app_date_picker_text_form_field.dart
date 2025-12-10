import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/extensions/app_size_extensions.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';

class AppDatePickerTextFormField extends StatefulWidget {
  const AppDatePickerTextFormField({
    super.key,
    required this.dateController,
    this.floatingLabelRequired,
    required this.hintText,
    this.fillColor,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  final TextEditingController dateController;
  final bool? floatingLabelRequired;
  final String hintText;
  final Color? fillColor;
  final bool enabled;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;

  @override
  State<AppDatePickerTextFormField> createState() =>
      _AppDatePickerTextFormFieldState();
}

class _AppDatePickerTextFormFieldState
    extends State<AppDatePickerTextFormField> {
  static const String dateFormat = 'dd-MM-yyyy';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate =
        _parseDate(widget.dateController.text) ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        final bool tablet = AppScreenUtils.isTablet(context);

        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kColorPrimary,
            colorScheme: const ColorScheme.light(
              primary: kColorPrimary,
              secondary: kColorSecondary,
              onPrimary: kColorWhite,
              surface: kColorWhite,
            ),
            textTheme: TextTheme(
              // Month/Year header
              headlineMedium: TextStyles.kMediumOutfit(
                fontSize: tablet
                    ? FontSizes.k32FontSize
                    : FontSizes.k24FontSize,
                color: kColorWhite,
              ),
              // Day numbers in calendar grid
              bodyLarge: TextStyles.kRegularOutfit(
                fontSize: tablet
                    ? FontSizes.k22FontSize
                    : FontSizes.k18FontSize,
                color: kColorPrimary,
              ),
              // Selected day
              bodyMedium: TextStyles.kMediumOutfit(
                fontSize: tablet
                    ? FontSizes.k24FontSize
                    : FontSizes.k18FontSize,
                color: kColorWhite,
              ),
              // Week day labels (S M T W T F S)
              labelMedium: TextStyles.kMediumOutfit(
                fontSize: tablet
                    ? FontSizes.k22FontSize
                    : FontSizes.k16FontSize,
                color: kColorPrimary,
              ),
              // Action buttons (Cancel, OK)
              labelLarge: TextStyles.kMediumOutfit(
                fontSize: tablet
                    ? FontSizes.k24FontSize
                    : FontSizes.k18FontSize,
                color: kColorPrimary,
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: kColorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tablet ? 20 : 12),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: kColorWhite,
              headerBackgroundColor: kColorPrimary,
              headerForegroundColor: kColorWhite,
            ),
          ),
          child: Transform.scale(scale: tablet ? 1.3 : 1.0, child: child!),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        widget.dateController.text = DateFormat(dateFormat).format(pickedDate);
      });

      if (widget.onChanged != null) {
        widget.onChanged!(widget.dateController.text);
      }
    }
  }

  DateTime? _parseDate(String dateString) {
    try {
      return DateFormat(dateFormat).parseStrict(dateString);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextFormField(
      controller: widget.dateController,
      cursorColor: kColorBlack,
      cursorHeight: tablet ? 26 : 20,
      enabled: widget.enabled,
      validator: widget.validator,
      style: TextStyles.kRegularOutfit(
        fontSize: (tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize),
        color: kColorBlack,
      ).copyWith(fontWeight: FontWeight.w400),
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
        floatingLabelBehavior: widget.floatingLabelRequired ?? true
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
        floatingLabelStyle: TextStyles.kMediumOutfit(
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k18FontSize,
          color: kColorBlack,
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
          borderColor: kColorBlack,
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
            Icons.calendar_today_rounded,
            size: tablet ? 25 : 20,
            color: kColorBlack,
          ),
          onPressed: widget.enabled ? () => _selectDate(context) : null,
        ),
        suffixIconColor: kColorBlack,
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
