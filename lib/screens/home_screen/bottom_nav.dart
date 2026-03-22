import 'package:farmsetu_weather/screens/home_screen/home_page.dart';
import 'package:farmsetu_weather/screens/home_screen/map_screen.dart';
import 'package:farmsetu_weather/screens/utils/custom_drover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key});

  @override
  ConsumerState<BottomNav> createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends ConsumerState<BottomNav> {
  int _selectedIndex = 0;

  final List<String> _titles = ["Home", "Map"];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const MapScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search, color: Colors.white),
        //     onPressed: () {
        //       // Handle notification icon press
        //     },
        //   ),
        // ],
        centerTitle: true, // ✅ Center the title
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset(
              'assets/icon/menu.png', // your drawer logo
              height: 68,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontFamily: 'Source Sans 3',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      drawer: const CustomDrawer(),
      backgroundColor: Colors.grey.shade300,
      body: pages[_selectedIndex],

      // -------------------- Bottom Navigation --------------------
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.deepOrange,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.map, "Map", 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.deepOrange,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}