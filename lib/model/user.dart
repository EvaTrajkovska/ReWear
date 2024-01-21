import 'package:cloud_firestore/cloud_firestore.dart';

class User{
 final String name;
 final String surname;
 final String username;
 final String email;
 final String password;
 final String uid;
 final List followers;
 final List following;
 final List rating;
 final List likes;


 const User(  {required this.name, required this.surname, required this.username,
   required this.email, required this.password,
   required this.uid, required this.followers,
   required this.following,required this.rating,
   required this.likes,});

 Map<String, dynamic> toJson() => {
   "username": username,
   "uid": uid,
   "email": email,
   "name": name,
   "surname": surname,
   "followers": followers,
   "following": following,
   "rating": rating,
   "likes": likes,
 };

 static User fromSnap(DocumentSnapshot snap) {
   var snapshot = snap.data() as Map<String, dynamic>;

   return User(
     username: snapshot["username"],
     uid: snapshot["uid"],
     email: snapshot["email"],
     password: snapshot["password"],
     name: snapshot["name"],
     surname: snapshot["surname"],
     followers: snapshot["followers"],
     following: snapshot["following"],
     rating: snapshot["rating"],
     likes: snapshot["likes"],
   );
 }
}
