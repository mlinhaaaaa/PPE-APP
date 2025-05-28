import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: -10.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticInOut,
    ));
    
    // Start animations
    _fadeController.forward();
    _bounceController.repeat(reverse: true);
    
    // Start progress timer
    _startProgressTimer();
  }

  void _startProgressTimer() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 1;
        if (_progress >= 100) {
          timer.cancel();
          _navigateToHome();
        }
      });
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e3a8a), // blue-900
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icons
              AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.construction, size: 48, color: Colors.white),
                        SizedBox(width: 16),
                        Icon(Icons.security, size: 48, color: Colors.white),
                        SizedBox(width: 16),
                        Icon(Icons.shield, size: 48, color: Colors.white),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Animated title
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'PPE DETECTION',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Info card
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: const Color(0xFF1e40af), // blue-800
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2563eb)), // blue-600
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Info row
                    const Row(
                      children: [
                        Icon(Icons.warning_amber, size: 20, color: Color(0xFFfde047)), // yellow-300
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Real-time safety equipment detection',
                            style: TextStyle(
                              color: Color(0xFFfde047), // yellow-300
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Progress bar
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0f172a), // blue-950
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progress / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3b82f6), // blue-500
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Status row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Initializing system...',
                          style: TextStyle(
                            color: Color(0xFF93c5fd), // blue-300
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${_progress.toInt()}%',
                          style: const TextStyle(
                            color: Color(0xFF93c5fd), // blue-300
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Footer
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.build, size: 24, color: Color(0xFF94a3b8)), // slate-400
                  SizedBox(width: 8),
                  Text(
                    'Industrial Safety Solutions',
                    style: TextStyle(
                      color: Color(0xFF94a3b8), // slate-400
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}