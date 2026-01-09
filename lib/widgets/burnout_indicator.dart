import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/burnout_model.dart';

class BurnoutIndicator extends StatelessWidget {
  final BurnoutLevel level;
  final String? label;
  
  const BurnoutIndicator({
    super.key,
    required this.level,
    this.label,
  });
  
  Color get _color {
    switch (level) {
      case BurnoutLevel.low:
        return AppTheme.burnoutLowColor;
      case BurnoutLevel.medium:
        return AppTheme.burnoutMediumColor;
      case BurnoutLevel.high:
        return AppTheme.burnoutHighColor;
    }
  }
  
  String get _text {
    switch (level) {
      case BurnoutLevel.low:
        return 'LOW';
      case BurnoutLevel.medium:
        return 'MEDIUM';
      case BurnoutLevel.high:
        return 'HIGH';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label ?? _text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
