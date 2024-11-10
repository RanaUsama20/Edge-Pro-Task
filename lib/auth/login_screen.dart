import 'package:flutter/material.dart';
import 'AppTextField.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget{
  static String routeName = 'Login Screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  bool isObscure = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 100,),
            Text('Sign in', style: TextStyle(
                color:  Colors.purple, fontSize: 30
            ),textAlign: TextAlign.center,),
            SizedBox(
              height:60 ,),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    AppTextField(
                      fieldName: 'Email',
                      hintText: 'Enter your email',
                      controller: emailController,
                      validator: (value){
                        if(value == null || value.trim().isEmpty){
                          return 'please enter your email';
                        }
                        bool validEmail = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!validEmail) {
                          return 'invalid email';
                        }
                        return null;
                      },
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
                  ],
                )
            ),
            Padding(
              padding: EdgeInsets.all(40),
              child: ElevatedButton(
                onPressed: () {
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
                      'Sign in',
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
                    'Don’t have an account?',
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
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                    child: Text(
                      'sign up',
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


}