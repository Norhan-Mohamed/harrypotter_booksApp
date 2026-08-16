class Character {
  final String fullName;
  final String nickname;
  final String hogwartsHouse;
  final String interpretedBy;
  final String image;
  final String birthdate;
  final List<String> children;

  const Character({
    required this.fullName,
    required this.nickname,
    required this.hogwartsHouse,
    required this.interpretedBy,
    required this.image,
    required this.birthdate,
    required this.children,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final childrenJson = json['children'];
    return Character(
      fullName: json['fullName'] as String? ?? 'Unknown',
      nickname: json['nickname'] as String? ?? '',
      hogwartsHouse: json['hogwartsHouse'] as String? ?? '',
      interpretedBy: json['interpretedBy'] as String? ?? '',
      image: json['image'] as String? ?? '',
      birthdate: json['birthdate'] as String? ?? '',
      children: childrenJson is List
          ? childrenJson.map((child) => child.toString()).toList()
          : const [],
    );
  }
}
