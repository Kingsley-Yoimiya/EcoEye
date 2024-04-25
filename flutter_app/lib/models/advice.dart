class Advice {
  final String id;
  final String recordId;
  final String adviceText;
  final String timestamp;

  Advice({
    required this.id,
    required this.recordId,
    required this.adviceText,
    required this.timestamp,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      id: json['id'] as String,
      recordId: json['recordId'] as String,
      adviceText: json['adviceText'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recordId': recordId,
      'adviceText': adviceText,
      'timestamp': timestamp,
    };
  }
}
