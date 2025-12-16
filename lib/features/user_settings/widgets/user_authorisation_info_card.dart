import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_card.dart';
import 'package:sanghvi_job_card/widgets/app_title_value_container.dart';

class UserAuthorisationInfoCard extends StatelessWidget {
  const UserAuthorisationInfoCard({
    super.key,
    required this.fullName,
    required this.mobileNo,
  });

  final String fullName;
  final String mobileNo;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fullName,
            style: TextStyles.kMediumOutfit(fontSize: FontSizes.k18FontSize),
          ),
          AppSpaces.v10,
          AppTitleValueContainer(title: 'Mobile No.', value: mobileNo),
        ],
      ),
      onTap: () {},
    );
  }
}
