import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:http/http.dart' as http;

class Search extends HookWidget {
  const Search({super.key});

  Future<List<dynamic>> fetchMovies(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
        'http://www.omdbapi.com/?apikey=533714b3&s=$query&type=movie');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == "True") {
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
    final searchController = useTextEditingController();
    final query = useState('');

    // Trigger the query only when the query is non-empty
    final searchQuery = useQuery<List<dynamic>, String>(
      [query.value],
      () => fetchMovies(query.value),
      enabled: query
          .value.isNotEmpty, // Query is only enabled if the search is not empty
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Search Movies")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter movie title',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onFieldSubmitted: (value) {
                query.value =
                    value; // Update the query value when the user submits the search
              },
            ),
            const SizedBox(height: 20),
            if (searchQuery.isLoading && searchQuery.data == null)
              const Center(
                child: Text('Your result will appear here'),
              ), // Loading indicator // Loading indicator
            if (searchQuery.isError)
              Center(
                child: Text(
                  'Error: ${searchQuery.error}', // Display any errors
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (!searchQuery.isLoading &&
                searchQuery.data != null &&
                searchQuery.data!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchQuery.data!.length,
                  itemBuilder: (context, index) {
                    final movie = searchQuery.data![index];
                    return ListTile(
                      onTap: () {
                        // Navigate to movie details page
                        Navigator.pushNamed(
                          context,
                          '/movie_detail/${movie['imdbID']}', // Use the dynamic route with the imdbID
                        );
                      },
                      leading: Image.network(
                        movie['Poster'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(movie['Title'] ?? 'No title'),
                      subtitle: Text(movie['Year'] ?? 'No year'),
                    );
                  },
                ),
              ),
            if (!searchQuery.isLoading &&
                searchQuery.data != null &&
                searchQuery.data!.isEmpty)
              const Center(child: Text('No movies found.')), // No results
          ],
        ),
      ),
    );
  }
}
