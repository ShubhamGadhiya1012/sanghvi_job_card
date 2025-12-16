// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/home/controllers/home_controller.dart';
import 'package:sanghvi_job_card/features/home/widgets/job_card_card.dart';
import 'package:sanghvi_job_card/features/home/widgets/sidebar_menu_item.dart';
import 'package:sanghvi_job_card/features/job_card_entry/screens/job_card_screen.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_button.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_text_button_with_icon.dart';
import 'package:sanghvi_job_card/widgets/app_text_form_field.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _controller = Get.put(HomeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: kColorWhite,
          drawer: _buildDrawer(context, tablet),
          body: Column(
            children: [
              _buildAppBar(context, tablet),
              Expanded(child: _buildDefaultScreen(tablet)),
            ],
          ),
        ),
        Obx(() => AppLoadingOverlay(isLoading: _controller.isLoading.value)),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, bool tablet) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (tablet ? 16 : 12),
        left: tablet ? 20 : 16,
        right: tablet ? 20 : 16,
        bottom: tablet ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: kColorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: kColorPrimary,
              size: tablet ? 32 : 28,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          tablet ? AppSpaces.h12 : AppSpaces.h8,
          Expanded(
            child: Obx(
              () => Text(
                _controller.company.value,
                style: TextStyles.kBoldOutfit(
                  fontSize: tablet
                      ? FontSizes.k24FontSize
                      : FontSizes.k18FontSize,
                  color: kColorPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, bool tablet) {
    return Drawer(
      backgroundColor: kColorWhite,
      child: Obx(() {
        final accessMap = {
          for (var menu in _controller.menuAccess) menu.menuName: menu.access,
        };

        final visibleMenuItems = _controller.menuItems
            .where((item) => accessMap[item.menuName] ?? false)
            .toList();

        return Column(
          children: [
            _buildDrawerHeader(context, tablet),
            Expanded(
              child: visibleMenuItems.isEmpty
                  ? _buildNoAccessWidget(tablet)
                  : RefreshIndicator(
                      backgroundColor: kColorWhite,
                      color: kColorPrimary,
                      strokeWidth: 2.5,
                      onRefresh: () async {
                        await _controller.checkAppVersion();
                        await _controller.getUserAccess();
                      },
                      child: ListView.builder(
                        padding: AppPaddings.custom(
                          top: tablet ? 12 : 8,
                          bottom: tablet ? 12 : 8,
                        ),
                        itemCount: visibleMenuItems.length,
                        itemBuilder: (context, index) {
                          final menu = visibleMenuItems[index];
                          return Obx(() {
                            final isExpanded =
                                _controller.expandedMenuIndex.value == index;
                            final hasSubMenus =
                                menu.subMenus != null &&
                                menu.subMenus!.isNotEmpty;

                            return Column(
                              children: [
                                SidebarMenuItem(
                                  menu: menu,
                                  isSelected:
                                      _controller.selectedMenuIndex.value ==
                                      index,
                                  isExpanded: isExpanded,
                                  hasSubMenus: hasSubMenus,
                                  onTap: () {
                                    if (hasSubMenus) {
                                      _controller.toggleMenuExpansion(index);
                                    } else {
                                      _controller.selectedMenuIndex.value =
                                          index;
                                      if (menu.onTap != null) {
                                        menu.onTap!();
                                      }
                                    }
                                  },
                                ),
                                if (hasSubMenus && isExpanded)
                                  ...menu.subMenus!.map((subMenu) {
                                    return SubMenuItem(
                                      menu: subMenu,
                                      onTap: () {
                                        if (subMenu.onTap != null) {
                                          subMenu.onTap!();
                                        }
                                      },
                                    );
                                  }),
                              ],
                            );
                          });
                        },
                      ),
                    ),
            ),
            _buildDrawerFooter(tablet),
          ],
        );
      }),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, bool tablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (tablet ? 24 : 20),
        left: tablet ? 24 : 20,
        right: tablet ? 24 : 20,
        bottom: tablet ? 24 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kColorPrimary,
            kColorPrimary.withOpacity(0.85),
            kColorPrimary.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: kColorPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(tablet ? 14 : 12),
            decoration: BoxDecoration(
              color: kColorWhite.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: tablet ? 40 : 32,
              color: kColorWhite,
            ),
          ),
          tablet ? AppSpaces.h16 : AppSpaces.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    _controller.fullName.value,
                    style: TextStyles.kBoldOutfit(
                      fontSize: tablet
                          ? FontSizes.k24FontSize
                          : FontSizes.k20FontSize,
                      color: kColorWhite,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppSpaces.v4,
                Obx(() {
                  String userType;
                  switch (_controller.userType.value) {
                    case '0':
                      userType = 'Admin';
                      break;
                    case '1':
                      userType = 'Manager';
                      break;
                    case '2':
                      userType = 'Salesman';
                      break;
                    default:
                      userType = 'User';
                  }

                  return Text(
                    userType,
                    style: TextStyles.kRegularOutfit(
                      fontSize: tablet
                          ? FontSizes.k16FontSize
                          : FontSizes.k14FontSize,
                      color: kColorWhite.withOpacity(0.9),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerFooter(bool tablet) {
    return Container(
      padding: EdgeInsets.all(tablet ? 20 : 16),
      decoration: BoxDecoration(
        color: kColorWhite,
        border: Border(
          top: BorderSide(color: kColorGrey.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            title: 'Check for Update',
            buttonHeight: tablet ? 50 : 45,
            buttonColor: kColorPrimary,
            titleSize: tablet ? FontSizes.k16FontSize : FontSizes.k14FontSize,
            onPressed: () => _controller.redirectToPlayStore(),
          ),
          tablet ? AppSpaces.v12 : AppSpaces.v8,

          AppButton(
            title: 'Logout',
            buttonHeight: tablet ? 50 : 45,
            buttonColor: kColorWhite,
            borderColor: kColorRed,
            titleColor: kColorRed,
            titleSize: tablet ? FontSizes.k16FontSize : FontSizes.k14FontSize,
            onPressed: () {
              Get.back();
              _showLogoutDialog(tablet);
            },
          ),
          tablet ? AppSpaces.v8 : AppSpaces.v6,

          Obx(
            () => Text(
              'v${_controller.appVersion.value}',
              style: TextStyles.kRegularOutfit(
                fontSize: tablet
                    ? FontSizes.k12FontSize
                    : FontSizes.k10FontSize,
                color: kColorGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(bool tablet) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tablet ? 16 : 12),
          ),
          title: Text(
            'Confirm Logout',
            style: TextStyles.kSemiBoldOutfit(
              fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k18FontSize,
              color: kColorTextPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyles.kRegularOutfit(
              fontSize: tablet ? FontSizes.k16FontSize : FontSizes.k14FontSize,
              color: kColorTextPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyles.kMediumOutfit(
                  fontSize: tablet
                      ? FontSizes.k16FontSize
                      : FontSizes.k14FontSize,
                  color: kColorDarkGrey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                _controller.logoutUser();
              },
              child: Text(
                'Logout',
                style: TextStyles.kMediumOutfit(
                  fontSize: tablet
                      ? FontSizes.k16FontSize
                      : FontSizes.k14FontSize,
                  color: kColorRed,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNoAccessWidget(bool tablet) {
    return Center(
      child: Padding(
        padding: AppPaddings.p20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: tablet ? 64 : 48,
              color: kColorDarkGrey.withOpacity(0.5),
            ),
            tablet ? AppSpaces.v20 : AppSpaces.v16,
            Text(
              'No Access',
              style: TextStyles.kSemiBoldOutfit(
                fontSize: tablet
                    ? FontSizes.k20FontSize
                    : FontSizes.k16FontSize,
                color: kColorDarkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            tablet ? AppSpaces.v12 : AppSpaces.v8,
            Text(
              'Contact your administrator',
              style: TextStyles.kRegularOutfit(
                fontSize: tablet
                    ? FontSizes.k16FontSize
                    : FontSizes.k14FontSize,
                color: kColorDarkGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultScreen(bool tablet) {
    return Padding(
      padding: tablet
          ? AppPaddings.combined(horizontal: 24, vertical: 12)
          : AppPaddings.p10,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: _controller.searchController,
                  hintText: 'Search Job Card',
                  onChanged: (value) => _controller.refreshJobCards(),
                ),
              ),
              tablet ? AppSpaces.h16 : AppSpaces.h10,
              AppTextButtonWithIcon(
                onPressed: () {
                  Get.to(() => JobCardScreen());
                },
                title: 'Add New',
                icon: Icons.add,
              ),
            ],
          ),
          tablet ? AppSpaces.v10 : AppSpaces.v6,

          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !_controller.isLoadingMore.value) {
                  _controller.getJobCards(loadMore: true);
                }
                return true;
              },
              child: Obx(() {
                if (_controller.jobCardList.isEmpty &&
                    !_controller.isLoading.value) {
                  return Center(
                    child: Text(
                      'No job cards found.',
                      style: TextStyles.kMediumOutfit(
                        fontSize: tablet
                            ? FontSizes.k26FontSize
                            : FontSizes.k18FontSize,
                        color: kColorTextPrimary,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  backgroundColor: kColorWhite,
                  color: kColorPrimary,
                  strokeWidth: 2.5,
                  onRefresh: () => _controller.refreshJobCards(),
                  child: ListView.builder(
                    itemCount:
                        _controller.jobCardList.length +
                        (_controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < _controller.jobCardList.length) {
                        final jobCard = _controller.jobCardList[index];
                        return JobCardCard(
                          jobCard: jobCard,
                          onEdit: () {
                            Get.to(() => JobCardScreen(), arguments: jobCard);
                          },
                          onDelete: () {
                            _showDeleteDialog(context, jobCard.invno, tablet);
                          },
                        );
                      } else {
                        return Padding(
                          padding: AppPaddings.p10,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: kColorPrimary,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String invno, bool tablet) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tablet ? 16 : 12),
          ),
          title: Text(
            'Confirm Delete',
            style: TextStyles.kSemiBoldOutfit(
              fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k18FontSize,
              color: kColorTextPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this job card?',
            style: TextStyles.kRegularOutfit(
              fontSize: tablet ? FontSizes.k16FontSize : FontSizes.k14FontSize,
              color: kColorTextPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyles.kMediumOutfit(
                  fontSize: tablet
                      ? FontSizes.k16FontSize
                      : FontSizes.k14FontSize,
                  color: kColorDarkGrey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                _controller.deleteJobCard(invno);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyles.kMediumOutfit(
                  fontSize: tablet
                      ? FontSizes.k16FontSize
                      : FontSizes.k14FontSize,
                  color: kColorWhite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
