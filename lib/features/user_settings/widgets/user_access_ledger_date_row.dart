import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/extensions/app_size_extensions.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_date_picker_text_form_field.dart';

class UserAccessLedgerDateRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  const UserAccessLedgerDateRow({
    super.key,
    required this.label,
    required this.controller,
    required this.onClear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyles.kMediumOutfit(
            fontSize: FontSizes.k18FontSize,
            color: kColorTextPrimary,
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 0.45.screenWidth,
              child: AppDatePickerTextFormField(
                dateController: controller,
                hintText: label,
                onChanged: onChanged,
              ),
            ),
            AppSpaces.h10,
            InkWell(
              onTap: onClear,
              child: Icon(Icons.clear, color: kColorRed, size: 20),
            ),
          ],
        ),
      ],
    );
  }
}
