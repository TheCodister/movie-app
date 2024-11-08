import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Moviecard extends StatelessWidget {
  final String title;
  final String year;
  final String posterUrl;

  const Moviecard({
    super.key,
    required this.title,
    required this.year,
    required this.posterUrl,
  });

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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      elevation: 10.0,
      child: Column(
        children: <Widget>[
          Image.network(
            posterUrl,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text(
              title,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(year),
          ),
          ElevatedButton(
            onPressed: () => _addToFavorites(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 131, 173),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text('Add to favorite',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
