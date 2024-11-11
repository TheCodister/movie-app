// favorites_utils.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesUtils {
  // Function to save movie to favorites in local storage
  static Future<void> addToFavorites(
    BuildContext context,
    String title,
    String year,
    String posterUrl,
    String imdbID,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> favoriteMovies = prefs.getStringList('favorites') ?? [];

      // Create a movie string from the data
      String movieData = '$title|$year|$posterUrl|$imdbID';

      // Add the movie data to the list if not already present
      if (!favoriteMovies.contains(movieData)) {
        favoriteMovies.add(movieData);
        // Save the updated list to local storage
        await prefs.setStringList('favorites', favoriteMovies);

        // Show a snackbar to confirm action
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to favorites'),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Already in favorites'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }
}
