// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sanghvi_job_card/constants/color_constants.dart';
import 'package:sanghvi_job_card/features/home/models/job_card_dm.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_paddings.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_screen_utils.dart';
import 'package:sanghvi_job_card/utils/screen_utils/app_spacings.dart';
import 'package:sanghvi_job_card/widgets/app_card.dart';

class JobCardCard extends StatelessWidget {
  final JobCardDm jobCard;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onPrint;

  const JobCardCard({
    super.key,
    required this.jobCard,
    this.onPrint,
    this.onEdit,
    this.onDelete,
  });

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

  String _formatDate(String date) {
    if (date.isEmpty) return '-';
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppScreenUtils.isTablet(context);
    final attachmentCount = jobCard.attachments.isNotEmpty
        ? jobCard.attachments.split(',').length
        : 0;

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
                    jobCard.invno,
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.w700,
                      color: kColorPrimary,
                    ),
                  ),
                ),
                Row(
                  children: [
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
                          ],
                        ),
                      ),
                    ),

                    AppSpaces.h10,
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(8),

                      child: Container(
                        padding: AppPaddings.combined(
                          horizontal: isTablet ? 12 : 10,
                          vertical: isTablet ? 8 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: kColorRed.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: isTablet ? 18 : 16,
                              color: kColorRed,
                            ),
                          ],
                        ),
                      ),
                    ),

                    AppSpaces.h10,
                    InkWell(
                      onTap: onPrint,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: AppPaddings.combined(
                          horizontal: isTablet ? 12 : 10,
                          vertical: isTablet ? 8 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.print_outlined,
                              size: isTablet ? 18 : 16,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isTablet ? AppSpaces.v16 : AppSpaces.v12,
            Divider(height: 1, color: Colors.grey[300]),
            isTablet ? AppSpaces.v16 : AppSpaces.v12,

            if (jobCard.pName.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Party Name',
                value: jobCard.pName,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (jobCard.date.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Date',
                value: _formatDate(jobCard.date),
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (jobCard.poNo.isNotEmpty || jobCard.poDate.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (jobCard.poNo.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'PO No',
                        value: jobCard.poNo,
                        isTablet: isTablet,
                      ),
                    ),
                  if (jobCard.poNo.isNotEmpty && jobCard.poDate.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (jobCard.poDate.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'PO Date',
                        value: _formatDate(jobCard.poDate),
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (jobCard.iName.isNotEmpty) ...[
              _buildInfoRow(
                label: 'Item Name',
                value: jobCard.iName,
                isTablet: isTablet,
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (jobCard.orderQty.isNotEmpty ||
                jobCard.productionQty.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (jobCard.orderQty.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Order Qty',
                        value: jobCard.orderQty,
                        isTablet: isTablet,
                      ),
                    ),
                  if (jobCard.orderQty.isNotEmpty &&
                      jobCard.productionQty.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (jobCard.productionQty.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Production Qty',
                        value: jobCard.productionQty,
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (jobCard.checked1.isNotEmpty || jobCard.checked2.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (jobCard.checked1.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Checked 1',
                        value: jobCard.checked1,
                        isTablet: isTablet,
                      ),
                    ),
                  if (jobCard.checked1.isNotEmpty &&
                      jobCard.checked2.isNotEmpty)
                    isTablet ? AppSpaces.h16 : AppSpaces.h12,
                  if (jobCard.checked2.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        label: 'Checked 2',
                        value: jobCard.checked2,
                        isTablet: isTablet,
                      ),
                    ),
                ],
              ),
              isTablet ? AppSpaces.v12 : AppSpaces.v10,
            ],

            if (attachmentCount > 0) ...[
              Container(
                padding: AppPaddings.combined(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kColorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: isTablet ? 16 : 14,
                      color: kColorPrimary,
                    ),
                    AppSpaces.h4,
                    Text(
                      '$attachmentCount Attachment${attachmentCount > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 12,
                        fontWeight: FontWeight.w500,
                        color: kColorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
