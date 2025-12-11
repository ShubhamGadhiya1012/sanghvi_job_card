import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/features/user_settings/controllers/users_controller.dart';
import 'package:sanghvi_job_card/features/user_settings/screens/user_management_screen.dart';
import 'package:sanghvi_job_card/features/user_settings/widgets/users_card.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_text_form_field.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({super.key, required this.fromWhere});

  final String fromWhere;

  final UsersController _controller = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppAppbar(
              title: 'Users',
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
                  ? AppPaddings.combined(horizontal: 24, vertical: 12)
                  : AppPaddings.p10,
              child: Column(
                children: [
                  tablet ? AppSpaces.v16 : AppSpaces.v10,
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search User',
                    onChanged: (value) {
                      _controller.filterUsers(value);
                    },
                  ),
                  tablet ? AppSpaces.v16 : AppSpaces.v10,
                  Obx(() {
                    if (_controller.filteredUsers.isEmpty &&
                        !_controller.isLoading.value) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'No users found.',
                            style: TextStyles.kMediumOutfit(),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _controller.filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _controller.filteredUsers[index];

                          return UsersCard(
                            user: user,
                            controller: _controller,
                            fromWhere: fromWhere,
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            floatingActionButton: fromWhere == 'M'
                ? FloatingActionButton(
                    onPressed: () {
                      Get.to(() => UserManagementScreen(isEdit: false));
                    },
                    shape: const CircleBorder(),
                    backgroundColor: kColorPrimary,
                    child: Icon(
                      Icons.add,
                      color: kColorWhite,
                      size: tablet ? 30 : 25,
                    ),
                  )
                : null,
          ),
        ),
        Obx(() => AppLoadingOverlay(isLoading: _controller.isLoading.value)),
      ],
    );
  }
}
