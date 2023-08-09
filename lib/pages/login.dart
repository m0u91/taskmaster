import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:http/http.dart' as http;
import 'package:taskmaster/getController/mainController.dart';
import 'package:uuid/uuid.dart';

import '../getController/loading.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
class login extends StatefulWidget {
  bool close;
  login({Key? key,required this.close}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  bool load = false;
  bool loginn = true;
  bool hide = true;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<mainControoler>(
      init: mainControoler(),
      builder: (value){
        return Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: InkWell(
              onTap: (){
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      gradient: value.backgroundColor()
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: -200,
                        left: -200,
                        child: Lottie.asset('imgs/shap.json'),
                      ),
                      ///Blur
                      Positioned.fill(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 24,
                                    spreadRadius: 16,
                                    color: Colors.black.withOpacity(0.2)
                                )
                              ]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 15.0,
                                sigmaY: 15.0,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      /// Shap
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * (0.20),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40),bottomLeft: Radius.circular(40)),
                              color: value.primaryColor
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: MediaQuery.of(context).padding.top == 0.0 ? 10 : MediaQuery.of(context).padding.top,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      if(widget.close){
                                        Get.back();
                                      }
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.close,color: value.textColor(),),
                                      ),
                                    ),
                                  ),
                                  Text('Task Master',textAlign: TextAlign.center,
                                  style: GoogleFonts.almarai(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
                                  InkWell(
                                    onTap: (){
                                      if(widget.close){
                                        Get.back();
                                      }
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.close,color: Colors.transparent,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      /// Main Card
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        left: 0,
                        right: 0,
                        top: (MediaQuery.of(context).size.height * 0.15),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: MediaQuery.of(context).size.width,
                                height: 300 ,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: value.backgroundColor()
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 20,),
                                      Text(loginn ? 'سجل الدخول الى حسابك' : 'انشاء حساب جديد',textAlign: TextAlign.center,
                                        style: GoogleFonts.almarai(fontSize: 15,color: value.textColor(),fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 20,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                        child: SizedBox(
                                          height: 45,
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.left,
                                            controller: email,
                                            onChanged: (v){
                                              setState(() {

                                              });
                                            },
                                            style: GoogleFonts.almarai(fontSize: 16,color: value.textColor(),),
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: 'Email',
                                              suffixIcon: Icon(Icons.email_outlined,color: value.primaryColor,),
                                              fillColor: value.widgetColor(),
                                              hintStyle: GoogleFonts.almarai(fontSize: 16,color: value.textColor(),),
                                              counterStyle: TextStyle(color: value.primaryColor),
                                              labelStyle: TextStyle(color: value.primaryColor),
                                              enabledBorder: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(color: Colors.transparent),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(color: Colors.transparent),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(color: Colors.transparent),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                        child: SizedBox(
                                          height: 45,
                                          child: TextFormField(
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: hide,
                                            textAlign: TextAlign.left,
                                            controller: password,
                                            onChanged: (v){
                                              setState(() {

                                              });
                                            },
                                            style: GoogleFonts.almarai(fontSize: 16,color: value.textColor(),),
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: 'Password',
                                              suffixIcon: Icon(Icons.password,color: value.primaryColor,),
                                              prefix: InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    hide = !hide;
                                                  });
                                                },
                                                child: Icon(Icons.remove_red_eye_outlined,color: hide ? value.primaryColor : value.textColor(),),
                                              ),
                                              fillColor: value.widgetColor(),
                                              hintStyle: GoogleFonts.almarai(fontSize: 16,color: value.textColor(),),
                                              counterStyle: TextStyle(color: value.primaryColor),
                                              labelStyle: TextStyle(color: value.primaryColor),
                                              enabledBorder: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(color: Colors.transparent),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(color: Colors.transparent),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(color: Colors.transparent),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 60),
                                        child: InkWell(
                                          onTap: ()async{
                                            setState(() {
                                              load = true;
                                            });
                                            if(loginn){
                                              login(value);
                                            }else{
                                              signup(value);
                                            }
                                          },
                                          child: Card(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 250),
                                              width: MediaQuery.of(context).size.width,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(40),
                                                  color: value.primaryColor
                                              ),
                                              child: Center(
                                                child: load ? const  Padding(
                                                  padding:  EdgeInsets.all(7),
                                                  child: loading(),
                                                ) : Text(loginn ? 'تسجيل' : 'انشاء', style: GoogleFonts.almarai(fontSize: 15,color: Colors.white),),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            loginn = !loginn;
                                          });
                                        },
                                        child: Text(loginn ? 'هل تريد انشاء حساب جديد' : 'لديك حساب بالفعل .. ؟',textAlign: TextAlign.center,
                                          style: GoogleFonts.almarai(fontSize: 12,color: value.primaryColor,fontWeight: FontWeight.bold),),
                                      ),
                                      const SizedBox(height: 10,),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
              ),
            ),
          ),
        );
      },
    );
  }


  login(mainControoler value)async{
    try {
      await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      User? user = auth.currentUser;
      print(user);
      setState(() {
        load = false;
      });
      Get.back();
    } catch (e) {
      value.returnMessgae('عذرا', 'المعلومات التي ادخلتها غير صحيحه');
      setState(() {
        load = false;
      });
      print(e);
    }
  }
  signup(mainControoler value)async{
    try {
      await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
      User? user = auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email.text,
          'password': password.text,
          'phone': '',
          'name': '',
          'id': user.uid,
          'date': DateTime.now()
        });
        await login(value);
      }
      setState(() {
        load = false;
      });
      Get.back();
    } catch (e) {
      value.returnMessgae('عذرا', 'المعلومات التي ادخلتها غير صحيحه');
      setState(() {
        load = false;
      });
      print(e);
    }
  }

}
