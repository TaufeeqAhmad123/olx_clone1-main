class UserDetail {
  final String uid;
  final String email;
  final String name;
  final String? contact;

  UserDetail({
    required this.uid,
    required this.email,
    required this.name,
    this.contact,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'contact': contact,
    };
  }

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      contact: map['contact'],
    );
  }
}
