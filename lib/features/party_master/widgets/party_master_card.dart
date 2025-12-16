// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_card.dart';

class PartyMasterCard extends StatelessWidget {
  final PartyMasterDm party;
  final VoidCallback? onEdit;

  const PartyMasterCard({super.key, required this.party, this.onEdit});

  Widget _buildInfoRow({
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 13 : 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 0.3,
          ),
        ),
        isTablet ? AppSpaces.v4 : AppSpaces.v2,
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 15 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppScreenUtils.isTablet(context);

    return AppCard(
      child: Padding(
        padding: isTablet ? AppPaddings.p16 : AppPaddings.p10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    party.pName,
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.w700,
                      color: kColorPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: AppPaddings.combined(
                      horizontal: isTablet ? 12 : 10,
                      vertical: isTablet ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: kColorPrimary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: isTablet ? 18 : 16,
                          color: kColorPrimary,
                        ),

                        AppSpaces.h6,
                        Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: isTablet ? 15 : 14,
                            fontWeight: FontWeight.w600,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            isTablet ? AppSpaces.v16 : AppSpaces.v12,
            Divider(height: 1, color: Colors.grey[300]),

            isTablet ? AppSpaces.v16 : AppSpaces.v12,

            if (party.printName.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Print Name',
                value: party.printName,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (party.location.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Location',
                value: party.location,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (party.address1.isNotEmpty ||
                party.address2.isNotEmpty ||
                party.address3.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Address',
                value: [
                  if (party.address1.isNotEmpty) party.address1,
                  if (party.address2.isNotEmpty) party.address2,
                  if (party.address3.isNotEmpty) party.address3,
                ].join(', '),
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (party.city.isNotEmpty || party.state.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (party.city.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'City',
                        value: party.city,
                        isTablet: isTablet,
                      ),
                    ),
                  if (party.city.isNotEmpty && party.state.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (party.state.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'State',
                        value: party.state,
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (party.mobile.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Mobile',
                value: party.mobile,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (party.gstNumber.isNotEmpty || party.panNumber.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (party.gstNumber.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'GST Number',
                        value: party.gstNumber,
                        isTablet: isTablet,
                      ),
                    ),
                  if (party.gstNumber.isNotEmpty && party.panNumber.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (party.panNumber.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'PAN Number',
                        value: party.panNumber,
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
