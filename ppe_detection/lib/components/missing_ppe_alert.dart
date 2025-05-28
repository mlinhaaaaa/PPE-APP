import 'package:flutter/material.dart';

class MissingPPEAlert extends StatelessWidget {
  final List<String> items;

  const MissingPPEAlert({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFfee2e2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFfecaca)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning, size: 24, color: Color(0xFFb91c1c)),
              SizedBox(width: 8),
              Text(
                'Safety Warning',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFb91c1c),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Missing required safety equipment:',
            style: TextStyle(fontSize: 14, color: Color(0xFFb91c1c)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 16, color: Color(0xFFb91c1c)),
                    const SizedBox(width: 4),
                    Text(item,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFb91c1c))),
                  ],
                ),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
