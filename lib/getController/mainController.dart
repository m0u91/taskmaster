import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmaster/sqlLiteModels/tasksModel.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../sqlLiteModels/createDb.dart';



class mainControoler extends GetxController{



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getNoteFromSql();
    getTheme();
    getColor();
  }


  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();
    Get.find<mainControoler>().onStart();
  }




  int page = 2;
  String title = 'اضافة المهام';
  changePage(index,ti){
    page = index;
    title = ti;
    update();
  }

















  backgroundColor(){
    if(isDarkMode){
      return const LinearGradient(
          colors: [Color(0xff485563),Color(0xff29323c)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft
      );
    }else{
      return const LinearGradient(
          colors:  [Color(0xffE0EAFC),Color(0xffCFDEF3)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft
      );
    }
  }
  widgetColor(){
    if(isDarkMode){
      return const Color(0xff29323c);
    }else{
      return const Color(0xffCFDEF3);
    }
  }
  textColor(){
    if(isDarkMode){
      return Colors.white;
    }else{
      return Colors.black;
    }
  }
  Color primaryColor = Colors.deepOrange;



  ///For Dark Mode
  bool isDarkMode = false;
  changeTheme(state)async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    if(state == true){
      isDarkMode = true;
      Get.changeTheme(ThemeData.dark());
      perf.setBool('theme', state);
      update();
    }else{
      isDarkMode = false;
      Get.changeTheme(ThemeData.light());
      perf.setBool('theme', state);
      update();
    }
    update();
  }
  getTheme()async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    if(perf.getBool('theme') == null){
      perf.setBool('theme', isDarkMode);
    }else{
      isDarkMode = perf.getBool('theme')!;
    }
    update();
  }

  changeColor(Color color)async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    final userJson = jsonEncode({
      'red': color.red,
      'green': color.green,
      'blue': color.blue,
      'alpha': color.alpha,
    });
    primaryColor = color;
    perf.setString('color', userJson);
    update();
  }
  getColor()async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    if(perf.getString('color') != null){
      final userJson = perf.getString('color');
      final userMap = jsonDecode(userJson!) as Map<String, dynamic>;
      int red = userMap['red'];
      int green = userMap['green'];
      int blue = userMap['blue'];
      int alpha = userMap['alpha'];
      Color waitUser = Color.fromARGB(alpha, red, green, blue);
      primaryColor = waitUser;
    }
    update();
  }


  returnMessgae(ti,des){
    Get.snackbar(ti, des,
        titleText: Text(ti,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: isDarkMode ? Colors.white : Colors.black),),messageText:
        Text(des,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: isDarkMode ? Colors.white : Colors.black),));
  }

  ///-------------------


  Sql sql = Sql();
  List<TasksModel> tasks = [];
  getNoteFromSql() async {
    tasks.clear();
    tasks = await sql.readDataSql('taskTable');
    tasks = tasks.reversed.toList();
    update();
  }





  showTask(AnimationController animationController,Widget widget){
    Get.bottomSheet(BottomSheet(
      onClosing: (){},
      backgroundColor: widgetColor(),
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          )
      ),
      animationController: animationController,
      builder: (context){
        return widget;
      },
    ));
  }

  bool containsDate(List<TasksModel> list, String targetDate) {
    return list.any((item) => item.date == targetDate);
  }



  Future<void> scheduleNotifications(int hour, int minutes,title,body) async {


    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
        provisional: true
    );

      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          title,
          body,
          convertTime(hour,minutes),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description',sound: RawResourceAndroidNotificationSound('sound'))),
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time
    );
  }

  tz.TZDateTime convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime schedulDate = tz.TZDateTime(tz.local,now.year,now.month,now.day,hour,minutes);

    if(schedulDate.isBefore(now)){
      schedulDate = schedulDate.add(const Duration(days: 1));
    }
    return schedulDate;
  }




  InitializationNotification()async{
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(onDidReceiveLocalNotification: (int id, String? s, String? d, String? f){});
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse res){});
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
        provisional: true
    );

  }

}