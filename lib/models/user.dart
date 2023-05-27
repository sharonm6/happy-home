class User {
  final String uid;
  String name;
  String email;

  User({
    required this.uid,
    this.name = '',
    this.email = '',
  });

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'] ?? '',
        email = data['email'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }
}
