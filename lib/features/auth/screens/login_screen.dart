// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/auth/controllers/login_controller.dart';
import 'package:sanghvi_job_card/features/auth/screens/animated_background.dart';
import 'package:sanghvi_job_card/features/auth/screens/register_screen.dart';
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

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController _controller = Get.put(LoginController());

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
                        key: _controller.loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Welcome Back!',
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
                              web
                                  ? 'Please sign in to your account to continue.'
                                  : 'Please sign in to your account\nto continue.',
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
                            AppTextFormField(
                              controller: _controller.mobileNumberController,
                              hintText: 'Mobile Number',
                              floatingLabelRequired: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a mobile number';
                                }
                                if (value.length != 10) {
                                  return 'Please enter a 10-digit mobile number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
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
                                  return null;
                                },
                                floatingLabelRequired: false,
                                isObscure: _controller.obscuredPassword.value,
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      _controller.togglePasswordVisibility(),
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
                                ? AppSpaces.v14
                                : tablet
                                ? AppSpaces.v24
                                : AppSpaces.v18,
                            AppButton(
                              title: 'Sign In',

                              onPressed: () {
                                _controller.hasAttemptedLogin.value = true;
                                if (_controller.loginFormKey.currentState!
                                    .validate()) {
                                  _controller.loginUser();
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
                                  'Don\'t have an account? ',
                                  style: TextStyles.kRegularOutfit(
                                    fontSize: web
                                        ? FontSizes.k12FontSize
                                        : tablet
                                        ? FontSizes.k18FontSize
                                        : FontSizes.k14FontSize,
                                    color: kColorWhite,
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => Get.to(() => RegisterScreen()),
                                    child: Text(
                                      'Sign Up',
                                      style:
                                          TextStyles.kSemiBoldOutfit(
                                            fontSize: web
                                                ? FontSizes.k12FontSize
                                                : tablet
                                                ? FontSizes.k18FontSize
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
