import 'package:flutter/material.dart';

/// The three damage categories from the project handover.
const List<String> kDamageCategories = [
  'Pothole',
  'Crack',
  'Damaged surface',
];

/// Lets the admin choose the damage category by hand.
/// Used when AI detection is not available.
/// This is NOT an AI prediction. It is the admin's own choice.
class ManualCategoryPicker extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const ManualCategoryPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // If the saved value is not one of our 3 categories, show nothing
    // selected instead of crashing.
    final String? safeValue =
        kDamageCategories.contains(selected) ? selected : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI unavailable. Choose the damage category manually.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: safeValue,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            hint: const Text('Select category'),
            items: kDamageCategories
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}