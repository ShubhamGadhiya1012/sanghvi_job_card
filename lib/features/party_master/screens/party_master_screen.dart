import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/party_master/controllers/party_master_controller.dart';
import 'package:sanghvi_job_card/features/party_master/models/city_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/location_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/state_dm.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:sanghvi_job_card/widgets/app_button.dart';
import 'package:sanghvi_job_card/widgets/app_dropdown.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_text_form_field.dart';

class PartyMasterScreen extends StatelessWidget {
  PartyMasterScreen({super.key});

  final _controller = Get.put(PartyMasterController());

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    final PartyMasterDm? editingItem = Get.arguments as PartyMasterDm?;
    if (editingItem != null && !_controller.isEditMode.value) {
      _controller.autoFillDataForEdit(editingItem);
    }

    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppAppbar(
              title: 'Party Master',
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: tablet ? 25 : 20,
                  color: kColorPrimary,
                ),
              ),
            ),
            body: Padding(
              padding: tablet
                  ? AppPaddings.combined(horizontal: 24, vertical: 12)
                  : AppPaddings.p10,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _controller.formKey,
                        child: Column(
                          children: [
                            tablet ? AppSpaces.v10 : AppSpaces.v6,
                            AppTextFormField(
                              controller: _controller.accountNameController,
                              hintText: 'Account Name',
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please enter account name'
                                  : null,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.printNameController,
                              hintText: 'Print Name',
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please enter print name'
                                  : null,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Location',
                                items: [
                                  '+ Add New Location',
                                  ..._controller.locationNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedLocation
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedLocation.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New Location') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Location',
                                      hintText: 'Enter location name',
                                      onAdd: (value) {
                                        final newLocation = LocationDm(
                                          value: value,
                                        );
                                        _controller.locationList.add(
                                          newLocation,
                                        );
                                        _controller.locationNames.add(value);
                                        _controller.selectedLocation.value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onLocationSelected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText: 'Please select a location',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.addressLine1Controller,
                              hintText: 'Address Line 1',
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.addressLine2Controller,
                              hintText: 'Address Line 2',
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.addressLine3Controller,
                              hintText: 'Address Line 3',
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => AppDropdown(
                                      hintText: 'City',
                                      items: [
                                        '+ Add New City',
                                        ..._controller.cityNames,
                                      ],
                                      selectedItem:
                                          _controller
                                              .selectedCity
                                              .value
                                              .isNotEmpty
                                          ? _controller.selectedCity.value
                                          : null,
                                      onChanged: (selectedValue) {
                                        if (selectedValue == '+ Add New City') {
                                          _showAddNewDialog(
                                            context,
                                            title: 'Add New City',
                                            hintText: 'Enter city name',
                                            onAdd: (value) {
                                              final newCity = CityDm(
                                                value: value,
                                              );
                                              _controller.cityList.add(newCity);
                                              _controller.cityNames.add(value);
                                              _controller.selectedCity.value =
                                                  value;
                                            },
                                          );
                                        } else {
                                          _controller.onCitySelected(
                                            selectedValue,
                                          );
                                        }
                                      },
                                      validatorText: 'Please select a city',
                                    ),
                                  ),
                                ),
                                tablet ? AppSpaces.h6 : AppSpaces.h10,
                                Expanded(
                                  child: Obx(
                                    () => AppDropdown(
                                      hintText: 'State',
                                      items: [
                                        '+ Add New State',
                                        ..._controller.stateNames,
                                      ],
                                      selectedItem:
                                          _controller
                                              .selectedState
                                              .value
                                              .isNotEmpty
                                          ? _controller.selectedState.value
                                          : null,
                                      onChanged: (selectedValue) {
                                        if (selectedValue ==
                                            '+ Add New State') {
                                          _showAddNewDialog(
                                            context,
                                            title: 'Add New State',
                                            hintText: 'Enter state name',
                                            onAdd: (value) {
                                              final newState = StateDm(
                                                value: value,
                                              );
                                              _controller.stateList.add(
                                                newState,
                                              );
                                              _controller.stateNames.add(value);
                                              _controller.selectedState.value =
                                                  value;
                                            },
                                          );
                                        } else {
                                          _controller.onStateSelected(
                                            selectedValue,
                                          );
                                        }
                                      },
                                      validatorText: 'Please select a state',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.pinCodeController,
                              hintText: 'Pin Code',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.personNameController,
                              hintText: 'Person Name',
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.phone1Controller,
                                    hintText: 'Phone 1',
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.phone2Controller,
                                    hintText: 'Phone 2',
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.mobileController,
                              hintText: 'Mobile',
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.gstNumberController,
                                    hintText: 'GST Number',
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.panNumberController,
                                    hintText: 'PAN Number',
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v26 : AppSpaces.v20,
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    title: _controller.isEditMode.value ? 'Update' : 'Submit',
                    buttonHeight: tablet ? 45 : null,
                    onPressed: () {
                      if (_controller.formKey.currentState!.validate()) {
                        _controller.savePartyMaster();
                      }
                    },
                  ),
                  tablet ? AppSpaces.v10 : AppSpaces.v6,
                ],
              ),
            ),
          ),
          if (_controller.isLoading.value) AppLoadingOverlay(isLoading: true),
        ],
      ),
    );
  }

  Future<void> _showAddNewDialog(
    BuildContext context, {
    required String title,
    required String hintText,
    required Function(String) onAdd,
  }) async {
    final newItemController = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    final bool tablet = AppScreenUtils.isTablet(context);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tablet ? 16 : 12),
        ),
        backgroundColor: kColorWhite,
        elevation: 8,
        child: Container(
          width: tablet ? 500 : double.infinity,
          constraints: BoxConstraints(
            maxWidth: tablet ? 500 : MediaQuery.of(context).size.width * 0.9,
          ),
          child: Padding(
            padding: tablet ? AppPaddings.p24 : AppPaddings.p20,
            child: Form(
              key: dialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: tablet ? 20 : 18,
                            fontWeight: FontWeight.w600,
                            color: kColorPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          color: kColorGrey,
                          size: tablet ? 24 : 20,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  tablet ? AppSpaces.v24 : AppSpaces.v20,
                  AppTextFormField(
                    controller: newItemController,
                    hintText: hintText,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Please enter at least 2 characters';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      if (dialogFormKey.currentState!.validate()) {
                        onAdd(newItemController.text.trim());
                        Get.back();
                      }
                    },
                  ),
                  tablet ? AppSpaces.v24 : AppSpaces.v20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: kColorDarkGrey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: AppPaddings.combined(
                              vertical: tablet ? 12 : 10,
                              horizontal: 0,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: kColorDarkGrey,
                              fontSize: tablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      tablet ? AppSpaces.h16 : AppSpaces.h12,
                      Expanded(
                        child: AppButton(
                          title: 'Add',
                          buttonColor: kColorPrimary,
                          titleColor: kColorWhite,
                          titleSize: tablet ? 16 : 14,
                          buttonHeight: tablet ? 50 : 45,
                          onPressed: () {
                            if (dialogFormKey.currentState!.validate()) {
                              onAdd(newItemController.text.trim());
                              Get.back();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
