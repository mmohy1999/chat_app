
import 'package:chat_app/models/user.dart';

class ContactModel extends UserModel{
  bool isExists;
  ContactModel({required super.name, required super.phone,  super.email,super.uid,super.photo, this.isExists=false});



}