import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:http/http.dart' as http;
import 'package:sawaco_flutter/components/moviecard.dart';

class Home extends HookWidget {
  const Home({super.key});

  Future<List<Map<String, dynamic>>> fetchMovies() async {
    final response = await http.get(Uri.parse(
        'http://www.omdbapi.com/?apikey=533714b3&s=action&type=movie'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == "True" && data['Search'] != null) {
        return List<Map<String, dynamic>>.from(data['Search']);
      } else {
        throw Exception(data['Error'] ?? 'No movies found.');
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesQuery = useQuery<List<Map<String, dynamic>>, Exception>(
      ['movies'],
      fetchMovies,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
      ),
      body: Builder(
        builder: (context) {
          if (moviesQuery.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (moviesQuery.isError) {
            return Center(
                child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5.0,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Error loading movies.'),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          //onPressed will refresh the application
                          onPressed: () => moviesQuery.refetch(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    )),
              ),
            ));
          } else if (moviesQuery.data == null || moviesQuery.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          } else {
            return ListView.builder(
              itemCount: moviesQuery.data!.length,
              itemBuilder: (context, index) {
                final movie = moviesQuery.data![index];
                return Moviecard(
                  title: movie['Title'],
                  year: movie['Year'],
                  posterUrl: movie['Poster'],
                  imdbID: movie['imdbID'],
                );
              },
            );
          }
        },
      ),
    );
  }
}
