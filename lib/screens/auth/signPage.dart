import 'dart:io';

import 'package:chetchat/screens/profile_Set.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../../api/apis.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';
import '../../widgets/button.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController conformpasswordC = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _key = GlobalKey<FormState>();
  String name = '';
  bool loading = false;

  // handles google login button click

 signInWithGoogle() async {
      // Trigger the authentication flow
      var googleUser = GoogleSignIn();
      var sign = await googleUser.signIn();

      // Obtain the auth details from the request
      var googleAuth =
      await sign!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await APIs.auth.signInWithCredential(credential);
      if(FirebaseAuth.instance.currentUser != null){
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
      }else{
        Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Registration With Email',style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15.0),
            child: Column(
              children: [
                // Image.asset('assert/images/sign.png'),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text('Hello $name',
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: emailC,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.black),
                          label: const Text('Enter Your Email',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          hintText: 'Enter Email...',
                          hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2, color: Colors.redAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordC,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.remove_red_eye_outlined,
                              color: Colors.black),
                          label: const Text('Enter Your Password',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          hintText: 'Enter Password...',
                          hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2, color: Colors.redAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: conformpasswordC,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.remove_red_eye_outlined,
                              color: Colors.black),
                          label: const Text('Enter Your Conform Password',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          hintText: 'Enter Conform Password...',
                          hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2, color: Colors.redAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Conform Password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Button(
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    if(_key.currentState!.validate()){
                      _auth.createUserWithEmailAndPassword(email: emailC.text.toString(), password: passwordC.text.toString()).then((value){

                        setState(() {
                          loading = false;
                        });

                        FirebaseFirestore.instance.collection("UserData").doc(FirebaseAuth.instance.currentUser!.uid).set({
                          "Email" : emailC.text.toString(),
                          "Password" : passwordC.text.toString()
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                      }).onError((error, stackTrace){
                        setState(() {
                          loading = false;
                        });
                      });
                      if(passwordC.text != conformpasswordC.text){
                        setState(() {
                          loading = false;
                        });

                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(),));
                    }
                  },
                  title: 'Sign',
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // const Text(
                //   'Login with Other Process',
                //   style: TextStyle(
                //       fontWeight: FontWeight.w800, color: Colors.blueAccent),
                // ),
                // const SizedBox(
                //   height: 30,
                // ),
                // ElevatedButton.icon(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                //         shape: const StadiumBorder(),
                //         elevation: 1),
                //     onPressed: () {
                //       try{
                //         signInWithGoogle();
                //       }on FirebaseAuthException catch(e){
                //         Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)');
                //       }
                //     },
                //
                //     //google icon
                //     icon: Image.asset('images/google.png', height: mq.height * .03),
                //
                //     //login with google label
                //     label: RichText(
                //       text: const TextSpan(
                //           style: TextStyle(color: Colors.black, fontSize: 16),
                //           children: [
                //             TextSpan(text: 'Login with '),
                //             TextSpan(
                //                 text: 'Google',
                //                 style: TextStyle(fontWeight: FontWeight.w500)),
                //           ]),
                //     ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
