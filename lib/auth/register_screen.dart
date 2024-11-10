import 'package:edge_pro_task/auth/uploadImages.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../Hive/Model/userDataModel.dart';
import '../Location_manager/location_manager.dart';
import '../Location_manager/maps_screen.dart';
import 'AppTextField.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget{
  static String routeName = 'Register Screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();
  bool isObscure = true;
  var uniqueId = Uuid().v4();
  var emailController = TextEditingController();
  var landmarkController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var addressController = TextEditingController();
  var confirmationPasswordController = TextEditingController();
  var userNameController = TextEditingController();
  LatLng? _initialPosition;
  final LocationManager _locationManager = LocationManager();


  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentLocation();
  // }
  Future<void> getCurrentLocation() async {
    bool permissionGranted = await _locationManager.isPermissionGranted() || await _locationManager.requestPermission();
    bool serviceEnabled = await _locationManager.isServiceEnabled() || await _locationManager.requestService();
    if (permissionGranted && serviceEnabled) {
      var locationData = await _locationManager.getUserLocation();
      if (locationData != null) {
        setState(() {
          _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
          selectLocation();
        });
      }
    } else {
      print('Location permissions or services are not enabled');
    }
  }

  Future<void> selectLocation() async {
    if (_initialPosition != null) {
      final selectedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          builder: (context) => MapScreen(
            initialPosition: _initialPosition!,
          ),
        ),
      );
      if (selectedLocation != null) {
        setState(() {
          addressController.text = '${selectedLocation.latitude}, ${selectedLocation.longitude}';
          print('Address updated: ${addressController.text}');

        });
      }
    } else {
      print('Current location is not available');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 100,),
            Text('Sign Up', style: TextStyle(
              color:  Colors.purple, fontSize: 30
            ),textAlign: TextAlign.center,),
            SizedBox(
              height:60 ,),
             Form(
               key: formKey,
                 child: Column(
                   children: [
                     AppTextField(
                         fieldName: 'username',
                         hintText: 'Enter your username',
                         controller: userNameController,
                       validator: (value){
                           if(value == null || value.trim().isEmpty){
                             return 'please enter your username';
                           }
                           return null;
                       },
                     ),
                     AppTextField(
                       fieldName: 'Email',
                       hintText: 'Enter your email',
                       controller: emailController,
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return 'please enter your email';
                         }
                         bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                             .hasMatch(value);
                         if (!validEmail) {
                           return 'invalid email';
                         }
                         return null;
                       },
                     ),
                     AppTextField(
                       fieldName: 'phone number',
                       hintText: 'Enter your phone number',
                       controller: phoneNumberController,
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return 'please enter your phone number';
                         }
                         if (value.trim().length != 11) {
                           return 'please write a valid phone number';
                         }
                         return null;
                       },
                       keyboardType: TextInputType.phone,
                     ),
                     AppTextField(
                       fieldName: 'password',
                       hintText: 'Enter your password',
                       controller: passwordController,
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return 'please enter your password';
                         }
                         if (value.trim().length < 6) {
                           return 'password should be > 6 ';
                         }
                         return null;
                       },
                       keyboardType: TextInputType.visiblePassword,
                       isObscure:  isObscure,
                       suffixIcon: InkWell(
                         child:  isObscure
                             ? Icon(Icons.visibility_off)
                             : Icon(Icons.visibility),
                         onTap: () {
                           if (isObscure) {
                             isObscure = false;
                           } else {
                             isObscure = true;
                           }
                           setState(() {});
                         },
                       ),
                     ),
                     AppTextField(
                       fieldName: 'confirm password',
                       hintText: 'Enter your password',
                       controller: confirmationPasswordController,
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return 'please enter your password';
                         }
                         if (value != passwordController.text) {
                           return "Password doesn't match";
                         }
                         return null;
                       },
                       keyboardType: TextInputType.visiblePassword,
                       isObscure:  isObscure,
                       suffixIcon: InkWell(
                         child:  isObscure
                             ? Icon(Icons.visibility_off)
                             : Icon(Icons.visibility),
                         onTap: () {
                           if (isObscure) {
                            isObscure = false;
                           } else {
                             isObscure = true;
                           }
                           setState(() {});
                         },
                       ),
                     ),
                     AppTextField(
                       fieldName: 'landmark',
                       hintText: 'Enter your landmark',
                       controller: landmarkController,
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return 'please enter your landmark';
                         }
                         return null;
                       },
                     ),
                     AppTextField(
                       fieldName: 'address',
                       onTap: getCurrentLocation,
                       readOnly: true,
                       hintText: 'choose from maps ',
                       controller: addressController,
                       suffixIcon: Icon(Icons.map_outlined),
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return 'please enter your address';
                         }
                         return null;
                       },
                     ),


                   ],
                 )
             ),
            Padding(
              padding: EdgeInsets.all(40),
              child: ElevatedButton(
                onPressed: () {
                  saveUserData();
                  // Navigator.of(context).pushNamed(UploadImageScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(15)))),
                child: SizedBox(
                  height: 64,
                  width: 398,
                  child: Center(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                    child: Text(
                      'sign in',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.purple
                      ),
                    ),
                  )
                ],
              ),
            )


          ],
        ),
      ),

    );
  }

Future<void>saveUserData()async {
  if(formKey.currentState?.validate() == true){
    print('Generated Unique ID: $uniqueId');
    final userBox = await Hive.openBox<User>('userBox');
    final newUser = User(
      num: uniqueId,
      username: userNameController.text,
      phone: phoneNumberController.text,
      address: addressController.text,
      landmark: landmarkController.text,
    );
    await userBox.add(newUser);
    Navigator.of(context).pushNamed(UploadImageScreen.routeName, arguments: newUser.num);
    print('User data saved successfully');
    print( 'num : ${newUser.num},'
        'username : ${newUser.username},'
        'phone : ${newUser.phone},'
        'address : ${newUser.address},'
        'landmark : ${newUser.landmark}');
  }
}

}