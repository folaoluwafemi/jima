import 'package:equatable/equatable.dart';

class Minister with EquatableMixin {
  final String id;
  final String firstname;
  final String lastname;
  final String profilePhoto;

  String get name=> '$firstname $lastname';

  const Minister({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'profilePhoto': profilePhoto,
    };
  }

  factory Minister.fromMap(Map<String, dynamic> map) {
    return Minister(
      id: map['id'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      profilePhoto: map['profilePhoto'] as String,
    );
  }

  @override
  List<Object> get props => [id, firstname, lastname, profilePhoto];
}
