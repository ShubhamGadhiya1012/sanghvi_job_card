// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/features/user_settings/controllers/user_access_controller.dart';
import 'package:sanghvi_job_card/features/user_settings/widgets/menu_access_list_tile.dart';
import 'package:sanghvi_job_card/features/user_settings/widgets/user_access_ledger_date_row.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:sanghvi_job_card/widgets/app_card.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';

// ignore: must_be_immutable
class UserAccessScreen extends StatefulWidget {
  UserAccessScreen({
    super.key,
    required this.fullName,
    required this.userId,
    required this.appAccess,
  });

  final String fullName;
  final int userId;
  bool appAccess;

  @override
  State<UserAccessScreen> createState() => _UserAccessScreenState();
}

class _UserAccessScreenState extends State<UserAccessScreen> {
  final UserAccessController _controller = Get.put(UserAccessController());

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getUserAccess(userId: widget.userId);
  }

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
              title: widget.fullName,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    tablet ? AppSpaces.v16 : AppSpaces.v10,
                    AppCard(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'App Access',
                                style: TextStyles.kMediumOutfit(
                                  color: kColorTextPrimary,
                                  fontSize: tablet
                                      ? FontSizes.k18FontSize
                                      : FontSizes.k16FontSize,
                                ),
                              ),
                              Text(
                                'Allow user to access app',
                                style: TextStyles.kRegularOutfit(
                                  color: kColorTextPrimary,
                                  fontSize: tablet
                                      ? FontSizes.k16FontSize
                                      : FontSizes.k14FontSize,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: widget.appAccess,
                            activeColor: kColorPrimary,
                            inactiveTrackColor: kColorWhite,
                            onChanged: (value) async {
                              await _controller.setAppAccess(
                                userId: widget.userId,
                                appAccess: value,
                              );
                              setState(() {
                                widget.appAccess = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    tablet ? AppSpaces.v16 : AppSpaces.v10,
                    Visibility(
                      visible: widget.appAccess,
                      child: Column(
                        children: [
                          UserAccessLedgerDateRow(
                            label: 'Ledger Start',
                            controller: _controller.ledgerStartDateController,
                            onClear: () {
                              _controller.ledgerStartDateController.clear();
                              _controller.setLedger(userId: widget.userId);
                            },
                            onChanged: (value) {
                              _controller.setLedger(userId: widget.userId);
                            },
                          ),
                          tablet ? AppSpaces.v16 : AppSpaces.v10,
                          UserAccessLedgerDateRow(
                            label: 'Ledger End',
                            controller: _controller.ledgerEndDateController,
                            onClear: () {
                              _controller.ledgerEndDateController.clear();
                              _controller.setLedger(userId: widget.userId);
                            },
                            onChanged: (value) {
                              _controller.setLedger(userId: widget.userId);
                            },
                          ),
                          tablet ? AppSpaces.v16 : AppSpaces.v10,
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.appAccess,
                      child: Obx(
                        () => ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _controller.menuAccess.length,
                          itemBuilder: (context, index) {
                            final menuAccess = _controller.menuAccess[index];

                            return MenuAccessListTile(
                              menuAccess: menuAccess,
                              onChanged: (value) async {
                                await _controller.setMenuAccess(
                                  userId: widget.userId,
                                  menuId: menuAccess.menuId,
                                  menuAccess: value,
                                );
                                setState(() {
                                  menuAccess.access = value;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(() => AppLoadingOverlay(isLoading: _controller.isLoading.value)),
      ],
    );
  }
}