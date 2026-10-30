import 'package:flutter/material.dart';
import 'ai_result.dart';

/// Shows the AI road damage prediction to the admin.
/// If [result] is null, it shows "AI result not available".
/// AI only assists the admin; it never approves a complaint.
class AiResultPanel extends StatelessWidget {
  final AiResult? result;

  const AiResultPanel({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Text(
        'AI result not available',
        style: TextStyle(color: Colors.grey),
      );
    }

    final AiResult ai = result!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Damage detected', ai.detected ? 'Yes' : 'No'),
        _row('AI Category', ai.damageType),
        _row('Confidence', ai.confidencePercent),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ai.confidence.clamp(0.0, 1.0),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'AI assists the admin. It does not approve complaints.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}