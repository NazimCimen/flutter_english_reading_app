import 'package:flutter/material.dart';

class CategoryModel {
  final String emoji;
  final String name;
  final Color color;
  final String displayName;

  const CategoryModel({
    required this.emoji,
    required this.name,
    required this.color,
    required this.displayName,
  });
}
