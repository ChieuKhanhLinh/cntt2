class Cart {
  final String email;
  final String name;
  final String phone;
  final String role;

  Cart({
    this.email = '',
    this.phone = '',
    this.name = '',
    this.role = '',
  });

  @override
  String toString() {
    return 'Cart(email: $email, name: $name, phone: $phone)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  static Cart fromJson(Map<String, dynamic> json) => Cart(
    email: json['email'],
    phone: json['phone'],
    name: json['name'],
    role: json['role'],
  );
}