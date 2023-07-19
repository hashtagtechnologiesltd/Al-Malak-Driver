import 'package:al_malak_drivers/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class OTPScreenLogin extends StatefulWidget {
  const OTPScreenLogin({Key? key}) : super(key: key);

  @override
  State<OTPScreenLogin> createState() => _OTPScreenLoginState();
}

class _OTPScreenLoginState extends State<OTPScreenLogin> {

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
                                primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                onPrimary: darkTheme ? Colors.black : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () async {
                                try {
                                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: LoginScreen.verify, smsCode: code);
                                  await firebaseAuth.signInWithCredential(credential);

                                  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
                                  userRef.child(firebaseAuth.currentUser!.uid).once().then((value) async {
                                    final snap = value.snapshot;
                                    if(snap.value != null){
                                      //currentUser = auth.user;
                                      await Fluttertoast.showToast(msg: "Successfully Logged In");
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
                                    }
                                    else {
                                      await Fluttertoast.showToast(msg: "No record exist with this phone number");
                                      firebaseAuth.signOut();
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                                    }
                                  });

                                  //Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
                                }
                                catch(e) {
                                  await Fluttertoast.showToast(msg: "Wrong OTP");
                                  firebaseAuth.signOut();
                                  Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                                  // print("wrong otp");
                                }
                              },
                              child: Text(
                                'Login',
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
