import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({
    super.key,
    required this.title,
    required this.year,
    required this.posterUrl,
  });

  final String title;
  final String year;
  final String posterUrl;
  // Function to save movie to favorites in local storage
  Future<void> _addToFavorites(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> favoriteMovies = prefs.getStringList('favorites') ?? [];

      // Create a movie string from the data
      String movieData = '$title|$year|$posterUrl';

      // Add the movie data to the list
      favoriteMovies.add(movieData);
      // Save the updated list to local storage
      await prefs.setStringList('favorites', favoriteMovies);

      // Check if the widget is still mounted before showing the SnackBar
      if (context.mounted) {
        // Show a snackbar to confirm action
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          _addToFavorites(context);
        },
        child: const Text('Add to favorites'),
      ),
    );
  }
}
