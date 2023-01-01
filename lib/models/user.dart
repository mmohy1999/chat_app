class UserModel{
  String name,phone;
  String? uid,photo,email;

  UserModel({required this.name, required this.phone,  this.email,this.uid,this.photo});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone':phone,
      'email':email,
      'uid':uid,
    };
  }
}