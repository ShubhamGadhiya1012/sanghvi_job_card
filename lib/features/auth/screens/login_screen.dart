// Modified LoginScreen with developer password functionality

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/auth/controllers/login_controller.dart';
import 'package:sanghvi_job_card/features/auth/screens/animated_background.dart';
import 'package:sanghvi_job_card/features/auth/screens/register_screen.dart';
import 'package:sanghvi_job_card/services/api_service.dart';
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
  static const String fixedPassword = '2580';

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);
    final bool web = AppScreenUtils.isWeb;

    return Stack(
      children: [
        const AnimatedBackground(),
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          onLongPress: () async {
            await showPasswordDialog(context);
          },
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

  Future<void> showPasswordDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    final RxString errorText = ''.obs;
    final bool tablet = AppScreenUtils.isTablet(context);
    final bool web = AppScreenUtils.isWeb;

    final bool isPasswordCorrect =
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: web ? 400 : double.infinity,
                ),
                padding: web
                    ? AppPaddings.p24
                    : tablet
                    ? AppPaddings.p20
                    : AppPaddings.p16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      kColorWhite.withOpacity(0.95),
                      kColorWhite.withOpacity(0.85),
                    ],
                  ),
                  border: Border.all(
                    color: kColorPrimary.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kColorPrimary.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Header
                    Container(
                      padding: EdgeInsets.all(web ? 16 : (tablet ? 14 : 12)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            kColorPrimary,
                            kColorPrimary.withOpacity(0.7),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kColorPrimary.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: kColorWhite,
                        size: web ? 32 : (tablet ? 36 : 28),
                      ),
                    ),
                    web
                        ? AppSpaces.v14
                        : tablet
                        ? AppSpaces.v16
                        : AppSpaces.v12,

                    // Title
                    Text(
                      'Developer Access',
                      style: TextStyles.kSemiBoldOutfit(
                        fontSize: web
                            ? FontSizes.k22FontSize
                            : tablet
                            ? FontSizes.k28FontSize
                            : FontSizes.k20FontSize,
                        color: kColorBlack,
                      ),
                    ),
                    web
                        ? AppSpaces.v6
                        : tablet
                        ? AppSpaces.v8
                        : AppSpaces.v4,

                    Text(
                      'Enter password to access developer mode',
                      textAlign: TextAlign.center,
                      style: TextStyles.kRegularOutfit(
                        fontSize: web
                            ? FontSizes.k12FontSize
                            : tablet
                            ? FontSizes.k16FontSize
                            : FontSizes.k12FontSize,
                        color: kColorBlack.withOpacity(0.6),
                      ),
                    ),
                    web
                        ? AppSpaces.v20
                        : tablet
                        ? AppSpaces.v24
                        : AppSpaces.v16,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextFormField(
                          controller: passwordController,
                          hintText: 'Enter 4-digit password',
                          floatingLabelRequired: false,
                          keyboardType: TextInputType.number,

                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChanged: (value) {
                            if (errorText.value.isNotEmpty) {
                              errorText.value = '';
                            }
                          },
                        ),
                        Obx(
                          () => errorText.value.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    top: 8,
                                    left: web ? 12 : (tablet ? 14 : 10),
                                  ),
                                  child: Text(
                                    errorText.value,
                                    style: TextStyles.kRegularOutfit(
                                      fontSize: web
                                          ? FontSizes.k12FontSize
                                          : tablet
                                          ? FontSizes.k14FontSize
                                          : FontSizes.k12FontSize,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),
                    web
                        ? AppSpaces.v20
                        : tablet
                        ? AppSpaces.v24
                        : AppSpaces.v16,

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: web ? 12 : (tablet ? 14 : 12),
                              ),
                              side: BorderSide(
                                color: kColorBlack.withOpacity(0.3),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyles.kMediumOutfit(
                                fontSize: web
                                    ? FontSizes.k14FontSize
                                    : tablet
                                    ? FontSizes.k18FontSize
                                    : FontSizes.k14FontSize,
                                color: kColorBlack.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: web ? 12 : (tablet ? 16 : 12)),
                        Expanded(
                          child: AppButton(
                            onPressed: () {
                              if (passwordController.text.isEmpty) {
                                errorText.value = 'Please enter password';
                              } else if (passwordController.text.length < 4) {
                                errorText.value = 'Password must be 4 digits';
                              } else if (passwordController.text !=
                                  fixedPassword) {
                                errorText.value = 'Incorrect password';
                              } else {
                                Navigator.pop(context, true);
                              }
                            },
                            title: 'Submit',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;

    if (isPasswordCorrect) {
      await showBaseUrlSelectionDialog(context);
    }
  }

  Future<void> showBaseUrlSelectionDialog(BuildContext context) async {
    final bool tablet = AppScreenUtils.isTablet(context);
    final bool web = AppScreenUtils.isWeb;

    final String? selectedOption = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxWidth: web ? 400 : double.infinity),
            padding: web
                ? AppPaddings.p24
                : tablet
                ? AppPaddings.p20
                : AppPaddings.p16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kColorWhite.withOpacity(0.95),
                  kColorWhite.withOpacity(0.85),
                ],
              ),
              border: Border.all(
                color: kColorPrimary.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: kColorPrimary.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Header
                Container(
                  padding: EdgeInsets.all(web ? 16 : (tablet ? 14 : 12)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kColorPrimary, kColorPrimary.withOpacity(0.7)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kColorPrimary.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.settings_suggest_rounded,
                    color: kColorWhite,
                    size: web ? 32 : (tablet ? 36 : 28),
                  ),
                ),
                web
                    ? AppSpaces.v14
                    : tablet
                    ? AppSpaces.v16
                    : AppSpaces.v12,

                // Title
                Text(
                  'Select Mode',
                  style: TextStyles.kSemiBoldOutfit(
                    fontSize: web
                        ? FontSizes.k22FontSize
                        : tablet
                        ? FontSizes.k28FontSize
                        : FontSizes.k20FontSize,
                    color: kColorBlack,
                  ),
                ),
                web
                    ? AppSpaces.v6
                    : tablet
                    ? AppSpaces.v8
                    : AppSpaces.v4,

                // Subtitle
                Text(
                  'Choose your preferred server mode',
                  textAlign: TextAlign.center,
                  style: TextStyles.kRegularOutfit(
                    fontSize: web
                        ? FontSizes.k12FontSize
                        : tablet
                        ? FontSizes.k16FontSize
                        : FontSizes.k12FontSize,
                    color: kColorBlack.withOpacity(0.6),
                  ),
                ),
                web
                    ? AppSpaces.v20
                    : tablet
                    ? AppSpaces.v24
                    : AppSpaces.v16,

                // Live Mode Option
                InkWell(
                  onTap: () {
                    Navigator.pop(context, 'live');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(web ? 16 : (tablet ? 18 : 14)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.1),
                          Colors.green.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(web ? 8 : (tablet ? 10 : 8)),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cloud_done_rounded,
                            color: kColorWhite,
                            size: web ? 20 : (tablet ? 24 : 18),
                          ),
                        ),
                        SizedBox(width: web ? 12 : (tablet ? 14 : 10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Live Mode',
                                style: TextStyles.kSemiBoldOutfit(
                                  fontSize: web
                                      ? FontSizes.k16FontSize
                                      : tablet
                                      ? FontSizes.k20FontSize
                                      : FontSizes.k16FontSize,
                                  color: kColorBlack,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Production server',
                                style: TextStyles.kRegularOutfit(
                                  fontSize: web
                                      ? FontSizes.k12FontSize
                                      : tablet
                                      ? FontSizes.k14FontSize
                                      : FontSizes.k12FontSize,
                                  color: kColorBlack.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: web ? 16 : (tablet ? 18 : 14),
                          color: Colors.green.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: web ? 12 : (tablet ? 14 : 10)),

                // Jinee Mode Option
                InkWell(
                  onTap: () {
                    Navigator.pop(context, 'jinee');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(web ? 16 : (tablet ? 18 : 14)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.1),
                          Colors.blue.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(web ? 8 : (tablet ? 10 : 8)),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.developer_mode_rounded,
                            color: kColorWhite,
                            size: web ? 20 : (tablet ? 24 : 18),
                          ),
                        ),
                        SizedBox(width: web ? 12 : (tablet ? 14 : 10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jinee Mode',
                                style: TextStyles.kSemiBoldOutfit(
                                  fontSize: web
                                      ? FontSizes.k16FontSize
                                      : tablet
                                      ? FontSizes.k20FontSize
                                      : FontSizes.k16FontSize,
                                  color: kColorBlack,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Development server',
                                style: TextStyles.kRegularOutfit(
                                  fontSize: web
                                      ? FontSizes.k12FontSize
                                      : tablet
                                      ? FontSizes.k14FontSize
                                      : FontSizes.k12FontSize,
                                  color: kColorBlack.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: web ? 16 : (tablet ? 18 : 14),
                          color: Colors.blue.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedOption != null) {
      if (selectedOption == 'live') {
        ApiService.kBaseUrl = 'http://169.254.1.2:8081/api';
        Get.snackbar(
          'Mode Selected',
          'Live mode activated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else if (selectedOption == 'jinee') {
        ApiService.kBaseUrl = 'http://192.168.0.145:8080/api';
        Get.snackbar(
          'Mode Selected',
          'Jinee mode activated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    }
  }
}
