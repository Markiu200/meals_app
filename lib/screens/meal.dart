import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal.title)),
      body: Image.network(meal.imageUrl),
    );
  }
}
