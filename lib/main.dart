import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'Hive/Model/storingModel.dart';
import 'Hive/Model/userDataModel.dart';
import 'auth/HomeScreen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'auth/uploadImages.dart';
import 'package:hive_flutter/hive_flutter.dart';




void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.checkPermission();
  await Hive.initFlutter();
  Hive.registerAdapter(OfflineImageAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('userBox');

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RegisterScreen.routeName ,
      routes: {
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        UploadImageScreen.routeName: (context) => UploadImageScreen(),


      },);
  }
}
