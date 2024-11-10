import 'package:edge_pro_task/auth/register_screen.dart';
import 'package:flutter/material.dart';
import '../Hive/Model/userDataModel.dart';
import '../Hive/userDataStorage.dart';
import '../Location_manager/location_manager.dart';

class HomeScreen extends StatefulWidget{
  static String routeName = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationManager locationManager = LocationManager();
  UserDataStorage userDataStorage = UserDataStorage();
  User? userData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trackUserData();
    fetchUserData();

  }

  Future<void> fetchUserData() async {
    await userDataStorage.openUserBox();
    User? fetchedUserData = await userDataStorage.getUserData();
    setState(() {
      userData = fetchedUserData;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         if(userData != null)
         Center( child: Text('user ${userData?.num} uploaded the data to API!')),
         Padding(
           padding: EdgeInsets.all(40),
           child: ElevatedButton(
             onPressed: () {
               trackUserData();
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
                   'track my location',
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
           padding: EdgeInsets.all(40),
           child: ElevatedButton(
             onPressed: () {
               Navigator.of(context).pushNamed(RegisterScreen.routeName);
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
                   'back',
                   style: TextStyle(
                       fontSize: 20,
                       color: Colors.white
                   ),
                 ),
               ),
             ),
           ),
         ),



       ],
     ),
   );
  }
  trackUserData()async{
   var locationData =  await locationManager.getUserLocation();
   print('location data altitude ${locationData?.altitude?? 0}');
   print('location data longitude ${locationData?.longitude?? 0}');
   locationManager.updateUserLocation().listen((newLocation){
     print(newLocation.longitude);
     print(newLocation.altitude);
   });

  }
}