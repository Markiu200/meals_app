import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/models/category.dart';

// To handle explicit animations, widget with animation must be stateful
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// "SingleTickerProviderStateMixin" Mixin is needed for animations.
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();

    // must be initialized before build(), but not in class body (for reasons?)
    //
    // "this" as this class, as it now with SingleTickerProviderStateMixin has
    // what it needs.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0, // default anyway
      upperBound: 1, // default anyway
    );

    // this plays animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // used dispose() in expense tracker to dispose input controllers
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals =
        widget.availableMeals
            .where((meal) => meal.categories.contains(category.id))
            .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (ctx) => MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AnimationController won't actually run build() every tick. Instead you'll
    // need to let it know what to rebuild using AnimatedBuilder().
    return AnimatedBuilder(
      // builder: is what will be rendered every tick.
      // child - here you pass what shouldn't be rebuid, even though is wrapped by
      // a thing that we actually want animated. This is to improve performance.
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            ),
        ],
      ),
      builder:
          // In this case, it's Padding that will be evaluated every tick. "child"
          // is the part that will be not evaluated.
          (context, child) => Padding(
            padding: EdgeInsets.only(
              top: 100 - _animationController.value * 100,
            ),
            child: child,
          ),
    );
  }
}
