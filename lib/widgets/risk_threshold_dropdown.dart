import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';

/// Fixed-choice selector for Group.riskThresholdPercent — one of 25/50/75/100.
/// Not a free-text field: this value drives payout eligibility math
/// (paymentsRequiredForEligibility), so it must stay a closed set.
class RiskThresholdDropdown extends StatelessWidget {
  const RiskThresholdDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  static const _options = [25, 50, 75, 100];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payout eligibility threshold',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'How much of the cycle a member must pay before they can receive a payout',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: AppTheme.spacing12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
          decoration: BoxDecoration(
            color: AppTheme.primarySoft,
            borderRadius: BorderRadius.circular(AppTheme.radius20),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              icon: FaIcon(FontAwesomeIcons.chevronDown, size: 14, color: AppTheme.primary),
              borderRadius: BorderRadius.circular(AppTheme.radius16),
              dropdownColor: AppTheme.surface,
              items: _options
                  .map((percent) => DropdownMenuItem(
                        value: percent,
                        child: Text(
                          '$percent%${percent == 100 ? ' (full cycle)' : ''}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}