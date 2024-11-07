import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sawaco_flutter/components/moviecard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<dynamic>> futureMovie;

  @override
  void initState() {
    super.initState();
    futureMovie = fetchMovies();
  }

  Future<List<dynamic>> fetchMovies() async {
    try {
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
    } catch (e) {
      // print('Error: $e');
      return []; // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureMovie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return Moviecard(
                  title: movie['Title'],
                  year: movie['Year'],
                  posterUrl: movie['Poster'],
                );
              },
            );
          }
        },
      ),
    );
  }
}
