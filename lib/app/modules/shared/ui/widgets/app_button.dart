import 'package:controle_despesas/app/theme/spacing.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String name;
  final Color buttonColor;
  final Color shadowColor;
  final EdgeInsets padding;
  final IconData icon;
  final VoidCallback onTap;

  const AppButton({
    super.key,
    required this.name,
    required this.buttonColor,
    required this.shadowColor,
    required this.icon,
    required this.onTap,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: shadowColor,
              blurRadius: 0.0,
            ),
          ],
          color: buttonColor,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: Spacing.defaultSpacing / 4),
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
