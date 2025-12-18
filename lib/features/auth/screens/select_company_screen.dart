// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/auth/controllers/select_company_controller.dart';
import 'package:sanghvi_job_card/features/auth/models/company_dm.dart';
import 'package:sanghvi_job_card/features/auth/screens/animated_background.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/extensions/app_size_extensions.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_button.dart';
import 'package:sanghvi_job_card/widgets/app_dropdown.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';

class SelectCompanyScreen extends StatefulWidget {
  const SelectCompanyScreen({
    super.key,
    required this.companies,
    required this.mobileNumber,
  });

  final RxList<CompanyDm> companies;
  final String mobileNumber;

  @override
  State<SelectCompanyScreen> createState() => _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  final SelectCompanyController _controller = Get.put(
    SelectCompanyController(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.companies.length == 1) {
      _controller.selectedCoName.value = widget.companies.first.coName;
      _controller.selectedCoCode.value = widget.companies.first.coCode;
      _controller.selectedCid.value = widget.companies.first.cid;
      _controller.getYears();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);
    final bool web = AppScreenUtils.isWeb;

    return Stack(
      children: [
        const AnimatedBackground(),
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppPaddings.combined(
                    horizontal: web ? 24 : (tablet ? 0.08.screenWidth : 24),
                    vertical: web ? 40 : (tablet ? 0.04.screenHeight : 24),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: web ? 480 : double.infinity,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        web ? 10 : (tablet ? 20 : 10),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: double.infinity,
                          padding: web
                              ? AppPaddings.p32
                              : tablet
                              ? AppPaddings.p20
                              : AppPaddings.p16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              web ? 10 : (tablet ? 20 : 10),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.08),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 5,
                                offset: const Offset(0, 15),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: -5,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _controller.selectCompanyFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Container(
                                    padding: web
                                        ? AppPaddings.p16
                                        : (tablet
                                              ? AppPaddings.p20
                                              : AppPaddings.p16),

                                    decoration: BoxDecoration(
                                      color: kColorWhite.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: kColorWhite.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.business_outlined,
                                      size: web ? 40 : (tablet ? 50 : 40),
                                      color: kColorWhite,
                                    ),
                                  ),
                                ),
                                web
                                    ? AppSpaces.v16
                                    : tablet
                                    ? AppSpaces.v24
                                    : AppSpaces.v20,

                                // Title
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Select Company',
                                        style: TextStyles.kSemiBoldOutfit(
                                          fontSize: web
                                              ? FontSizes.k26FontSize
                                              : tablet
                                              ? FontSizes.k40FontSize
                                              : FontSizes.k30FontSize,
                                          color: kColorWhite,
                                        ),
                                      ),
                                      web
                                          ? AppSpaces.v4
                                          : tablet
                                          ? AppSpaces.v8
                                          : AppSpaces.v6,
                                      Text(
                                        web
                                            ? 'Choose your company and financial year'
                                            : 'Choose your company and\nfinancial year',
                                        style: TextStyles.kRegularOutfit(
                                          fontSize: web
                                              ? FontSizes.k14FontSize
                                              : tablet
                                              ? FontSizes.k20FontSize
                                              : FontSizes.k16FontSize,
                                          color: kColorWhite.withOpacity(0.85),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                web
                                    ? AppSpaces.v20
                                    : tablet
                                    ? AppSpaces.v30
                                    : AppSpaces.v24,

                                // Company Dropdown
                                Obx(
                                  () => AppDropdown(
                                    items: widget.companies
                                        .map((company) => company.coName)
                                        .toList(),
                                    hintText: 'Select Company',
                                    onChanged: (value) {
                                      _controller.selectedCoName.value = value!;
                                      _controller.selectedCoCode.value = widget
                                          .companies
                                          .firstWhere(
                                            (company) =>
                                                company.coName == value,
                                          )
                                          .coCode;
                                      _controller.selectedCid.value = widget
                                          .companies
                                          .firstWhere(
                                            (company) =>
                                                company.coName == value,
                                          )
                                          .cid;
                                      if (widget.companies.length > 1) {
                                        _controller.getYears();
                                      }
                                    },
                                    selectedItem:
                                        _controller
                                            .selectedCoName
                                            .value
                                            .isNotEmpty
                                        ? _controller.selectedCoName.value
                                        : null,
                                    validatorText: 'Please select a company',
                                  ),
                                ),
                                web
                                    ? AppSpaces.v10
                                    : tablet
                                    ? AppSpaces.v20
                                    : AppSpaces.v16,

                                // Financial Year Dropdown
                                Obx(
                                  () => AppDropdown(
                                    items: _controller.finYears,
                                    hintText: 'Financial Year',
                                    onChanged: _controller.onYearSelected,
                                    selectedItem:
                                        _controller
                                            .selectedFinYear
                                            .value
                                            .isNotEmpty
                                        ? _controller.selectedFinYear.value
                                        : null,
                                    validatorText:
                                        'Please select a financial year',
                                  ),
                                ),
                                web
                                    ? AppSpaces.v20
                                    : tablet
                                    ? AppSpaces.v30
                                    : AppSpaces.v24,

                                // Continue Button
                                AppButton(
                                  title: 'Continue',
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (_controller
                                        .selectCompanyFormKey
                                        .currentState!
                                        .validate()) {
                                      _controller.getToken(
                                        mobileNumber: widget.mobileNumber,
                                        cid: _controller.selectedCid.value!,
                                        yearId:
                                            _controller.selectedYearId.value,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
}
