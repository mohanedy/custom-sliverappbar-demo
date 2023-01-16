import 'package:flutter/material.dart';

class OutlinedChip extends StatelessWidget {
  const OutlinedChip({
    Key? key,
    required this.label,
    this.icon,
  }) : super(key: key);

  final String label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(
                width: 5,
              ),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
