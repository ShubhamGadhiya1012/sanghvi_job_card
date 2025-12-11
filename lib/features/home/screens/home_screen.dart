// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/home/controllers/home_controller.dart';
import 'package:sanghvi_job_card/features/home/widgets/sidebar_menu_item.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';

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
      child: Center(
        child: Obx(
          () => Text(
            'v${_controller.appVersion.value}',
            style: TextStyles.kBoldOutfit(
              fontSize: tablet ? FontSizes.k14FontSize : FontSizes.k12FontSize,
              color: kColorGrey,
            ),
          ),
        ),
      ),
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
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard_outlined,
              size: tablet ? 100 : 80,
              color: kColorPrimary.withOpacity(0.3),
            ),
            tablet ? AppSpaces.v30 : AppSpaces.v24,
            Text(
              'Welcome to Sanghvi Product',
              style: TextStyles.kBoldOutfit(
                fontSize: tablet
                    ? FontSizes.k32FontSize
                    : FontSizes.k28FontSize,
                color: kColorPrimary,
              ),
            ),
            tablet ? AppSpaces.v16 : AppSpaces.v12,
            Text(
              'Select a menu from the sidebar',
              style: TextStyles.kRegularOutfit(
                fontSize: tablet
                    ? FontSizes.k18FontSize
                    : FontSizes.k16FontSize,
                color: kColorDarkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
