class LogUserModel{
  String _userId;
  DateTime _createdAt; // 외근 시작 시간

  LogUserModel(
  {String userId,
  DateTime createdAt}) {
  this._userId = userId ?? "unknown";
  this._createdAt = createdAt ?? DateTime.now();
  }

  LogUserModel.fromJson(Map<dynamic, dynamic> record)
      : this._userId = record['userId'] ?? "unknown",
  this._createdAt = record['createdAt'] ?? DateTime.now();

  String get userId => this._userId;
  DateTime get createdAt => this._createdAt;


  toMap() => {"userId": this._userId};

  @override
  bool operator ==(Object other) {
  // TODO: implement ==
  return (identical(this, other) ||
  other is LogUserModel &&
  this.runtimeType == other.runtimeType &&
  this._userId == other._userId &&
  this._createdAt == other._createdAt);
  }

  @override
  // TODO: implement hashCode
  int get hashCode =>
  this._userId.hashCode ^
  this._createdAt.hashCode;

}