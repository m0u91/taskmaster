import 'dart:ui';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:taskmaster/pages/setting.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:taskmaster/getController/mainController.dart';
import 'package:taskmaster/pages/addTask.dart';
import 'package:taskmaster/pages/calenderPage.dart';
import 'package:taskmaster/pages/mainPage.dart';

import 'main.dart';

class myHomePage extends StatefulWidget {
  const myHomePage({Key? key}) : super(key: key);

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final controller = Get.put(mainControoler());
    controller.InitializationNotification();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<mainControoler>(
      builder: (value){
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 2,
            title: Text(value.title,textAlign: TextAlign.center,
            style: GoogleFonts.almarai(fontSize: 16,color: value.textColor()),),
            backgroundColor: value.widgetColor(),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){Get.to(()=> const setting(),transition: Transition.fade);},
              icon: Icon(Icons.settings,color: value.textColor(),),
            ),
          ),
          body: Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
                gradient: value.backgroundColor()
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: thePage(value),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    decoration: BoxDecoration(
                        color: value.widgetColor(),
                        boxShadow: const [BoxShadow(
                            offset: Offset(-1,-1),
                            color: Colors.black26,
                            blurRadius: 30,
                            spreadRadius: 5
                        )]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            value.changePage(0, 'قائمة المهام');
                          },
                          child: bottomBarIcon(Icons.home,0,'قائمة المهام',value),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: InkWell(
                            onTap: (){
                              value.changePage(2, 'اضافة المهام');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                  color: value.page == 2 ? Colors.transparent : Colors.transparent
                              ),
                              width: MediaQuery.of(context).size.width * 0.19,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5,bottom: 5),
                                child: Icon(Icons.home,color: value.page == 2 ? Colors.white : value.textColor() ,size: 27,),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            value.changePage(4, 'التقويم');
                          },
                          child: bottomBarIcon(Icons.calendar_view_month_outlined,4,'التقويم',value),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: ()async{

                      value.changePage(2, 'اضافة المهام');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: value.page == 2 ? MediaQuery.of(context).size.width * 0.17 : MediaQuery.of(context).size.width * 0.15,
                          height: value.page == 2 ? MediaQuery.of(context).size.width * 0.17 : MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: value.primaryColor
                          ),
                          child: const Center(
                            child: Icon(Icons.add,color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }


  thePage(mainControoler value){
    if(value.page == 4){
      return const calenderPage();
    }else if(value.page == 2){
      return const addTask();
    }else{
      return const mainPage();
    }
  }



  bottomBarIcon(icon,index,title,mainControoler value){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.305,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon,color: value.page == index ? value.primaryColor : value.textColor().withOpacity(0.7),size: MediaQuery.of(context).size.width * 0.07,),
            const SizedBox(height: 5,),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: index == value.page ? MediaQuery.of(context).size.width * 0.12 : 0,
              height: 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: value.primaryColor
              ),
            )
          ],
        ),
      ),
    );
  }
}
