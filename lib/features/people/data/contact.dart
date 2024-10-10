import 'package:hive/hive.dart';
part 'contact.g.dart';

@HiveType(typeId: 0)
class ContactModel extends HiveObject  {
  @HiveField(0)
  bool isExists;
  @HiveField(1)
  String name;
  @HiveField(2)
  String phone;
  @HiveField(3)
  String? uid;
  @HiveField(4)
  String photo;
  @HiveField(5)
  String? email;
  ContactModel({required this.name, required this.phone,  this.email,
                  this.uid,required this.photo, this.isExists=false});

  @override
  String toString() {
    return 'ContactModel{name: $name,phone:$phone }';
  }
}