class UserModel{
  String name,phone,email;
  String? uid,photo;

  UserModel(this.name, this.phone, this.email,);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone':phone,
      'email':email,
      'uid':uid,
    };
  }
}