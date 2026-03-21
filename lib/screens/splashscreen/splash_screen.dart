import 'dart:async';
import 'package:farmsetu_weather/screens/home_screen/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  double _topPosition = -200;

  @override
  void initState() {
    super.initState();

    // Gradient Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.pinkAccent,
    ).animate(_controller);

    _colorAnimation2 = ColorTween(
      begin: Colors.blue,
      end: Colors.orangeAccent,
    ).animate(_controller);

    // Image Drop Animation
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _topPosition = MediaQuery.of(context).size.height / 3;
      });
    });

    // Navigate after splash
    Timer(const Duration(seconds: 3), _checkAndNavigate);
  }

  Future<void> _checkAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();

    // Check first launch
    bool firstLaunch = prefs.getBool('first_launch') ?? true;
    if (firstLaunch) {
      // Mark first launch as done
      await prefs.setBool('first_launch', false);
      // Go to onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNav()),
      );
      return;
    }

    // Not first launch → check login status
    bool loggedIn = prefs.getBool('is_logged_in') ?? false;
    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNav()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNav()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Animated Gradient Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_colorAnimation1.value!, _colorAnimation2.value!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Animated Image Drop
              AnimatedPositioned(
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                top: _topPosition,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/techflux.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "TechFlux Solution",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
