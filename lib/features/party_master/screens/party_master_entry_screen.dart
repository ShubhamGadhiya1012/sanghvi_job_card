import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/party_master/controllers/party_master_entry_controller.dart';
import 'package:sanghvi_job_card/features/party_master/screens/party_master_screen.dart';
import 'package:sanghvi_job_card/features/party_master/widgets/party_master_card.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_text_button_with_icon.dart';

class PartyMasterEntryScreen extends StatelessWidget {
  PartyMasterEntryScreen({super.key});

  final PartyMasterEntryController _controller = Get.put(
    PartyMasterEntryController(),
  );

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return Stack(
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
            actions: [
              Padding(
                padding: AppPaddings.custom(right: tablet ? 24 : 16),
                child: AppTextButtonWithIcon(
                  onPressed: () {
                    Get.to(() => PartyMasterScreen());
                  },
                  title: 'Add New',
                  icon: Icons.add,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: tablet
                ? AppPaddings.combined(horizontal: 24, vertical: 12)
                : AppPaddings.p10,
            child: Column(
              children: [
                Obx(() {
                  if (_controller.partyList.isEmpty &&
                      !_controller.isLoading.value) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'No parties found.',
                          style: TextStyles.kMediumOutfit(
                            fontSize: tablet
                                ? FontSizes.k26FontSize
                                : FontSizes.k18FontSize,
                            color: kColorTextPrimary,
                          ),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: _controller.partyList.length,
                      itemBuilder: (context, index) {
                        final party = _controller.partyList[index];
                        return PartyMasterCard(
                          party: party,
                          onEdit: () {
                            Get.to(() => PartyMasterScreen(), arguments: party);
                          },
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Obx(() => AppLoadingOverlay(isLoading: _controller.isLoading.value)),
      ],
    );
  }
}
