import 'package:edge_pro_task/Hive/Model/userDataModel.dart';
import 'package:hive/hive.dart';

class UserDataStorage {
  late Box<User> userBox;

  Future<void> openUserBox() async {
    userBox = await Hive.openBox<User>('userBox');
  }

  Future<void> storeUserData(String username,String address,String num,String phone,String landmark) async {
    final user = User(username: username,num: num,address: address,phone: phone,landmark: landmark);
    await userBox.put('userData', user);
  }

   Future<User?> getUserData() async {
    return userBox.get('userData');
  }

  Future<User?> getUserDataById(String userId) async {
    final userBox = await Hive.openBox<User>('userBox');
    return userBox.values.firstWhere(
          (user) => user.num == userId,
    );
  }


  Future<void> clearUserData() async {
    await userBox.delete('userData');
  }
}
