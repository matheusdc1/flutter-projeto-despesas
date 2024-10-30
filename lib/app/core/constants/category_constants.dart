import 'package:flutter/material.dart';

enum CategoryType {
  food,
  transport,
  education,
  health,
  leisure,
  other,
}

class Category {
  final CategoryType type;
  final String name;
  final Color color;
  final IconData icon;

  const Category({
    required this.type,
    required this.name,
    required this.color,
    required this.icon,
  });

  static Category getByType(CategoryType type) {
    return appCategories.firstWhere(
      (category) => category.type == type,
      orElse: () => appCategories.last,
    );
  }
}

const List<Category> appCategories = [
  Category(
    type: CategoryType.food,
    name: 'Alimentação',
    color: Colors.blue,
    icon: Icons.restaurant,
  ),
  Category(
    type: CategoryType.transport,
    name: 'Transporte',
    color: Colors.orange,
    icon: Icons.directions_bus,
  ),
  Category(
    type: CategoryType.education,
    name: 'Educação',
    color: Colors.green,
    icon: Icons.school,
  ),
  Category(
    type: CategoryType.health,
    name: 'Saúde',
    color: Colors.red,
    icon: Icons.local_hospital,
  ),
  Category(
    type: CategoryType.leisure,
    name: 'Lazer',
    color: Colors.purple,
    icon: Icons.sports_soccer,
  ),
  Category(
    type: CategoryType.other,
    name: 'Outros',
    color: Colors.grey,
    icon: Icons.category,
  ),
];
