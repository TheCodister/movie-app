import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Favorite({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0.0),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                // ignore: avoid_print
                print('Favorite');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
