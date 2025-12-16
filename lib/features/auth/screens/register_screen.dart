// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/auth/controllers/register_controller.dart';
import 'package:sanghvi_job_card/features/auth/screens/animated_background.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/extensions/app_size_extensions.dart';
import 'package:sanghvi_job_card/utils/formatters/text_input_formatters.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_button.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_text_form_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController _controller = Get.put(RegisterController());

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
                    child: Container(
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
                            kColorWhite.withOpacity(0.08),
                            kColorWhite.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: kColorWhite.withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kColorBlack.withOpacity(0.4),
                            blurRadius: 40,
                            spreadRadius: 5,
                            offset: const Offset(0, 15),
                          ),
                          BoxShadow(
                            color: kColorWhite.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: -5,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _controller.registerFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Create Account',
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
                                ? AppSpaces.v2
                                : tablet
                                ? AppSpaces.v12
                                : AppSpaces.v6,
                            Text(
                              'Please fill in the details to register.',
                              style: TextStyles.kRegularOutfit(
                                fontSize: web
                                    ? FontSizes.k14FontSize
                                    : tablet
                                    ? FontSizes.k24FontSize
                                    : FontSizes.k18FontSize,
                                color: kColorWhite.withOpacity(0.9),
                              ),
                            ),
                            web
                                ? AppSpaces.v14
                                : tablet
                                ? AppSpaces.v24
                                : AppSpaces.v18,
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.firstNameController,
                                    hintText: 'First Name',
                                    floatingLabelRequired: false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter first name';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      TitleCaseTextInputFormatter(),
                                    ],
                                  ),
                                ),
                                web
                                    ? AppSpaces.h6
                                    : tablet
                                    ? AppSpaces.h16
                                    : AppSpaces.h10,
                                Expanded(
                                  child: AppTextFormField(
                                    controller: _controller.lastNameController,
                                    hintText: 'Last Name',
                                    floatingLabelRequired: false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter last name';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      TitleCaseTextInputFormatter(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            web
                                ? AppSpaces.v10
                                : tablet
                                ? AppSpaces.v20
                                : AppSpaces.v14,
                            AppTextFormField(
                              controller: _controller.mobileNumberController,
                              hintText: 'Mobile Number',
                              floatingLabelRequired: false,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a mobile number';
                                }
                                if (value.length != 10) {
                                  return 'Mobile number must be 10 digits';
                                }
                                return null;
                              },
                              inputFormatters: [
                                MobileNumberInputFormatter(),
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                            web
                                ? AppSpaces.v10
                                : tablet
                                ? AppSpaces.v20
                                : AppSpaces.v14,
                            Obx(
                              () => AppTextFormField(
                                controller: _controller.passwordController,
                                hintText: 'Password',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 3) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                floatingLabelRequired: false,
                                isObscure: _controller.obscuredPassword.value,
                                suffixIcon: IconButton(
                                  onPressed:
                                      _controller.togglePasswordVisibility,
                                  icon: Icon(
                                    _controller.obscuredPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: web ? 20 : (tablet ? 25 : 20),
                                    color: kColorBlack,
                                  ),
                                ),
                              ),
                            ),
                            web
                                ? AppSpaces.v10
                                : tablet
                                ? AppSpaces.v20
                                : AppSpaces.v14,
                            Obx(
                              () => AppTextFormField(
                                controller:
                                    _controller.confirmPasswordController,
                                hintText: 'Confirm Password',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value !=
                                      _controller.passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                floatingLabelRequired: false,
                                isObscure:
                                    _controller.obscuredConfirmPassword.value,
                                suffixIcon: IconButton(
                                  onPressed: _controller
                                      .toggleConfirmPasswordVisibility,
                                  icon: Icon(
                                    _controller.obscuredConfirmPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: web ? 20 : (tablet ? 25 : 20),
                                    color: kColorBlack,
                                  ),
                                ),
                              ),
                            ),
                            web
                                ? AppSpaces.v14
                                : tablet
                                ? AppSpaces.v24
                                : AppSpaces.v18,
                            AppButton(
                              title: 'Register',
                              onPressed: () {
                                _controller.hasAttemptedRegister.value = true;
                                if (_controller.registerFormKey.currentState!
                                    .validate()) {
                                  _controller.registerUser();
                                }
                              },
                            ),
                            web
                                ? AppSpaces.v14
                                : tablet
                                ? AppSpaces.v20
                                : AppSpaces.v14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyles.kRegularOutfit(
                                    fontSize: web
                                        ? FontSizes.k12FontSize
                                        : tablet
                                        ? FontSizes.k20FontSize
                                        : FontSizes.k14FontSize,
                                    color: kColorWhite,
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Text(
                                      'Sign In',
                                      style:
                                          TextStyles.kSemiBoldOutfit(
                                            fontSize: web
                                                ? FontSizes.k12FontSize
                                                : tablet
                                                ? FontSizes.k20FontSize
                                                : FontSizes.k14FontSize,
                                            color: kColorWhite,
                                          ).copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: kColorWhite,
                                          ),
                                    ),
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
              ),
            ),
          ),
        ),
        Obx(() => AppLoadingOverlay(isLoading: _controller.isLoading.value)),
      ],
    );
  }
}
