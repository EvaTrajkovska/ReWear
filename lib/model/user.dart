import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String surname;
  final String username;
  final String email;
  final String password;
  final String uid;
  final List<dynamic> followers;
  final List<dynamic> following;
  final List<dynamic> rating;
  final List<dynamic> likes;

  const User({
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.password,
    required this.uid,
    required this.followers,
    required this.following,
    required this.rating,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "uid": uid,
      "email": email,
      "name": name,
      "surname": surname,
      "password": password, // TODO: handling passwords securely
      "followers": followers,
      "following": following,
      "rating": rating,
      "likes": likes,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"] as String? ?? '',
      uid: json["uid"] as String? ?? '',
      email: json["email"] as String? ?? '',
      // Note: Storing passwords in plain text is a security risk. Ensure that this is handled securely.
      password: json["password"] as String? ?? '',
      name: json["name"] as String? ?? '',
      surname: json["surname"] as String? ?? '',
      followers: List.from(json["followers"] ?? []),
      following: List.from(json["following"] ?? []),
      rating: List.from(json["rating"] ?? []),
      likes: List.from(json["likes"] ?? []),
    );
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromJson(snapshot);
  }
}
