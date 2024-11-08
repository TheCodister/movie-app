import 'package:flutter/material.dart';
import 'package:sawaco_flutter/components/moviecard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  // Function to load the favorite movies from local storage
  Future<List<Map<String, String>>> _loadFavorites() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> favoriteMovies = prefs.getStringList('favorites') ?? [];

      List<Map<String, String>> movies = [];
      for (var movie in favoriteMovies) {
        var movieData = movie.split('|');
        if (movieData.length == 3) {
          movies.add({
            'title': movieData[0],
            'year': movieData[1],
            'posterUrl': movieData[2],
          });
        }
      }
      return movies;
    } catch (e) {
      throw Exception('Error loading favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _loadFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites found.'));
          }

          var favoriteMovies = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              var movie = favoriteMovies[index];
              return Moviecard(
                title: movie['title']!,
                year: movie['year']!,
                posterUrl: movie['posterUrl']!,
              );
            },
          );
        },
      ),
    );
  }
}
//
