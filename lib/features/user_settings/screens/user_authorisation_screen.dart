import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/features/user_settings/controllers/user_authorisation_controller.dart';
import 'package:sanghvi_job_card/features/user_settings/models/engineer_dm.dart';
import 'package:sanghvi_job_card/features/user_settings/models/salesman_dm.dart';
import 'package:sanghvi_job_card/features/user_settings/widgets/user_authorisation_info_card.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:sanghvi_job_card/widgets/app_button.dart';
import 'package:sanghvi_job_card/widgets/app_dropdown.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_multiple_selection_bottom_sheet.dart';
import 'package:sanghvi_job_card/widgets/app_multiple_selection_field.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';

class UserAuthorisationScreen extends StatelessWidget {
  UserAuthorisationScreen({
    super.key,
    required this.userId,
    required this.fullName,
    required this.mobileNo,
  });

  final int userId;
  final String fullName;
  final String mobileNo;

  final UserAuthorisationController _controller = Get.put(
    UserAuthorisationController(),
  );

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
              title: 'User Management',
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
                child: Form(
                  key: _controller.authUserFormKey,
                  child: Column(
                    children: [
                      tablet ? AppSpaces.v16 : AppSpaces.v10,
                      UserAuthorisationInfoCard(
                        fullName: fullName,
                        mobileNo: mobileNo,
                      ),
                      tablet ? AppSpaces.v16 : AppSpaces.v10,
                      AppDropdown(
                        items: _controller.userTypes.values.toList(),
                        hintText: 'User Type',
                        showSearchBox: false,
                        onChanged: (selectedValue) {
                          _controller.onUserTypeChanged(selectedValue!);
                        },
                        selectedItem: _controller.selectedUserType.value != null
                            ? _controller.userTypes.entries
                                  .firstWhere(
                                    (ut) =>
                                        ut.key ==
                                        _controller.selectedUserType.value,
                                  )
                                  .value
                            : null,
                        validatorText: 'Please select a user type.',
                      ),
                      Obx(
                        () => Visibility(
                          visible: _controller.selectedUserType.value == 1,
                          child: Column(
                            children: [
                              tablet ? AppSpaces.v16 : AppSpaces.v10,
                              GestureDetector(
                                onTap: () {
                                  showEngineerSelectionBottomSheet(
                                    context,
                                    tablet,
                                  );
                                },
                                child: AppMultipleSelectionField(
                                  placeholder: 'Engineer',
                                  selectedItems:
                                      _controller.selectedEngineerNames,
                                  onTap: () => showEngineerSelectionBottomSheet(
                                    context,
                                    tablet,
                                  ),
                                  showFullList: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: _controller.selectedUserType.value == 1,
                          child: Column(
                            children: [
                              tablet ? AppSpaces.v16 : AppSpaces.v10,
                              GestureDetector(
                                onTap: () {
                                  showSalesmanSelectionBottomSheet(
                                    context,
                                    tablet,
                                  );
                                },
                                child: AppMultipleSelectionField(
                                  placeholder: 'Salesman',
                                  selectedItems:
                                      _controller.selectedSalesmanNames,
                                  onTap: () => showSalesmanSelectionBottomSheet(
                                    context,
                                    tablet,
                                  ),
                                  showFullList: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: _controller.selectedUserType.value == 2,
                          child: Column(
                            children: [
                              tablet ? AppSpaces.v16 : AppSpaces.v10,
                              AppDropdown(
                                items: _controller.salesmanNames,
                                hintText: 'Salesman',
                                onChanged: _controller.onSalesmanSelected,
                                selectedItem:
                                    _controller
                                        .selectedSalesmanName
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedSalesmanName.value
                                    : null,
                                validatorText: 'Please select a salesman.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: _controller.selectedUserType.value == 3,
                          child: Column(
                            children: [
                              tablet ? AppSpaces.v16 : AppSpaces.v10,
                              AppDropdown(
                                items: _controller.engineerNames,
                                hintText: 'Engineer',
                                onChanged: _controller.onEngineerSelected,
                                selectedItem:
                                    _controller
                                        .selectedEngineerName
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedEngineerName.value
                                    : null,
                                validatorText: 'Please select an engineer.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      tablet ? AppSpaces.v40 : AppSpaces.v30,
                      AppButton(
                        title: 'Save',
                        onPressed: () {
                          if (_controller.authUserFormKey.currentState!
                              .validate()) {
                            _controller.authoriseUser(userId: userId);
                          }
                        },
                      ),
                      tablet ? AppSpaces.v24 : AppSpaces.v20,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(() => AppLoadingOverlay(isLoading: _controller.isLoading.value)),
      ],
    );
  }

  void showSalesmanSelectionBottomSheet(BuildContext context, bool tablet) {
    Get.bottomSheet(
      SelectionBottomSheet<SalesmanDm>(
        title: 'Select Salesman',
        items: _controller.filteredSalesmen,
        selectedCodes: _controller.selectedSalesmanCodes,
        selectedNames: _controller.selectedSalesmanNames,
        itemNameGetter: (se) => se.seName,
        itemCodeGetter: (se) => se.seCode,
        searchController: _controller.searchSalesmanController,
        onSelectionChanged: (selected, se) {
          if (selected == true) {
            _controller.selectedSalesmanCodes.add(se.seCode);
            _controller.selectedSalesmanNames.add(se.seName);
          } else {
            _controller.selectedSalesmanCodes.remove(se.seCode);
            _controller.selectedSalesmanNames.remove(se.seName);
          }
        },
        onSelectAll: _controller.selectAllSalesmen,
        onClearAll: () {
          _controller.selectedSalesmanCodes.clear();
          _controller.selectedSalesmanNames.clear();
        },
        onSearchChanged: (value) {
          _controller.filteredSalesmen.value = _controller.salesmen
              .where(
                (se) => se.seName.toLowerCase().contains(value.toLowerCase()),
              )
              .toList();
        },
      ),
      isScrollControlled: true,
    );
  }

  void showEngineerSelectionBottomSheet(BuildContext context, bool tablet) {
    Get.bottomSheet(
      SelectionBottomSheet<EngineerDm>(
        title: 'Select Engineer',
        items: _controller.filteredEngineers,
        selectedCodes: _controller.selectedEngineerCodes,
        selectedNames: _controller.selectedEngineerNames,
        itemNameGetter: (er) => er.eName,
        itemCodeGetter: (er) => er.eCode,
        searchController: _controller.searchEngineerController,
        onSelectionChanged: (selected, er) {
          if (selected == true) {
            _controller.selectedEngineerCodes.add(er.eCode);
            _controller.selectedEngineerNames.add(er.eName);
          } else {
            _controller.selectedEngineerCodes.remove(er.eCode);
            _controller.selectedEngineerNames.remove(er.eName);
          }
        },
        onSelectAll: _controller.selectAllEngineers,
        onClearAll: () {
          _controller.selectedEngineerCodes.clear();
          _controller.selectedEngineerNames.clear();
        },
        onSearchChanged: (value) {
          _controller.filteredEngineers.value = _controller.engineers
              .where(
                (er) => er.eName.toLowerCase().contains(value.toLowerCase()),
              )
              .toList();
        },
      ),
      isScrollControlled: true,
    );
  }
}
