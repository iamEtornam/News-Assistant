import 'package:flutter/material.dart';
import 'package:news_assistant/components/color_schemes.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.5),
            border: Border.all(
                color:
                    isSelected ? Theme.of(context).colorScheme.primary : grey)),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Theme.of(context).colorScheme.primary : grey),
        ),
      ),
    );
  }
}
