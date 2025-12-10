import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.color,
    this.fontSize,
    this.style,
  });

  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final double? fontSize;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(
        title,
        style:
            style ??
            TextStyles.kMediumOutfit(
              color: color ?? kColorPrimary,
              fontSize:
                  fontSize ??
                  (tablet ? FontSizes.k25FontSize : FontSizes.k18FontSize),
            ).copyWith(
              height: 1,
              decoration: TextDecoration.underline,
              decorationColor: color ?? kColorPrimary,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
