import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/brand_master/controllers/item_master_entry_controller.dart';
import 'package:sanghvi_job_card/features/brand_master/screens/item_master_screen.dart';
import 'package:sanghvi_job_card/features/brand_master/widgets/item_master_card.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/widgets/app_appbar.dart';
import 'package:sanghvi_job_card/widgets/app_loading_overlay.dart';
import 'package:sanghvi_job_card/widgets/app_text_button_with_icon.dart';

class ItemMasterEntryScreen extends StatelessWidget {
  ItemMasterEntryScreen({super.key});

  final ItemMasterEntryController _controller = Get.put(
    ItemMasterEntryController(),
  );

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return Stack(
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
            actions: [
              Padding(
                padding: AppPaddings.custom(right: tablet ? 24 : 16),
                child: AppTextButtonWithIcon(
                  onPressed: () {
                    Get.to(() => ItemMasterScreen());
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
                  if (_controller.itemList.isEmpty &&
                      !_controller.isLoading.value) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'No items found.',
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
                      itemCount: _controller.itemList.length,
                      itemBuilder: (context, index) {
                        final item = _controller.itemList[index];
                        return ItemMasterCard(
                          item: item,
                          onEdit: () {
                            Get.to(() => ItemMasterScreen(), arguments: item);
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
