import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:sawaco_flutter/components/appbar.dart';
import 'package:sawaco_flutter/pages/favorite/favorite.dart';
import 'package:sawaco_flutter/pages/home/home.dart';
import 'package:sawaco_flutter/pages/search/search.dart';

final queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return QueryClientProvider(
      queryClient: queryClient,
      child: const MaterialApp(
        title: "Movie OMDB",
        home: MainScreen(),
        // initialRoute: '/',
        // routes: {r
        //   '/': (context) => const Home(),
        //   '/search': (context) => const Search(),
        //   '/favorite': (context) => const Favorite(),
        // },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages to display based on the selected index
  final List<Widget> _pages = [
    const Home(),
    const Search(),
    const Favorite(),
  ];

  // Method to handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Display the custom app bar
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: _onItemTapped, // Call _onItemTapped when an item is tapped
      ),
    );
  }
}

// BottomNavigationBar items
final List<BottomNavigationBarItem> items = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Home',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: 'Search',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.favorite),
    label: 'Favorite',
  ),
];
