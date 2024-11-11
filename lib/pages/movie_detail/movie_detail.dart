import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:http/http.dart' as http;

class MovieDetail extends HookWidget {
  final String imdbID;

  const MovieDetail({super.key, required this.imdbID});

  Future<Map<String, dynamic>> fetchMovieDetails() async {
    final response = await http.get(
      Uri.parse('http://www.omdbapi.com/?apikey=533714b3&i=$imdbID'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == "True") {
        return data;
      } else {
        throw Exception(data['Error'] ?? 'Movie not found.');
      }
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieDetailQuery = useQuery<Map<String, dynamic>, Exception>(
      ['movieDetail', imdbID],
      fetchMovieDetails,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Details"),
      ),
      body: Builder(
        builder: (context) {
          if (movieDetailQuery.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieDetailQuery.isError) {
            return Center(child: Text('Error: ${movieDetailQuery.error}'));
          } else if (movieDetailQuery.data == null) {
            return const Center(child: Text('No details available.'));
          }

          final movieData = movieDetailQuery.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Movie Poster with styling
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movieData['Poster'] ?? '',
                    fit: BoxFit.cover,
                    height: 500,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 100, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),

                // Movie Title with improved style
                Text(
                  movieData['Title'] ?? 'No Title',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Movie Details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailRow(label: 'Year', value: movieData['Year']),
                      DetailRow(label: 'Genre', value: movieData['Genre']),
                      DetailRow(
                          label: 'Director', value: movieData['Director']),
                      DetailRow(label: 'Actors', value: movieData['Actors']),
                      const SizedBox(height: 10),
                      Text(
                        movieData['Plot'] ?? 'No description available.',
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 10),
                      DetailRow(
                          label: 'IMDb Rating', value: movieData['imdbRating']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// A helper widget to display movie details in a row format
class DetailRow extends StatelessWidget {
  final String label;
  final String? value;

  const DetailRow({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
