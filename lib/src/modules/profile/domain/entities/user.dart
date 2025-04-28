import 'package:jima/src/modules/profile/domain/entities/user_privilege.dart';
import 'package:jima/src/tools/tools_barrel.dart';

final class User implements Comparable<User> {
  final String id;
  final String? firstname;
  final String? lastname;
  final String? profilePhoto;
  final String? email;
  final DateTime createdAt;
  final UserPrivilege privilege;

  const User({
    required this.id,
    this.firstname,
    this.lastname,
    this.profilePhoto,
    required this.email,
    required this.createdAt,
    required this.privilege,
  });

  User.create({
    required this.id,
    this.firstname,
    this.lastname,
    this.profilePhoto,
    required this.email,
  })  : privilege = UserPrivilege.user,
        createdAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'profilePhoto': profilePhoto,
      'email': email,
      'privilege': privilege.enumValue,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      firstname: map['firstname'] as String?,
      lastname: map['lastname'] as String?,
      profilePhoto: map['profilePhoto'] as String?,
      email: map['email'] as String,
      createdAt: ParseUtils.parseDateTime(map['createdAt']),
      privilege: ParseUtils.parseEnum(map['privilege'], UserPrivilege.values),
    );
  }

  User copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? profilePhoto,
    String? email,
    DateTime? createdAt,
    UserPrivilege? privilege,
  }) {
    return User(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      privilege: privilege ?? this.privilege,
    );
  }

  @override
  int compareTo(User other) {
    return other.createdAt.compareTo(createdAt);
  }
}
