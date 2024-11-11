import 'package:flutter/material.dart';
import 'package:sawaco_flutter/utils/addtofavorite.dart';

class Moviecard extends StatelessWidget {
  final String title;
  final String year;
  final String posterUrl;
  final String imdbID;

  const Moviecard({
    super.key,
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.imdbID,
  });

  // Function to save movie to favorites in local storage
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
        elevation: 10.0,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Image.network(
                posterUrl,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              title: Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(year),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => FavoritesUtils.addToFavorites(
                      context, title, year, posterUrl, imdbID),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 40),
                    backgroundColor: const Color.fromARGB(255, 255, 131, 173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Add to favorite',
                      style: TextStyle(color: Colors.white, fontSize: 12.0)),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/movie_detail/${imdbID}', // Use the dynamic route with the imdbID
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 40),
                    backgroundColor: const Color.fromARGB(255, 238, 49, 49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('View Details',
                      style: TextStyle(color: Colors.white, fontSize: 12.0)),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
