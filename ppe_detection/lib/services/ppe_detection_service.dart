import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/detection_model.dart';

class PPEDetectionService {
  // Replace with your actual backend IP or domain
  static const String _baseUrl = 'http://192.168.2.153:5000';

  Future<DetectionResult> detectPPE(File imageFile) async {
    try {
      final uri = Uri.parse('$_baseUrl/detect');
      final request = http.MultipartRequest('POST', uri);

      // Read image file as bytes
      final fileBytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        fileBytes,
        filename: 'image.jpg',
      );
      request.files.add(multipartFile);

      // Optional: set headers
      request.headers['Accept'] = 'application/json';

      // Send multipart/form-data request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Convert relative image_url to full URL
        final imageUrl = '$_baseUrl${jsonData['image_url']}';
        jsonData['image_url'] = imageUrl;

        return DetectionResult.fromJson(jsonData);
      } else {
        throw Exception(
          'API Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to detect PPE: $e');
    }
  }
}
