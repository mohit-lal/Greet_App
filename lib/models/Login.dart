class Login {
  final String type;
  final String token;
  final String user;

  const Login({
    required this.type,
    required this.token,
    required this.user,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      type: json['token']['type'],
      token: json['token']['token'],
      user: json['user'].toString(),
    );
  }
}
