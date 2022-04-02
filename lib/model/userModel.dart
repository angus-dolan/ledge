class AppUser {
  final String id;
  final String name;
  final String email;
  final Map<String, dynamic> ledger;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.ledger,
  });

  static AppUser fromJson(Map<String, dynamic> json) => AppUser(
        id: json['uid'],
        name: json['name'],
        email: json['email'],
        ledger: json['ledger'],
      );
}
