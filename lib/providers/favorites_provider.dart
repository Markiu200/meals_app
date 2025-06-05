import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

// Notifier provider comes in two parts, kind of like StatefulWidget does.
// Type of StateNotifier is what kind of data is being "observed".
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  // Instead of key, you initialize class with default, starting state - here
  // empty list (of Meals).
  FavoriteMealsNotifier() : super([]);

  void toggleMealFavoriteStatus(Meal meal) {
    // [state] is provided by StateNotifier. It holds the data to provide.
    // At start it should be "[]" as we had in constructor.
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      // [state] is immutable by design, so any changes to a list must be done by
      // creating brand new list every time.
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
  }
}

// While Provider() is good for providing static data, changing data is better
// handled by StateNotifierProvider()
//
// Type definitions is type of it's "pair" class, and second is what type of
// data is being observed (like in FavoriteMealsNotifier class).
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
      return FavoriteMealsNotifier();
    });
