class Detection {
  final String className;
  final double score;
  final List<double> bbox;

  Detection({
    required this.className,
    required this.score,
    required this.bbox,
  });

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      className: json['class_name'] as String,
      score: (json['score'] as num).toDouble(),
      bbox: (json['bbox'] as List).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_name': className,
      'score': score,
      'bbox': bbox,
    };
  }
}

class DetectionResult {
  final List<Detection> detections;
  final List<String> missingPpe;
  final String? imageUrl;

  DetectionResult({
    required this.detections,
    required this.missingPpe,
    this.imageUrl,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      detections: (json['detections'] as List)
          .map((e) => Detection.fromJson(e))
          .toList(),
      missingPpe: List<String>.from(json['missing_ppe']),
      imageUrl: json['image_url'] as String?,
    );
  }
}
