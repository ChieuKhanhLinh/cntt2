class Users {
  final String email;
  final String name;
  final String phone;

  Users({
    this.email = '',
    this.phone = '',
    this.name = '',
  });

  @override
  String toString() {
    return 'User(email: $email, name: $name, phone: $phone)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  static Users fromJson(Map<String, dynamic> json) => Users(
    email: json['email'],
    phone: json['phone'],
    name: json['name'],
  );
}
