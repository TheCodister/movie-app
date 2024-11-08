// moviecard.dart
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to favorite'),
        ),
      );
    }

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
            onPressed: onPressed,
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
