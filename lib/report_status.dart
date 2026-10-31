class ReportStatus {
  static const String pending = 'pending';
  static const String verified = 'verified';
  static const String assigned = 'assigned';
  static const String repaired = 'repaired';
  static const String rejected = 'rejected';

  static const List<String> all = [
    pending,
    verified,
    assigned,
    repaired,
    rejected,
  ];
}