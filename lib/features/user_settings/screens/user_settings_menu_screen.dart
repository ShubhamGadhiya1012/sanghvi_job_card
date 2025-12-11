// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/constants/image_constants.dart';
import 'package:sanghvi_job_card/features/user_settings/screens/unauth_users_screen.dart';
import 'package:sanghvi_job_card/features/user_settings/screens/users_screen.dart';
import 'package:sanghvi_job_card/features/user_settings/widgets/user_settings_menu_card.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:get/get.dart';

class UserSettingsMenuScreen extends StatelessWidget {
  const UserSettingsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return Scaffold(
      appBar: AppAppbar(
        title: 'User Settings',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: tablet ? 25 : 20,
            color: kColorTextPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: tablet
            ? AppPaddings.combined(horizontal: 40, vertical: 24)
            : AppPaddings.p20,
        child: GridView.count(
          crossAxisCount: tablet ? 4 : 3,
          crossAxisSpacing: tablet ? 30 : 20,
          mainAxisSpacing: tablet ? 30 : 20,
          childAspectRatio: tablet ? 0.85 : 0.75,
          children: [
            UserSettingsMenuCard(
              iconPath: kIconUserAuthorisation,
              label: 'User\nAuth',
              onTap: () {
                Get.to(() => UnauthUsersScreen());
              },
            ),
            UserSettingsMenuCard(
              iconPath: kIconUserRights,
              label: 'User\nRights',
              onTap: () {
                Get.to(() => UsersScreen(fromWhere: 'R'));
              },
            ),
            UserSettingsMenuCard(
              iconPath: kIconUserManagement,
              label: 'Manage\nUser',
              onTap: () {
                Get.to(() => UsersScreen(fromWhere: 'M'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
