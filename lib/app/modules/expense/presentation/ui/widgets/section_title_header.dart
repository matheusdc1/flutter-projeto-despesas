import 'package:controle_despesas/app/theme/spacing.dart';
import 'package:flutter/material.dart';

class SectionTitleHeader extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const SectionTitleHeader(
      {required this.title,
      required this.color,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: Spacing.defaultSpacing / 2),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
        ),
      ],
    );
  }
}
