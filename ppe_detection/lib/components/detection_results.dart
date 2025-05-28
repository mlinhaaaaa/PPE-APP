import 'dart:io';
import 'package:flutter/material.dart';
import '../models/detection_model.dart';

// Helper to get color by PPE class
Color getColorForClass(String className) {
  switch (className.toLowerCase()) {
    case 'helmet':
      return Colors.green;
    case 'safety-vest':
      return Colors.orange;
    case 'face mask':
      return Colors.blue;
    case 'safety-suit':
      return Colors.brown;
    case 'gloves':
      return Colors.purple;
    case 'earmuffs':
      return Colors.cyan;
    case 'face':
      return Colors.pink.shade200;
    case 'face-guard':
      return Colors.yellow;
    case 'foot':
      return Colors.brown.shade700;
    case 'glasses':
      return Colors.teal;
    case 'hands':
      return Colors.pink.shade400;
    case 'head':
      return Colors.green.shade700;
    case 'medical-suit':
      return Colors.blue.shade900;
    case 'person':
      return Colors.grey.shade700;
    default:
      return Colors.grey;
  }
}

class DetectionResults extends StatelessWidget {
  final List<Detection> detections;
  final String imagePath;

  const DetectionResults({
    Key? key,
    required this.detections,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 12),
            if (imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imagePath.startsWith('http')
                    ? Image.network(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                )
                    : Image.file(
                  File(imagePath),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 12),
            _DetectionList(detections: detections),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.security, color: Color(0xFF2563eb)),
        SizedBox(width: 8),
        Text(
          'PPE Detection Results',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1e3a8a),
          ),
        ),
      ],
    );
  }
}

class _DetectionList extends StatelessWidget {
  final List<Detection> detections;

  const _DetectionList({required this.detections, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (detections.isEmpty) {
      return const Text(
        'No detections found.',
        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: detections.map((detection) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: getColorForClass(detection.className),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  '${detection.className} (${(detection.score * 100).toStringAsFixed(1)}%)',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}