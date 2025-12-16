// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/auth/screens/login_screen.dart';
import 'package:sanghvi_job_card/features/brand_master/screens/item_master_entry_screen.dart';
import 'package:sanghvi_job_card/features/home/models/home_menu_item_dm.dart';
import 'package:sanghvi_job_card/features/home/repos/home_repo.dart';
import 'package:sanghvi_job_card/features/job_card_entry/models/job_card_dm.dart';
import 'package:sanghvi_job_card/features/party_master/screens/party_master_entry_screen.dart';
import 'package:sanghvi_job_card/features/user_settings/models/user_access_dm.dart';
import 'package:sanghvi_job_card/features/user_settings/repos/user_access_repo.dart';
import 'package:sanghvi_job_card/features/user_settings/screens/unauth_users_screen.dart';
import 'package:sanghvi_job_card/features/user_settings/screens/users_screen.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/dialogs/app_dialogs.dart';
import 'package:sanghvi_job_card/utils/helpers/device_helper.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';
import 'package:sanghvi_job_card/utils/helpers/version_helper.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var company = ''.obs;
  var menuAccess = <MenuAccessDm>[].obs;
  var menuItems = <HomeMenuItemDm>[].obs;
  var selectedMenuIndex = 0.obs;
  var expandedMenuIndex = RxInt(-1);
  var appVersion = ''.obs;

  var fullName = ''.obs;
  var userType = ''.obs;

  var jobCardList = <JobCardDm>[].obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  var isFetchingData = false;
  final searchController = TextEditingController();
  var currentPage = 1;
  final pageSize = 10;

  @override
  void onInit() async {
    super.onInit();
    await loadUserInfo();
    await _loadVersion();
    await loadCompany();
    await checkAppVersion();
    await getUserAccess();
    await getJobCards();
  }

  Future<void> loadUserInfo() async {
    try {
      fullName.value = await SecureStorageHelper.read('fullName') ?? 'Unknown';
      userType.value = await SecureStorageHelper.read('userType') ?? 'guest';
    } catch (e) {
      showErrorSnackbar(
        'Failed to Load User Info',
        'There was an issue loading your data. Please try again.',
      );
    }
  }

  Future<void> getJobCards({bool loadMore = false}) async {
    if (loadMore && !hasMoreData.value) return;
    if (isFetchingData) return;

    try {
      isFetchingData = true;

      if (!loadMore) {
        isLoading.value = true;
        currentPage = 1;
        jobCardList.clear();
        hasMoreData.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final newJobCards = await HomeRepo.getJobCards(
        search: searchController.text,
        page: currentPage,
        pageSize: pageSize,
      );

      if (newJobCards.isNotEmpty) {
        final uniqueNew = newJobCards.where((newJobCard) {
          return !jobCardList.any(
            (existing) => existing.invno == newJobCard.invno,
          );
        }).toList();

        if (uniqueNew.isNotEmpty) {
          jobCardList.addAll(uniqueNew);
          currentPage++;
        } else {
          hasMoreData.value = false;
        }
      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      showErrorSnackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      isFetchingData = false;
    }
  }

  Future<void> deleteJobCard(String invno) async {
    try {
      isLoading.value = true;
      final response = await HomeRepo.deleteJobCard(invno);

      if (response != null && response['message'] != null) {
        showSuccessSnackbar('Success', response['message']);
        await refreshJobCards();
      } else {
        showErrorSnackbar(
          'Error',
          response['message'] ?? 'Failed to delete job card',
        );
      }
    } catch (e) {
      showErrorSnackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshJobCards() async {
    await getJobCards(loadMore: false);
  }

  Future<void> _loadVersion() async {
    appVersion.value = await VersionHelper.getVersion();
  }

  Future<void> loadCompany() async {
    String? companyName = await SecureStorageHelper.read('company');
    company.value = companyName ?? '';
  }

  Future<void> getUserAccess() async {
    isLoading.value = true;

    try {
      String? userId = await SecureStorageHelper.read('userId');

      final fetchedUserAccess = await UserAccessRepo.getUserAccess(
        userId: int.parse(userId!),
      );

      menuAccess.assignAll(fetchedUserAccess.menuAccess);
      buildMenuItems();
    } catch (e) {
      showErrorSnackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutUser() async {
    isLoading.value = true;
    try {
      await SecureStorageHelper.clearAll();
      Get.offAll(() => LoginScreen());
      showSuccessSnackbar(
        'Logged Out',
        'You have been successfully logged out.',
      );
    } catch (e) {
      showErrorSnackbar(
        'Logout Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkAppVersion() async {
    isLoading.value = true;
    String? deviceId = await DeviceHelper().getDeviceId();

    if (deviceId == null) {
      showErrorSnackbar('Error', 'Unable to fetch device ID.');
      isLoading.value = false;
      return;
    }

    try {
      String? version = await VersionHelper.getVersion();

      var result = await HomeRepo.checkVersion(
        version: version,
        deviceId: deviceId,
      );

      if (result is List && result.isEmpty) {
        return;
      }
    } catch (e) {
      if (e.toString().contains('Please update your app with latest version')) {
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text('Update Required'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () async {
                    await redirectToPlayStore();
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
      } else if (e.toString().contains('Please login again.')) {
        final tablet = AppScreenUtils.isTablet(Get.context!);
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: kColorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tablet ? 16 : 12),
              ),
              title: Text(
                'Session Expired',
                style: TextStyles.kSemiBoldOutfit(
                  fontSize: tablet
                      ? FontSizes.k20FontSize
                      : FontSizes.k18FontSize,
                  color: kColorTextPrimary,
                ),
              ),
              content: Text(
                'Your session has expired. Please login again to continue.',
                style: TextStyles.kRegularOutfit(
                  fontSize: tablet
                      ? FontSizes.k16FontSize
                      : FontSizes.k14FontSize,
                  color: kColorTextPrimary,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    logoutUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: tablet ? 24 : 20,
                      vertical: tablet ? 12 : 10,
                    ),
                  ),
                  child: Text(
                    'Login Again',
                    style: TextStyles.kMediumOutfit(
                      fontSize: tablet
                          ? FontSizes.k16FontSize
                          : FontSizes.k14FontSize,
                      color: kColorWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        showErrorSnackbar('Error', e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> redirectToPlayStore() async {
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.sanghvi.jobcard';

    final uri = Uri.parse(playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showErrorSnackbar('Error', 'Could not launch the Play Store.');
    }
  }

  void buildMenuItems() {
    menuItems.value = [
      HomeMenuItemDm(
        menuName: 'Job Card',
        icon: Icons.assignment_outlined,
        onTap: () {
          Get.back();
          refreshJobCards();
        },
      ),
      HomeMenuItemDm(
        menuName: 'Vendor Master',
        icon: Icons.account_circle_outlined,
        onTap: () {
          Get.to(() => PartyMasterEntryScreen());
        },
      ),
      HomeMenuItemDm(
        menuName: 'Brand Master',
        icon: Icons.branding_watermark_outlined,
        onTap: () {
          Get.to(() => ItemMasterEntryScreen());
        },
      ),
      HomeMenuItemDm(
        menuName: 'User Settings',
        icon: Icons.settings_outlined,
        subMenus: [
          HomeMenuItemDm(
            menuName: 'User Rights',
            icon: Icons.admin_panel_settings_outlined,
            onTap: () {
              Get.to(() => UsersScreen(fromWhere: 'R'));
            },
          ),
          HomeMenuItemDm(
            menuName: 'Manage User',
            icon: Icons.manage_accounts_outlined,
            onTap: () {
              Get.to(() => UsersScreen(fromWhere: 'M'));
            },
          ),
          HomeMenuItemDm(
            menuName: 'User Auth',
            icon: Icons.verified_user_outlined,
            onTap: () {
              Get.to(() => UnauthUsersScreen());
            },
          ),
        ],
      ),
    ];
  }

  void toggleMenuExpansion(int index) {
    if (expandedMenuIndex.value == index) {
      expandedMenuIndex.value = -1;
    } else {
      expandedMenuIndex.value = index;
    }
  }
}
