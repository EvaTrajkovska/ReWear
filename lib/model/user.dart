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


}
