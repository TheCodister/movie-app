import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'images/poster.jpg',
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                  const ListTile(
                    title: Text('John Wick',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Action, Crime, Thriller'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
