import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/weapon_provider.dart';
import 'screens/home_screen.dart';
import 'screens/weapons_list.dart';
import 'screens/favorites_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HighguardApp());
}

class HighguardApp extends StatelessWidget {
  const HighguardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeaponProvider()..loadFromAssets(),
      child: Consumer<WeaponProvider>(builder: (context, prov, _) {
        final seed = const Color(0xFF283593); // deep indigo
        final light = ThemeData(useMaterial3: true, colorSchemeSeed: seed, brightness: Brightness.light);
        final dark = ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: seed,
          scaffoldBackgroundColor: const Color(0xFF0B1020),
          cardColor: const Color(0xFF0F1724),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
        );

        return MaterialApp(
          title: 'Highguard Assistant',
          theme: light,
          darkTheme: dark,
          themeMode: prov.themeMode,
          home: const RootScreen(),
        );
      }),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    WeaponsListScreen(),
    FavoritesScreen(),
    // About could be added here as route or simple page
    Center(child: Text('About: Data from launch + Episode 2 patches – check playhighguard.com or Discord')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Weapons'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}
