import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class LicensePlateScanner {
  static Future<String?> scan() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return null;

    final image = InputImage.fromFile(File(picked.path));
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final result = await recognizer.processImage(image);
    await recognizer.close();

    final rawText = result.text;
    // Improved regex to match plates with normal dash, en-dash or em-dash
    final plateRegex = RegExp(
      r'[0-9IO]{2,3}[-–—][A-Z]{1,3}[-–—][0-9IO]{1,6}',
      caseSensitive: false,
    );


    final plateMatch = plateRegex.firstMatch(rawText);
    if (plateMatch != null) {
      return normalizePlate(plateMatch.group(0)!);
    }

    // No plate found
    return null;
  }

  static String normalizePlate(String raw) {
    String normalized = raw
        .replaceAll(RegExp(r'[–—]'), '-')   // Replace dash variants
        .replaceAll(RegExp(r'\s+'), '')     // Remove spaces
        .toUpperCase();

    // Split into parts: YEAR - COUNTY - NUMBER
    final parts = normalized.split('-');
    if (parts.length != 3) return normalized;

    // Replace common OCR misreads in YEAR and NUMBER parts only
    parts[0] = parts[0]
        .replaceAll('I', '1')
        .replaceAll('O', '0')
        .replaceAll('L', '1');

    parts[2] = parts[2]
        .replaceAll('I', '1')
        .replaceAll('O', '0')
        .replaceAll('L', '1');

    return '${parts[0]}-${parts[1]}-${parts[2]}';
  }
}
