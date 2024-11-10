import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget{
  String fieldName;
  String hintText;
  Widget? suffixIcon;
  bool isObscure;
  var keyboardType;
  String? Function(String?)? validator;
  TextEditingController controller ;
  void Function()? onTap;
  bool readOnly;

  AppTextField({
    required this.fieldName,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.isObscure = false,
    this.readOnly = false,
    this.validator,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              fieldName,
              style: TextStyle(
                fontSize: 20,color: Colors.black
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  hintText: hintText,
                  hintStyle: TextStyle(
                     fontSize: 20, color: Colors.grey
                  ),
                  suffixIcon: suffixIcon),
              style: const TextStyle(color: Colors.black),
              validator: validator,
              controller: controller,
              obscureText: isObscure,
              keyboardType: keyboardType,
              onTap: onTap,
              readOnly: readOnly,
            ),
          )
        ],
      ),
    );

  }
  
}