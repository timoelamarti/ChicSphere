import 'package:tflite/tflite.dart';



class AIService {
  /// Load the model and labels
  static Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      if (res != null) {
        print("Model loaded successfully: $res");
      }
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  /// Classify the given image and return the category
  static Future<String> classifyImage(String imagePath) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 1, // Get the top prediction
        threshold: 0.5, // Confidence threshold
        asynch: true,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        return recognitions[0]['label'] as String;
      } else {
        return "Unknown";
      }
    } catch (e) {
      print("Error classifying image: $e");
      return "Error";
    }
  }

  /// Release the model resources
  static Future<void> closeModel() async {
    try {
      await Tflite.close();
      print("Model resources released.");
    } catch (e) {
      print("Error releasing model resources: $e");
    }
  }
}
