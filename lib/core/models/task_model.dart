import 'dart:math';

class TaskModel {
  String? localId; // Local unique ID
  String? sId; // Server ID (_id)
  String? title; // Task title
  String? syncStatus; // "synced" or "pending"
  DateTime? createdAt; // Timestamp

  TaskModel({
    this.localId,
    this.sId,
    this.title,
    this.syncStatus = 'pending',
    this.createdAt,
  });

  // Generate unique local ID
  static String generateLocalId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);
    return 'local_${timestamp}_$random';
  }

  // From server response
  TaskModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    localId = json['localId'] ?? generateLocalId();
    syncStatus = 'synced'; // From server = already synced
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
  }

  // From local Hive storage
  TaskModel.fromLocalJson(Map<String, dynamic> json) {
    localId = json['localId'];
    sId = json['_id'];
    title = json['title'];
    syncStatus = json['syncStatus'] ?? 'pending';
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
  }

  // To server (only send title)
  Map<String, dynamic> toJson() {
    return {'title': title};
  }

  // To local storage (save everything)
  Map<String, dynamic> toLocalJson() {
    return {
      'localId': localId,
      '_id': sId,
      'title': title,
      'syncStatus': syncStatus,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
