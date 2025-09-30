class UserEntity {
  final String id;
  final String email;
  final String? displayName;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
    };
  }

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }
}