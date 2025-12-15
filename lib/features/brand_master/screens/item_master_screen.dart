import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/brand_master/controllers/item_master_controller.dart';
import 'package:sanghvi_job_card/features/brand_master/models/color_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/item_master_dm.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:sanghvi_job_card/widgets/app_button.dart';
import 'package:sanghvi_job_card/widgets/app_dropdown.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_text_form_field.dart';

class ItemMasterScreen extends StatelessWidget {
  ItemMasterScreen({super.key});

  final _controller = Get.put(ItemMasterController());

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    final ItemMasterDm? editingItem = Get.arguments as ItemMasterDm?;
    if (editingItem != null && !_controller.isEditMode.value) {
      _controller.autoFillDataForEdit(editingItem);
    }

    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppAppbar(
              title: 'Brand Master',
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
                              controller: _controller.iNameController,
                              hintText: 'Item Name',
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please enter item name'
                                  : null,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.tapeDimensionController,
                              hintText: 'Tape Dimension',
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please enter tape dimension'
                                  : null,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Party Code',
                                items: _controller.partyNames,
                                selectedItem:
                                    _controller.selectedParty.value != null
                                    ? '${_controller.selectedParty.value!.pCode} - ${_controller.selectedParty.value!.pName}'
                                    : null,
                                onChanged: _controller.onPartySelected,
                                validatorText: 'Please select a party',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.mrpController,
                                    hintText: 'MRP',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'),
                                      ),
                                    ],
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.weightPer10KgController,
                                    hintText: 'Weight Per 10 Kg',
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Reel Colour',
                                items: [
                                  '+ Add New Colour',
                                  ..._controller.colorNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedReelColour
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedReelColour.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New Colour') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Colour',
                                      hintText: 'Enter colour name',
                                      onAdd: (value) {
                                        final newColour = ColorDm(value: value);
                                        _controller.colorList.add(newColour);
                                        _controller.colorNames.add(value);
                                        _controller.selectedReelColour.value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onReelColourSelected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText: 'Please select reel colour',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Reel Type',
                                items: _controller.reelTypeNames,
                                selectedItem:
                                    _controller
                                        .selectedReelType
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedReelType.value
                                    : null,
                                onChanged: _controller.onReelTypeSelected,
                                validatorText: 'Please select reel type',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Outer Colour',
                                items: [
                                  '+ Add New Colour',
                                  ..._controller.colorNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedOuterColour
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedOuterColour.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New Colour') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Colour',
                                      hintText: 'Enter colour name',
                                      onAdd: (value) {
                                        final newColour = ColorDm(value: value);
                                        _controller.colorList.add(newColour);
                                        _controller.colorNames.add(value);
                                        _controller.selectedOuterColour.value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onOuterColourSelected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText: 'Please select outer colour',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Reel Print Colour',
                                items: [
                                  '+ Add New Colour',
                                  ..._controller.colorNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedReelPrintColour
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedReelPrintColour.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New Colour') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Colour',
                                      hintText: 'Enter colour name',
                                      onAdd: (value) {
                                        final newColour = ColorDm(value: value);
                                        _controller.colorList.add(newColour);
                                        _controller.colorNames.add(value);
                                        _controller
                                                .selectedReelPrintColour
                                                .value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onReelPrintColourSelected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText:
                                    'Please select reel print colour',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Outer Print Colour',
                                items: [
                                  '+ Add New Colour',
                                  ..._controller.colorNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedOuterPrintColour
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedOuterPrintColour.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New Colour') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Colour',
                                      hintText: 'Enter colour name',
                                      onAdd: (value) {
                                        final newColour = ColorDm(value: value);
                                        _controller.colorList.add(newColour);
                                        _controller.colorNames.add(value);
                                        _controller
                                                .selectedOuterPrintColour
                                                .value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onOuterPrintColourSelected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText:
                                    'Please select outer print colour',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Packing 10 Nos',
                                items: _controller.nosPackingNames,
                                selectedItem:
                                    _controller
                                        .selectedPacking10Nos
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedPacking10Nos.value
                                    : null,
                                onChanged: _controller.onPacking10NosSelected,
                                validatorText: 'Please select packing',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Inner Box Label',
                                items: _controller.innerBoxLabelNames,
                                selectedItem:
                                    _controller
                                        .selectedInnerBoxLabel
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedInnerBoxLabel.value
                                    : null,
                                onChanged: _controller.onInnerBoxLabelSelected,
                                validatorText: 'Please select inner box label',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.innerBoxQtyController,
                              hintText: 'Inner Box Qty',
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Inner Box Colour',
                                items: [
                                  '+ Add New Colour',
                                  ..._controller.colorNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedInnerBoxColour
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedInnerBoxColour.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New Colour') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Colour',
                                      hintText: 'Enter colour name',
                                      onAdd: (value) {
                                        final newColour = ColorDm(value: value);
                                        _controller.colorList.add(newColour);
                                        _controller.colorNames.add(value);
                                        _controller
                                                .selectedInnerBoxColour
                                                .value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onInnerBoxColourSelected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText: 'Please select inner box colour',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.masterBoxTypeController,
                              hintText: 'Master Box Type',
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Master Box Colour',
                                items: [
                                  '+ Add New Colour',
                                  ..._controller.colorNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedMasterBoxColour
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedMasterBoxColour.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New Colour') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Colour',
                                      hintText: 'Enter colour name',
                                      onAdd: (value) {
                                        final newColour = ColorDm(value: value);
                                        _controller.colorList.add(newColour);
                                        _controller.colorNames.add(value);
                                        _controller
                                                .selectedMasterBoxColour
                                                .value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onMasterBoxColourSelected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText:
                                    'Please select master box colour',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Master Box Label',
                                items: _controller.masterBoxLabelNames,
                                selectedItem:
                                    _controller
                                        .selectedMasterBoxLabel
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedMasterBoxLabel.value
                                    : null,
                                onChanged: _controller.onMasterBoxLabelSelected,
                                validatorText: 'Please select master box label',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller:
                                  _controller.extraPrintedReelKgController,
                              hintText: 'Extra Printed Reel Kg',
                              keyboardType: TextInputType.number,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.extraInnerBoxController,
                                    hintText: 'Extra Inner Box',
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.extraOuterBoxController,
                                    hintText: 'Extra Outer Box',
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.extraTapeNosController,
                                    hintText: 'Extra Tape Nos',
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.extraOuterController,
                                    hintText: 'Extra Outer',
                                    keyboardType: TextInputType.number,
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
                        _controller.saveItemMaster();
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
