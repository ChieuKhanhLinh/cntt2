class Users {
  final String email;
  final String name;
  final String phone;
  final String role;

  Users({
    this.email = '',
    this.phone = '',
    this.name = '',
    this.role = '',
  });

  @override
  String toString() {
    return 'User(email: $email, name: $name, phone: $phone, role: $role)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
    };
  }

  static Users fromJson(Map<String, dynamic> json) => Users(
        email: json['email'],
        phone: json['phone'],
        name: json['name'],
        role: json['role'],
      );
}
