import 'dart:io';
import 'package:hive/hive.dart';
part 'storingModel.g.dart';
@HiveType(typeId: 0)
class OfflineImage {
  @HiveField(0)
  final String imagePath;

  OfflineImage({required this.imagePath});
}
