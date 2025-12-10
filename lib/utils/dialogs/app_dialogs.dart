import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';

void showErrorSnackbar(String title, String message) {
  final bool tablet = AppScreenUtils.isTablet(Get.context!);

  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: kColorRed,
    duration: const Duration(seconds: 3),
    margin: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    padding: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 750),
    titleText: Text(
      title,
      style: TextStyles.kMediumOutfit(
        color: kColorWhite,
        fontSize: tablet ? FontSizes.k25FontSize : FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularOutfit(
        fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
        color: kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumOutfit(
          color: kColorWhite,
          fontSize: tablet ? FontSizes.k25FontSize : FontSizes.k20FontSize,
        ),
      ),
    ),
  );
}

void showSuccessSnackbar(String title, String message) {
  final bool tablet = AppScreenUtils.isTablet(Get.context!);

  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: kColorGreen,
    duration: const Duration(seconds: 3),
    margin: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    padding: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 750),
    titleText: Text(
      title,
      style: TextStyles.kMediumOutfit(
        color: kColorWhite,
        fontSize: tablet ? FontSizes.k25FontSize : FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularOutfit(
        fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
        color: kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumOutfit(
          color: kColorWhite,
          fontSize: tablet ? FontSizes.k25FontSize : FontSizes.k20FontSize,
        ),
      ),
    ),
  );
}
