import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskmaster/getController/mainController.dart';
import 'package:taskmaster/pages/login.dart';

import '../getController/loading.dart';

class profile extends StatefulWidget {
  String name;
   profile({Key? key,required this.name}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

  TextEditingController name = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      setState(() {
        name.text = widget.name;
      });
    }
  }

  bool load = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<mainControoler>(
      builder: (value){
        return Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: Text('الملف الشخصي',textAlign: TextAlign.center,
              style: GoogleFonts.almarai(fontSize: 16,color: value.textColor()),),
            backgroundColor: value.widgetColor(),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){Get.back();},
              icon: Icon(Icons.keyboard_arrow_left,color: value.textColor(),),
            ),
            actions: [
              IconButton(
                onPressed: (){
                  Get.defaultDialog(
                      title: 'هل ترغب بتسجيل الخروج',
                      titleStyle: GoogleFonts.almarai(fontSize: 17,color: value.textColor()),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green
                              ),
                              child: Center(
                                child: Text('الغاء',textAlign: TextAlign.center,
                                  style: GoogleFonts.almarai(fontSize: 15,color: Colors.white),),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: ()async{
                              await auth.signOut();
                              Get.forceAppUpdate();
                              setState(() {

                              });
                              Get.back();
                              Get.back();
                            },
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                              ),
                              child: Center(
                                child: Text('خروج',textAlign: TextAlign.center,
                                  style: GoogleFonts.almarai(fontSize: 15,color: Colors.white),),
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: value.widgetColor(),
                      titlePadding: const EdgeInsets.symmetric(vertical: 20)
                  );
                },
                icon: Icon(Icons.outbound_outlined,color: value.textColor(),),
              ),
            ],
          ),
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                  gradient: value.backgroundColor()
              ),
              child: ListView(
                children: [
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('عدل معلومات الشخصيه',textAlign: TextAlign.right,
                        style: GoogleFonts.almarai(fontSize: 16,color: value.textColor(),fontWeight: FontWeight.bold),),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        controller: name,
                        onChanged: (v){
                          setState(() {

                          });
                        },
                        style: GoogleFonts.almarai(fontSize: 16,color: value.textColor(),),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'اختر اسم لحسابك',
                          suffixIcon: Icon(Icons.person_outline_sharp,color: value.primaryColor,),
                          fillColor: value.widgetColor(),
                          hintStyle: GoogleFonts.almarai(fontSize: 16,color: value.textColor(),),
                          counterStyle: TextStyle(color: value.primaryColor),
                          labelStyle: TextStyle(color: value.primaryColor),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:  BorderSide(color: value.textColor()),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: value.textColor()),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:  BorderSide(color: value.textColor()),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: InkWell(
                      onTap: ()async{
                        setState(() {
                          load = true;
                        });
                        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                        await _firestore.collection('users').doc(auth.currentUser!.uid).update({
                          'name': name.text,
                        });
                        setState(() {
                          load = false;
                        });
                        Get.back();
                        value.returnMessgae('تنبيه', 'تم تعديل معلومات الشخصيه');
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
                            ) : Text('حفظ', style: GoogleFonts.almarai(fontSize: 15,color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
