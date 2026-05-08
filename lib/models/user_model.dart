class AppUser {
  final String id;
  final String fullName;
  final String email;

  AppUser({required this.id, required this.fullName, required this.email});

  factory AppUser.fromFirestore(Map<String, dynamic> data, String documentId) {
    return AppUser(
      id: documentId,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'email': email,
    };
  }
}