class Users {
  final String email;
  final String name;
  final String phone;
  final String role;
  final String urlImage;

  Users({
    this.email = '',
    this.phone = '',
    this.name = '',
    this.role = '',
    this.urlImage = '',
  });

  @override
  String toString() {
    return 'User(email: $email, name: $name, phone: $phone, role: $role, urlImage: $urlImage)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'urlImage' : urlImage,
    };
  }

  static Users fromJson(Map<String, dynamic> json) => Users(
      email: json['email'],
      phone: json['phone'],
      name: json['name'],
      role: json['role'],
      urlImage:  json['urlImage']
  );
}
