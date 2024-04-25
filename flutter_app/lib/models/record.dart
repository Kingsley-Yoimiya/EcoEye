class Record {
  final String id;
  final String userId;
  final String photo;
  final Map<String, dynamic> analysisResults;
  final String timestamp;

  Record({
    required this.id,
    required this.userId,
    required this.photo,
    required this.analysisResults,
    required this.timestamp,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'] as String,
      userId: json['userId'] as String,
      photo: json['photo'] as String,
      analysisResults: json['analysisResults'] as Map<String, dynamic>,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'photo': photo,
      'analysisResults': analysisResults,
      'timestamp': timestamp,
    };
  }
}
