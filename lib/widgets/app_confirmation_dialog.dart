import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/extensions/app_size_extensions.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_button.dart';
import 'package:sanghvi_job_card/widgets/app_text_button.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    this.confirmColor = kColorRed,
  });

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return AlertDialog(
      backgroundColor: kColorWhite,
      titlePadding: tablet
          ? AppPaddings.custom(left: 25, right: 25, top: 25, bottom: 10)
          : AppPaddings.custom(left: 20, right: 20, top: 20, bottom: 6),
      contentPadding: tablet
          ? AppPaddings.custom(left: 25, right: 25, bottom: 14)
          : AppPaddings.custom(left: 20, right: 20, bottom: 8),
      title: Text(
        title,
        style: TextStyles.kSemiBoldOutfit(
          fontSize: tablet ? FontSizes.k32FontSize : FontSizes.k20FontSize,
          color: kColorPrimary,
        ),
      ),
      content: Text(
        message,
        style: TextStyles.kRegularOutfit(
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k16FontSize,
        ),
      ),
      actions: [
        AppTextButton(onPressed: () => Get.back(), title: cancelText),
        tablet ? AppSpaces.h16 : AppSpaces.h10,
        AppButton(
          buttonColor: confirmColor,
          buttonWidth: 0.25.screenWidth,
          onPressed: () {
            Get.back();
            onConfirm();
          },
          title: confirmText,
        ),
      ],
    );
  }
}
