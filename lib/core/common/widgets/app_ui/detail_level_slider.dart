import 'package:flutter/material.dart';

import 'package:cembostyle/core/theme/app_palette.dart';

class DetailLevelSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const DetailLevelSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppPalette.purple,
            inactiveTrackColor: AppPalette.divider,
            thumbColor: AppPalette.purple,
            overlayColor: AppPalette.purple.withOpacity(0.1),
            trackHeight: 2,
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 2,
            divisions: 2,
            onChanged: (newValue) => onChanged(newValue.round()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Simple', style: TextStyle(fontSize: 11)),
            Text('Basic', style: TextStyle(fontSize: 11)),
            Text('Sketch', style: TextStyle(fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
