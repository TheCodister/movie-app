import 'package:flutter/material.dart';
import 'package:sawaco_flutter/components/moviecard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  // Function to load the favorite movies from local storage
  Future<List<Map<String, String>>> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMovies = prefs.getStringList('favorites') ?? [];

    return favoriteMovies.map((movie) {
      var movieData = movie.split('|');
      return {
        'title': movieData[0],
        'year': movieData[1],
        'posterUrl': movieData[2],
        'imdbID': movieData[3],
      };
    }).toList();
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
                imdbID: movie['imdbID']!,
              );
            },
          );
        },
      ),
    );
  }
}


// class Favorite extends StatelessWidget {
//   const Favorite({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Favorite Movies"),
//       ),
//       body: const Center(
//         child: Text('No favorite movies found.'),
//       ),
//     );
//   }
// }
