// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/brand_master/models/item_master_dm.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_card.dart';

class ItemMasterCard extends StatelessWidget {
  final ItemMasterDm item;
  final VoidCallback? onEdit;

  const ItemMasterCard({super.key, required this.item, this.onEdit});

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
                    item.iName,
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

            if (item.description.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Description',
                value: item.description,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.weightPer10Nos.isNotEmpty || item.mrp.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.weightPer10Nos.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Weight Per 10 Nos',
                        value: item.weightPer10Nos,
                        isTablet: isTablet,
                      ),
                    ),
                  if (item.weightPer10Nos.isNotEmpty && item.mrp.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (item.mrp.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'MRP',
                        value: '₹${item.mrp}',
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.reelColour.isNotEmpty || item.reelType.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.reelColour.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Reel Colour',
                        value: item.reelColour,
                        isTablet: isTablet,
                      ),
                    ),
                  if (item.reelColour.isNotEmpty && item.reelType.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (item.reelType.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Reel Type',
                        value: item.reelType,
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.outerColour.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Outer Colour',
                value: item.outerColour,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.reelPrintColour.isNotEmpty ||
                item.outerPrintColour.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.reelPrintColour.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Reel Print Colour',
                        value: item.reelPrintColour,
                        isTablet: isTablet,
                      ),
                    ),
                  if (item.reelPrintColour.isNotEmpty &&
                      item.outerPrintColour.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (item.outerPrintColour.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Outer Print Colour',
                        value: item.outerPrintColour,
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.nos10Packing.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Packing 10 Nos',
                value: item.nos10Packing,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.innerBoxLabel.isNotEmpty ||
                item.innerBoxQty.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.innerBoxLabel.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Inner Box Label',
                        value: item.innerBoxLabel,
                        isTablet: isTablet,
                      ),
                    ),
                  if (item.innerBoxLabel.isNotEmpty &&
                      item.innerBoxQty.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (item.innerBoxQty.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Inner Box Qty',
                        value: item.innerBoxQty,
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.innerBoxColour.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Inner Box Colour',
                value: item.innerBoxColour,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.masterBoxType.isNotEmpty ||
                item.masterBoxColour.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.masterBoxType.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Master Box Type',
                        value: item.masterBoxType,
                        isTablet: isTablet,
                      ),
                    ),
                  if (item.masterBoxType.isNotEmpty &&
                      item.masterBoxColour.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (item.masterBoxColour.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Master Box Colour',
                        value: item.masterBoxColour,
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (item.masterBoxLabel.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Master Box Label',
                value: item.masterBoxLabel,
                isTablet: isTablet,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
