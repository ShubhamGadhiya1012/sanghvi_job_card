// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/home/models/home_menu_item_dm.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';

class SidebarMenuItem extends StatelessWidget {
  const SidebarMenuItem({
    super.key,
    required this.menu,
    required this.isSelected,
    required this.isExpanded,
    required this.hasSubMenus,
    required this.onTap,
  });

  final HomeMenuItemDm menu;
  final bool isSelected;
  final bool isExpanded;
  final bool hasSubMenus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: AppPaddings.combined(
          horizontal: tablet ? 12 : 8,
          vertical: tablet ? 6 : 4,
        ),
        padding: AppPaddings.combined(
          horizontal: tablet ? 20 : 16,
          vertical: tablet ? 18 : 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? kColorPrimary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(tablet ? 14 : 12),
          border: Border.all(
            color: isSelected
                ? kColorPrimary.withOpacity(0.3)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              menu.icon,
              color: isSelected ? kColorPrimary : kColorDarkGrey,
              size: tablet ? 28 : 24,
            ),
            tablet ? AppSpaces.h16 : AppSpaces.h12,
            Expanded(
              child: Text(
                menu.menuName,
                style: TextStyles.kSemiBoldOutfit(
                  fontSize: tablet
                      ? FontSizes.k18FontSize
                      : FontSizes.k16FontSize,
                  color: isSelected ? kColorPrimary : kColorTextPrimary,
                ),
              ),
            ),
            if (hasSubMenus)
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: isSelected ? kColorPrimary : kColorDarkGrey,
                size: tablet ? 28 : 24,
              ),
          ],
        ),
      ),
    );
  }
}

class SubMenuItem extends StatelessWidget {
  const SubMenuItem({super.key, required this.menu, required this.onTap});

  final HomeMenuItemDm menu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: AppPaddings.custom(
          left: tablet ? 56 : 48,
          right: tablet ? 12 : 8,
          top: tablet ? 4 : 2,
          bottom: tablet ? 4 : 2,
        ),
        padding: AppPaddings.combined(
          horizontal: tablet ? 20 : 16,
          vertical: tablet ? 16 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(tablet ? 12 : 10),
        ),
        child: Row(
          children: [
            Icon(menu.icon, color: kColorDarkGrey, size: tablet ? 24 : 20),
            tablet ? AppSpaces.h12 : AppSpaces.h10,
            Expanded(
              child: Text(
                menu.menuName,
                style: TextStyles.kRegularOutfit(
                  fontSize: tablet
                      ? FontSizes.k16FontSize
                      : FontSizes.k14FontSize,
                  color: kColorTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
