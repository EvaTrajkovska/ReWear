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
  bool isPremium; // Adjusted to be a regular variable, not final

  User({
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
    this.isPremium = false, // Default value set to false, but it's modifiable
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "uid": uid,
      "email": email,
      "name": name,
      "surname": surname,
      "password": password, // Reminder: Ensure secure handling of passwords
      "followers": followers,
      "following": following,
      "rating": rating,
      "likes": likes,
      "isPremium": isPremium, // Added isPremium to JSON
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"] as String? ?? '',
      uid: json["uid"] as String? ?? '',
      email: json["email"] as String? ?? '',
      password: json["password"] as String? ?? '',
      name: json["name"] as String? ?? '',
      surname: json["surname"] as String? ?? '',
      followers: List.from(json["followers"] ?? []),
      following: List.from(json["following"] ?? []),
      rating: List.from(json["rating"] ?? []),
      likes: List.from(json["likes"] ?? []),
      isPremium: json["isPremium"] as bool? ?? false, // Handling isPremium
    );
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromJson(snapshot);
  }
}
