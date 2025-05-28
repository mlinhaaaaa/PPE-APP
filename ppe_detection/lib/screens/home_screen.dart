import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeff6ff), // blue-50
      appBar: AppBar(
        title: const Text('PPE Detection System'),
        backgroundColor: const Color(0xFF1e40af), // blue-800
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Header section
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Icon(
                    Icons.shield,
                    size: 48,
                    color: Color(0xFF1e40af), // blue-800
                  ),
                ),
                const Text(
                  'PPE Detection System',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1e3a8a), // blue-900
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Workplace Safety Monitoring',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2563eb), // blue-600
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Info card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFdbeafe)), // blue-100
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.info,
                          size: 20,
                          color: Color(0xFF1e40af), // blue-800
                        ),
                        SizedBox(width: 8),
                        Text(
                          'About This System',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1e40af), // blue-800
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This system detects Personal Protective Equipment (PPE) to ensure workplace safety compliance. The detection works in real-time using your device\'s camera.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4b5563), // gray-600
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Required PPE section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFfef9c3), // yellow-100
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFfde047)), // yellow-300
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.warning,
                                size: 16,
                                color: Color(0xFF854d0e), // yellow-800
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Required Safety Equipment',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF854d0e), // yellow-800
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              '• Earmuffs',
                              '• Face',
                              '• Face mask',
                              '• Face-guard',
                              '• Foot',
                              '• Glasses',
                              '• Gloves',
                              '• Hands',
                              '• Head',
                              '• Helmet',
                              '• Medical-suit',
                              '• Person',
                              '• Safety-vest',
                              '• Safety-suit',
                            ].map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF92400e), // yellow-700
                                ),
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Start detection button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/detection');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563eb), // blue-600
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Start PPE Detection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Disclaimer
            const Text(
              'Camera access required. Ensure you\'re in a well-lit environment for best results.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6b7280), // gray-500
              ),
            ),
          ],
        ),
      ),
    );
  }
}