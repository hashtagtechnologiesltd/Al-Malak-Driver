import 'package:al_malak_drivers/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import '../global/global.dart';
import 'main_screen.dart';

class OTPScreenRegister extends StatefulWidget {

  final String name;
  final String address;
  final String phone;
  final String car_model;
  final String car_number;
  final String car_color;
  final String type;

  OTPScreenRegister({
    required this.name,
    required this.address,
    required this.phone,
    required this.car_model,
    required this.car_number,
    required this.car_color,
    required this.type,
  });

  @override
  State<OTPScreenRegister> createState() => _OTPScreenRegisterState();
}

class _OTPScreenRegisterState extends State<OTPScreenRegister> {
  final otpTextEditingController = TextEditingController();

  var code="";

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme ? 'images/city_dark.jpg' : 'images/city.jpg'),

                SizedBox(height: 20,),

                Text(
                  'Login',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Pinput(
                            length: 6,
                            showCursor: true,
                            onChanged: (value) {
                              code=value;
                            },
                          ),

                          SizedBox(height: 20,),

                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: darkTheme ? Colors.black : Colors.white, backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () async {
                                try {
                                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: RegisterScreen.verify, smsCode: code);
                                  await firebaseAuth.signInWithCredential(credential);

                                  Map userMap = {
                                    "id": firebaseAuth.currentUser!.uid,
                                    "name": widget.name,
                                    "address": widget.address,
                                    "phone": widget.phone,
                                  };

                                  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
                                  userRef.child(firebaseAuth.currentUser!.uid).set(userMap);

                                  Map driverCarInfoMap = {
                                    "car_model": widget.car_model,
                                    "car_number": widget.car_number,
                                    "car_color": widget.car_color,
                                    "type": widget.type,
                                  };

                                  DatabaseReference userRef2 = FirebaseDatabase.instance.ref().child("drivers");
                                  userRef2.child(firebaseAuth.currentUser!.uid).child("car_details").set(driverCarInfoMap);

                                  Fluttertoast.showToast(msg: "Registration Successful");

                                  await Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
                                }
                                catch(e) {
                                  print("wrong otp");
                                }
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                          ),

                          SizedBox(height: 20,),

                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(context, MaterialPageRoute(builder: (c) => ForgotPasswordScreen()));
                          //   },
                          //   child: Text(
                          //     'Forgot Password?',
                          //     style: TextStyle(
                          //       color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                          //     ),
                          //   ),
                          // ),
                          //
                          // SizedBox(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Doesn't have an account?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),

                              SizedBox(width: 5,),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (c) => RegisterScreen()));
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
