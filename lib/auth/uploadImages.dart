import 'dart:async';
import 'dart:io';
import 'package:edge_pro_task/auth/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../Hive/Model/storingModel.dart';

class UploadImageScreen extends StatefulWidget {
  static String routeName = 'Upload Image Screen';

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final List<XFile> imagesList = [];
  late Box<OfflineImage> offlineImagesBox;
  late StreamSubscription<InternetConnectionStatus> internetSubscription;
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    openBox();
    // Hive.registerAdapter(OfflineImageAdapter());
    checkAndUploadOfflineImages();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        hasInternet = status == InternetConnectionStatus.connected;
        if (hasInternet) {
          checkAndUploadOfflineImages();
        }
        // this.hasInternet = hasInternet;
      });
    });
  }

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  Future<void> openBox() async {
    offlineImagesBox = await Hive.openBox<OfflineImage>('offlineImagesBox');
  }

  Future<void> pickImage() async {
    List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        imagesList.addAll(selectedImages);
      });
    }
  }

  Future<void> uploadFile(File image) async {
    try {
      String url = 'https://blahblahblah/api/provider-document-save';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('provider_document', image.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        print("Image uploaded successfully");
        Navigator.of(context).pushNamed(HomeScreen.routeName);
      } else {
        throw Exception("Failed to upload image");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> submitImages() async {
    if(imagesList.length < 4){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('you should upload at least 4 images')),
      );
    }
    else{
      if (!hasInternet) {
      saveImagesLocally();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved offline. Images will upload when online.')),
      );
    } else {
      await uploadImages();
    }}

  }

  Future<void> uploadImages() async {
    for (var image in imagesList) {
      await uploadFile(File(image.path));
    }
    setState(() {
      imagesList.clear();
    });
    await offlineImagesBox.clear();
  }

  void saveImagesLocally() {
    for (var image in imagesList) {
      offlineImagesBox.add(OfflineImage(imagePath: image.path));
    }
    setState(() {
      imagesList.clear();
    });
  }

  void checkAndUploadOfflineImages() async {
    if (hasInternet) {
      for (var offlineImage in offlineImagesBox.values) {
        await uploadFile(File(offlineImage.imagePath));
      }
      await offlineImagesBox.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(

      appBar: AppBar(title: Text('Upload Images')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: imagesList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  return Image.file(
                    File(imagesList[index].path),
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitImages,
              child: Text('Submit Images'),
            ),
          ],
        ),
      ),
    );
  }
}
