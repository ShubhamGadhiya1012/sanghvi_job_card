// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/home/controllers/job_card_controller.dart';
import 'package:sanghvi_job_card/features/home/models/checked_dm.dart';
import 'package:sanghvi_job_card/features/home/models/job_card_dm.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:sanghvi_job_card/widgets/app_button.dart';
import 'package:sanghvi_job_card/widgets/app_date_picker_text_form_field.dart';
import 'package:sanghvi_job_card/widgets/app_dropdown.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_text_form_field.dart';

class JobCardScreen extends StatelessWidget {
  JobCardScreen({super.key});

  final _controller = Get.put(JobCardController());

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    final JobCardDm? editingItem = Get.arguments as JobCardDm?;
    if (editingItem != null && !_controller.isEditMode.value) {
      _controller.autoFillDataForEdit(editingItem);
    }

    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppAppbar(
              title: 'Job Card',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tablet ? AppSpaces.v10 : AppSpaces.v6,
                            AppDatePickerTextFormField(
                              dateController: _controller.dateController,
                              hintText: 'Date',
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Please select date'
                                  : null,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Party Name',
                                items: _controller.partyNames,
                                selectedItem:
                                    _controller.selectedParty.value?.pName,
                                onChanged: _controller.onPartySelected,
                                validatorText: 'Please select a party',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.poNoController,
                                    hintText: 'PO No',
                                    validator: (value) =>
                                        value == null || value.trim().isEmpty
                                        ? 'Please enter PO no'
                                        : null,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppDatePickerTextFormField(
                                    dateController:
                                        _controller.poDateController,
                                    hintText: 'PO Date',
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? 'Please select PO date'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Item Name',
                                items: _controller.itemNames,
                                selectedItem:
                                    _controller.selectedItem.value?.iName,
                                onChanged: _controller.onItemSelected,
                                validatorText: 'Please select an item',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.tapeDimensionController,
                              hintText: 'Tape Dimension',
                              enabled: false,
                              fillColor: kColorLightGrey,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.weightPer10NosController,
                                    hintText: 'Weight Per 10 Nos',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.reelColourController,
                                    hintText: 'Reel Colour',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.reelTypeController,
                                    hintText: 'Reel Type',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.outerColourController,
                                    hintText: 'Outer Colour',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.mrpController,
                                    hintText: 'MRP on Reel',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.reelPrintColourController,
                                    hintText: 'Reel Print Colour',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller:
                                  _controller.outerPrintColourController,
                              hintText: 'Outer Print Colour',
                              enabled: false,
                              fillColor: kColorLightGrey,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.orderQtyController,
                                    hintText: 'Order Qty',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,3}'),
                                      ),
                                    ],
                                    validator: (value) =>
                                        value == null || value.trim().isEmpty
                                        ? 'Please enter order qty'
                                        : null,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.productionQtyController,
                                    hintText: 'Production Qty',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,3}'),
                                      ),
                                    ],
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
                                        _controller.packing10NosController,
                                    hintText: '10 Nos. Packing',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.innerBoxLabelController,
                                    hintText: 'Inner Box Label',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
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
                                        _controller.innerBoxQtyController,
                                    hintText: 'Inner Box Qty',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.innerBoxColourController,
                                    hintText: 'Inner Box Colour',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
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
                                        _controller.masterBoxTypeController,
                                    hintText: 'Master Box Type',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.masterBoxColourController,
                                    hintText: 'Master Box Colour',
                                    enabled: false,
                                    fillColor: kColorLightGrey,
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.masterBoxLabelController,
                              hintText: 'Master Box Label',
                              enabled: false,
                              fillColor: kColorLightGrey,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.extraInnerBoxController,
                                    hintText: 'Extra Inner Box',
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.extraOuterBoxController,
                                    hintText: 'Extra Outer Box',
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
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.extraOuterController,
                                    hintText: 'Extra Outer',
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.remarkController,
                              hintText: 'Remark',
                              maxLines: 3,
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Checked 1',
                                items: [
                                  '+ Add New',
                                  ..._controller.checkedNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedChecked1
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedChecked1.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Checked',
                                      hintText: 'Enter checked name',
                                      onAdd: (value) {
                                        final newChecked = CheckedDm(
                                          value: value,
                                        );
                                        _controller.checkedList.add(newChecked);
                                        _controller.checkedNames.add(value);
                                        _controller.selectedChecked1.value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onChecked1Selected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText: 'Please select checked 1',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                hintText: 'Checked 2',
                                items: [
                                  '+ Add New',
                                  ..._controller.checkedNames,
                                ],
                                selectedItem:
                                    _controller
                                        .selectedChecked2
                                        .value
                                        .isNotEmpty
                                    ? _controller.selectedChecked2.value
                                    : null,
                                onChanged: (selectedValue) {
                                  if (selectedValue == '+ Add New') {
                                    _showAddNewDialog(
                                      context,
                                      title: 'Add New Checked',
                                      hintText: 'Enter checked name',
                                      onAdd: (value) {
                                        final newChecked = CheckedDm(
                                          value: value,
                                        );
                                        _controller.checkedList.add(newChecked);
                                        _controller.checkedNames.add(value);
                                        _controller.selectedChecked2.value =
                                            value;
                                      },
                                    );
                                  } else {
                                    _controller.onChecked2Selected(
                                      selectedValue,
                                    );
                                  }
                                },
                                validatorText: 'Please select checked 2',
                              ),
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.extraPrintedReelController,
                                    hintText: 'Extra Printed Reel',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,3}'),
                                      ),
                                    ],
                                  ),
                                ),
                                tablet ? AppSpaces.h16 : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.nos10PackingController,
                                    hintText: 'Nos 10 Packing',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,3}'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'New Attachments (${_controller.attachmentFiles.length})',
                                  style: TextStyles.kMediumOutfit(
                                    fontSize: tablet
                                        ? FontSizes.k16FontSize
                                        : FontSizes.k14FontSize,
                                    color: kColorTextPrimary,
                                  ),
                                ),
                                AppButton(
                                  buttonWidth: tablet ? 150 : 120,
                                  buttonHeight: tablet ? 40 : 35,
                                  buttonColor: kColorPrimary,
                                  title: '+ Add File',
                                  titleSize: tablet
                                      ? FontSizes.k14FontSize
                                      : FontSizes.k12FontSize,
                                  onPressed: () =>
                                      _showAttachmentSourceDialog(context),
                                ),
                              ],
                            ),
                            tablet ? AppSpaces.v10 : AppSpaces.v6,
                            Obx(() {
                              if (_controller.attachmentFiles.isNotEmpty) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kColorDarkGrey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        _controller.attachmentFiles.length,
                                    separatorBuilder: (_, __) => Divider(
                                      height: 1,
                                      color: kColorGrey,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                    itemBuilder: (context, index) {
                                      final file =
                                          _controller.attachmentFiles[index];
                                      return ListTile(
                                        dense: true,
                                        leading: Icon(
                                          Icons.insert_drive_file,
                                          color: kColorTextPrimary,
                                          size: tablet ? 24 : 20,
                                        ),
                                        title: Text(
                                          file.name,
                                          style: TextStyles.kMediumOutfit(
                                            fontSize: tablet
                                                ? FontSizes.k14FontSize
                                                : FontSizes.k12FontSize,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          '${(file.size / 1024).toStringAsFixed(2)} KB',
                                          style: TextStyles.kRegularOutfit(
                                            fontSize: tablet
                                                ? FontSizes.k12FontSize
                                                : FontSizes.k10FontSize,
                                            color: kColorDarkGrey,
                                          ),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () =>
                                              _controller.removeFile(index),
                                          child: Icon(
                                            Icons.close,
                                            color: kColorRed,
                                            size: tablet ? 20 : 18,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                            tablet ? AppSpaces.v16 : AppSpaces.v10,
                            Obx(() {
                              if (_controller
                                  .existingAttachmentUrls
                                  .isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Existing Attachments (${_controller.existingAttachmentUrls.length})',
                                      style: TextStyles.kMediumOutfit(
                                        fontSize: tablet
                                            ? FontSizes.k16FontSize
                                            : FontSizes.k14FontSize,
                                        color: kColorTextPrimary,
                                      ),
                                    ),
                                    tablet ? AppSpaces.v10 : AppSpaces.v6,
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: kColorDarkGrey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _controller
                                            .existingAttachmentUrls
                                            .length,
                                        separatorBuilder: (_, __) => Divider(
                                          height: 1,
                                          color: kColorGrey,
                                          indent: 16,
                                          endIndent: 16,
                                        ),
                                        itemBuilder: (context, index) {
                                          final fileUrl = _controller
                                              .existingAttachmentUrls[index];
                                          final fileName = fileUrl
                                              .split('/')
                                              .last;
                                          return ListTile(
                                            dense: true,
                                            leading: Icon(
                                              Icons.cloud_download,
                                              color: kColorPrimary,
                                              size: tablet ? 24 : 20,
                                            ),
                                            title: Text(
                                              fileName,
                                              style: TextStyles.kMediumOutfit(
                                                fontSize: tablet
                                                    ? FontSizes.k14FontSize
                                                    : FontSizes.k12FontSize,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle: Text(
                                              'Tap to view',
                                              style: TextStyles.kRegularOutfit(
                                                fontSize: tablet
                                                    ? FontSizes.k12FontSize
                                                    : FontSizes.k10FontSize,
                                                color: kColorDarkGrey,
                                              ),
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () => _controller
                                                  .removeExistingAttachment(
                                                    index,
                                                  ),
                                              child: Icon(
                                                Icons.close,
                                                color: kColorRed,
                                                size: tablet ? 20 : 18,
                                              ),
                                            ),
                                            onTap: () => _controller
                                                .openAttachment(fileUrl),
                                          );
                                        },
                                      ),
                                    ),
                                    tablet ? AppSpaces.v16 : AppSpaces.v10,
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            }),
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
                        _controller.saveJobCard();
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

  void _showAttachmentSourceDialog(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.circular(tablet ? 20 : 16),
          ),
          padding: tablet ? AppPaddings.p24 : AppPaddings.p20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: AppPaddings.p10,
                    decoration: BoxDecoration(
                      color: kColorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.attachment,
                      color: kColorPrimary,
                      size: tablet ? 28 : 24,
                    ),
                  ),
                  tablet ? AppSpaces.h16 : AppSpaces.h12,
                  Expanded(
                    child: Text(
                      'Add Attachment',
                      style: TextStyles.kBoldOutfit(
                        fontSize: tablet
                            ? FontSizes.k20FontSize
                            : FontSizes.k18FontSize,
                        color: kColorTextPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: kColorDarkGrey,
                      size: tablet ? 28 : 24,
                    ),
                  ),
                ],
              ),
              tablet ? AppSpaces.v20 : AppSpaces.v16,
              Text(
                'Choose how you want to add your attachment',
                style: TextStyles.kRegularOutfit(
                  fontSize: tablet
                      ? FontSizes.k14FontSize
                      : FontSizes.k12FontSize,
                  color: kColorDarkGrey,
                ),
                textAlign: TextAlign.center,
              ),
              tablet ? AppSpaces.v24 : AppSpaces.v20,
              InkWell(
                onTap: () {
                  Get.back();
                  _controller.pickFromCamera();
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: tablet ? AppPaddings.p16 : AppPaddings.p12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kColorPrimary.withOpacity(0.1),
                        kColorPrimary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: kColorPrimary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: tablet ? AppPaddings.p12 : AppPaddings.p10,
                        decoration: BoxDecoration(
                          color: kColorPrimary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: kColorPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: kColorWhite,
                          size: tablet ? 28 : 24,
                        ),
                      ),
                      tablet ? AppSpaces.h16 : AppSpaces.h12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Take Photo',
                              style: TextStyles.kSemiBoldOutfit(
                                fontSize: tablet
                                    ? FontSizes.k16FontSize
                                    : FontSizes.k14FontSize,
                                color: kColorTextPrimary,
                              ),
                            ),
                            AppSpaces.v4,
                            Text(
                              'Capture using camera',
                              style: TextStyles.kRegularOutfit(
                                fontSize: tablet
                                    ? FontSizes.k12FontSize
                                    : FontSizes.k10FontSize,
                                color: kColorDarkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: kColorPrimary,
                        size: tablet ? 20 : 18,
                      ),
                    ],
                  ),
                ),
              ),
              tablet ? AppSpaces.v16 : AppSpaces.v12,
              InkWell(
                onTap: () {
                  Get.back();
                  _controller.pickFiles();
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: tablet ? AppPaddings.p16 : AppPaddings.p12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kColorPrimary.withOpacity(0.1),
                        kColorPrimary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: kColorPrimary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: tablet ? AppPaddings.p12 : AppPaddings.p10,
                        decoration: BoxDecoration(
                          color: kColorPrimary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: kColorPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.upload_file_rounded,
                          color: kColorWhite,
                          size: tablet ? 28 : 24,
                        ),
                      ),
                      tablet ? AppSpaces.h16 : AppSpaces.h12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload File',
                              style: TextStyles.kSemiBoldOutfit(
                                fontSize: tablet
                                    ? FontSizes.k16FontSize
                                    : FontSizes.k14FontSize,
                                color: kColorTextPrimary,
                              ),
                            ),
                            AppSpaces.v4,
                            Text(
                              'Choose from device storage',
                              style: TextStyles.kRegularOutfit(
                                fontSize: tablet
                                    ? FontSizes.k12FontSize
                                    : FontSizes.k10FontSize,
                                color: kColorDarkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: kColorPrimary,
                        size: tablet ? 20 : 18,
                      ),
                    ],
                  ),
                ),
              ),
              tablet ? AppSpaces.v12 : AppSpaces.v8,
            ],
          ),
        ),
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
