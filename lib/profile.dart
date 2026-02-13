class Profile {
  int? id;
  String name;
  String macAddress;

  Profile({this.id, required this.name, required this.macAddress});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'macAddress': macAddress,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      macAddress: map['macAddress'],
    );
  }
}
