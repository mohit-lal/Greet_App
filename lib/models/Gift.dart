class Gift {
  final int? id;
  final String? name;
  final String? icon;

  Gift({this.id, this.name, this.icon});

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}
