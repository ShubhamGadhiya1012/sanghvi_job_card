// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';

class AppTitleValueContainer extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  final Color? titleColor;
  final VoidCallback? onTap;
  final bool? showIndicator;
  final CrossAxisAlignment? crossAxisAlignment;
  final AlignmentGeometry? alignment;

  const AppTitleValueContainer({
    super.key,
    required this.title,
    required this.value,
    this.color,
    this.titleColor,
    this.onTap,
    this.showIndicator,
    this.crossAxisAlignment,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        alignment: alignment ?? Alignment.centerLeft,
        width: double.infinity,
        padding: tablet
            ? AppPaddings.combined(horizontal: 20, vertical: 12)
            : AppPaddings.p10,
        decoration: BoxDecoration(
          color: color ?? kColorSecondary,
          borderRadius: BorderRadius.circular(tablet ? 20 : 10),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.kSemiBoldOutfit(
                  fontSize: tablet
                      ? FontSizes.k24FontSize
                      : FontSizes.k16FontSize,
                  color: titleColor ?? kColorPrimary,
                ).copyWith(height: 1),
              ),
              tablet ? AppSpaces.v10 : AppSpaces.v4,
              Text(
                value,
                style: TextStyles.kRegularOutfit(
                  fontSize: tablet
                      ? FontSizes.k24FontSize
                      : FontSizes.k14FontSize,
                  color: titleColor ?? kColorPrimary,
                ).copyWith(height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
