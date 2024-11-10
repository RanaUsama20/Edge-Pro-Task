import 'package:hive/hive.dart';
part 'userDataModel.g.dart';


@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String address;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String landmark;

  @HiveField(4)
  final String num;



  User({required this.username, required this.address,required this.phone,required this.landmark, required this.num});
}
