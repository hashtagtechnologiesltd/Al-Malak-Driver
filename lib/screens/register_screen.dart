import 'package:drivers/screens/car_info_screen.dart';
import 'package:drivers/screens/main_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../global/global.dart';
import 'otp_screen_register.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String verify="";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();
  final carModelTextEditingController = TextEditingController();
  final carNumberTextEditingController = TextEditingController();
  final carColorTextEditingController = TextEditingController();

  List<String> carTypes = ["Car", "CNG", "Bike"];
  String? selectedCarType;

  bool _passwordVisible = false;

  //declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    // validate all the form fields
    if(_formKey.currentState!.validate()) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneTextEditingController.text,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          RegisterScreen.verify = verificationId;

          Navigator.push(context, MaterialPageRoute(builder: (c) => OTPScreenRegister(
            name: nameTextEditingController.text,
            address: addressTextEditingController.text,
            phone: phoneTextEditingController.text,
            car_model: carModelTextEditingController.text,
            car_number: carNumberTextEditingController.text,
            car_color: carColorTextEditingController.text,
            type: selectedCarType!,
          )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      // await firebaseAuth.createUserWithEmailAndPassword(
      //     email: emailTextEditingController.text.trim(),
      //     password: passwordTextEditingController.text.trim()
      // ).then((auth) async {
      //   currentUser = auth.user;
      //
      //   if(currentUser != null){
      //     Map userMap = {
      //       "id": currentUser!.uid,
      //       "name": nameTextEditingController.text.trim(),
      //       "email": emailTextEditingController.text.trim(),
      //       "address": addressTextEditingController.text.trim(),
      //       "phone": phoneTextEditingController.text.trim(),
      //     };
      //
      //     DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
      //     userRef.child(currentUser!.uid).set(userMap);
      //
      //   }
      //   await Fluttertoast.showToast(msg: "Successfully Registered");
      //   Navigator.push(context, MaterialPageRoute(builder: (c) => CarInfoScreen()));
      // }).catchError((errorMessage) {
      //   Fluttertoast.showToast(msg: "Error occurred: \n $errorMessage");
      // });
    }
    else{
      Fluttertoast.showToast(msg: "Not all field are valid");
    }
  }

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
                  'Register',
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
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Name can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid name";
                                }
                                if(text.length > 49){
                                  return "Name can\'t be more than 50";
                                }
                              },
                              onChanged: (text) => setState(() {
                                nameTextEditingController.text = text;
                              }),
                            ),

                            // SizedBox(height: 20,),
                            //
                            // TextFormField(
                            //   inputFormatters: [
                            //     LengthLimitingTextInputFormatter(100)
                            //   ],
                            //   decoration: InputDecoration(
                            //     hintText: "Email",
                            //     hintStyle: TextStyle(
                            //       color: Colors.grey,
                            //     ),
                            //     filled: true,
                            //     fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                            //     border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(40),
                            //         borderSide: BorderSide(
                            //           width: 0,
                            //           style: BorderStyle.none,
                            //         )
                            //     ),
                            //     prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                            //   ),
                            //   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //   validator: (text) {
                            //     if(text == null || text.isEmpty){
                            //       return 'Email can\'t be empty';
                            //     }
                            //     if(EmailValidator.validate(text) == true){
                            //       return null;
                            //     }
                            //     if(text.length < 2) {
                            //       return "Please enter a valid email";
                            //     }
                            //     if(text.length > 99){
                            //       return "Email can\'t be more than 100";
                            //     }
                            //   },
                            //   onChanged: (text) => setState(() {
                            //     emailTextEditingController.text = text;
                            //   }),
                            // ),

                            SizedBox(height: 20,),

                            IntlPhoneField(
                              showCountryFlag: false,
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down,
                                color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                              ),
                              decoration: InputDecoration(
                                hintText: "Phone",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                              ),
                              initialCountryCode: 'BD',
                              onChanged: (text) => setState(() {
                                phoneTextEditingController.text = text.completeNumber;
                              }),
                            ),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Address",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Address can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid address";
                                }
                                if(text.length > 99){
                                  return "Address can\'t be more than 100";
                                }
                              },
                              onChanged: (text) => setState(() {
                                addressTextEditingController.text = text;
                              }),
                            ),

                            SizedBox(height: 20,),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Model",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Name can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid name";
                                }
                                if(text.length > 49){
                                  return "Name can\'t be more than 50";
                                }
                              },
                              onChanged: (text) => setState(() {
                                carModelTextEditingController.text = text;
                              }),
                            ),

                            SizedBox(height: 20,),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Number",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Name can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid name";
                                }
                                if(text.length > 49){
                                  return "Name can\'t be more than 50";
                                }
                              },
                              onChanged: (text) => setState(() {
                                carNumberTextEditingController.text = text;
                              }),
                            ),

                            SizedBox(height: 20,),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Color",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Name can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid name";
                                }
                                if(text.length > 49){
                                  return "Name can\'t be more than 50";
                                }
                              },
                              onChanged: (text) => setState(() {
                                carColorTextEditingController.text = text;
                              }),
                            ),

                            SizedBox(height: 20,),

                            DropdownButtonFormField(
                                decoration: InputDecoration(
                                    hintText: 'Please Choose Car Type',
                                    prefixIcon: Icon(Icons.car_crash, color: darkTheme? Colors.amber.shade400 : Colors.grey,),
                                    filled: true,
                                    fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )
                                    )
                                ),
                                items: carTypes.map((car){
                                  return DropdownMenuItem(
                                    child: Text(
                                      car,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    value: car,
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCarType = newValue.toString();
                                  });
                                }
                            ),

                            SizedBox(height: 20,),

                            // SizedBox(height: 20,),
                            //
                            // TextFormField(
                            //   obscureText: !_passwordVisible,
                            //   inputFormatters: [
                            //     LengthLimitingTextInputFormatter(50)
                            //   ],
                            //   decoration: InputDecoration(
                            //     hintText: "Password",
                            //     hintStyle: TextStyle(
                            //       color: Colors.grey,
                            //     ),
                            //     filled: true,
                            //     fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                            //     border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(40),
                            //         borderSide: BorderSide(
                            //           width: 0,
                            //           style: BorderStyle.none,
                            //         )
                            //     ),
                            //     prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                            //     suffixIcon: IconButton(
                            //       icon: Icon(
                            //         _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            //         color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                            //       ),
                            //       onPressed: () {
                            //         // update the state i.e toggle the state of passwordVisible variable
                            //         setState(() {
                            //           _passwordVisible = !_passwordVisible;
                            //         });
                            //       },
                            //     )
                            //   ),
                            //   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //   validator: (text) {
                            //     if(text == null || text.isEmpty){
                            //       return 'Password can\'t be empty';
                            //     }
                            //     if(text.length < 6) {
                            //       return "Please enter a valid password";
                            //     }
                            //     if(text.length > 49){
                            //       return "Password can\'t be more than 50";
                            //     }
                            //     return null;
                            //   },
                            //   onChanged: (text) => setState(() {
                            //     passwordTextEditingController.text = text;
                            //   }),
                            // ),
                            //
                            // SizedBox(height: 20,),
                            //
                            // TextFormField(
                            //   obscureText: !_passwordVisible,
                            //   inputFormatters: [
                            //     LengthLimitingTextInputFormatter(50)
                            //   ],
                            //   decoration: InputDecoration(
                            //       hintText: "Confirm Password",
                            //       hintStyle: TextStyle(
                            //         color: Colors.grey,
                            //       ),
                            //       filled: true,
                            //       fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(40),
                            //           borderSide: BorderSide(
                            //             width: 0,
                            //             style: BorderStyle.none,
                            //           )
                            //       ),
                            //       prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                            //       suffixIcon: IconButton(
                            //         icon: Icon(
                            //           _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            //           color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                            //         ),
                            //         onPressed: () {
                            //           // update the state i.e toggle the state of passwordVisible variable
                            //           setState(() {
                            //             _passwordVisible = !_passwordVisible;
                            //           });
                            //         },
                            //       )
                            //   ),
                            //   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //   validator: (text) {
                            //     if(text == null || text.isEmpty){
                            //       return 'Confirm Password can\'t be empty';
                            //     }
                            //     if(text != passwordTextEditingController.text){
                            //       return "Password do not match";
                            //     }
                            //     if(text.length < 6) {
                            //       return "Please enter a valid password";
                            //     }
                            //     if(text.length > 49){
                            //       return "Password can\'t be more than 50";
                            //     }
                            //     return null;
                            //   },
                            //   onChanged: (text) => setState(() {
                            //     confirmTextEditingController.text = text;
                            //   }),
                            // ),

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
                              onPressed: () {
                                _submit();
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ),

                            SizedBox(height: 20,),

                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                ),
                              ),
                            ),

                            SizedBox(height: 20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Have an account?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),

                                SizedBox(width: 5,),

                                GestureDetector(
                                  onTap: () {
                                  },
                                  child: Text(
                                    "Sign In",
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

















