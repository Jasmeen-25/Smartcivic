/// The result of an AI road damage check.
///
/// IMPORTANT: AI only ASSISTS the admin. It never approves or
/// rejects a complaint. A human admin always makes the final decision.
class AiResult {
  /// The category the AI predicted, e.g. "Pothole", "Crack",
  /// or "Damaged surface".
  final String damageType;

  /// How sure the AI is, from 0.0 (not sure) to 1.0 (very sure).
  final double confidence;

  /// Whether the AI detected road damage in the photo at all.
  final bool detected;

  const AiResult({
    required this.damageType,
    required this.confidence,
    required this.detected,
  });

  /// Confidence as a whole-number percentage, e.g. 0.87 -> "87%".
  String get confidencePercent => '${(confidence * 100).round()}%';

  /// Builds an AiResult from data stored on a complaint.
  /// Returns null if the data is missing or incomplete, so the app
  /// shows "AI unavailable" instead of guessing or inventing values.
  static AiResult? fromMap(dynamic data) {
    if (data is! Map) return null;

    final type = data['damageType'];
    final conf = data['confidence'];
    final found = data['detected'];

    if (type is! String || conf is! num || found is! bool) {
      return null;
    }

    return AiResult(
      damageType: type,
      confidence: conf.toDouble(),
      detected: found,
    );
  }

  /// Converts the result to a Map (for saving or passing around).
  Map<String, dynamic> toMap() {
    return {
      'damageType': damageType,
      'confidence': confidence,
      'detected': detected,
    };
  }
}