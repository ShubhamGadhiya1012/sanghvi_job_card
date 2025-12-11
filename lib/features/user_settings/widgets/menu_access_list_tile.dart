import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/user_settings/models/user_access_dm.dart';
import 'package:sanghvi_job_card/styles/font_sizes.dart';
import 'package:sanghvi_job_card/styles/text_styles.dart';

class MenuAccessListTile extends StatelessWidget {
  const MenuAccessListTile({
    super.key,
    required this.menuAccess,
    required this.onChanged,
  });

  final MenuAccessDm menuAccess;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Text(
            menuAccess.menuName,
            style: TextStyles.kMediumOutfit(
              fontSize: FontSizes.k18FontSize,
              color: kColorTextPrimary,
            ),
          ),
          trailing: Switch(
            value: menuAccess.access,
            activeColor: kColorPrimary,
            inactiveTrackColor: kColorWhite,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
