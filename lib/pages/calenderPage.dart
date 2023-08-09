import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:taskmaster/getController/mainController.dart';
import 'package:taskmaster/sqlLiteModels/tasksModel.dart';

import 'calender.dart';

class calenderPage extends StatefulWidget {
  const calenderPage({Key? key}) : super(key: key);

  @override
  State<calenderPage> createState() => _calenderPageState();
}

class _calenderPageState extends State<calenderPage> with TickerProviderStateMixin {

  TasksModel? taskSelect;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<mainControoler>(
      builder: (value){
        return Column(
          children: [
            value.tasks.isEmpty ? const SizedBox() : SizedBox(
              width: Get.width,
              height: 90,
              child: ListView.builder(
                itemCount: value.tasks.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  return widgetDayShape(value,value.tasks[index],DateTime.parse(value.tasks[index].date.toString()));
                },
              ),
            ),
            value.tasks.isEmpty ? const SizedBox() : const SizedBox(height: 20,),
            Expanded(
              child: calender(),
            )
          ],
        );
      },
    );
  }

  widgetDayShape(mainControoler value,TasksModel task,DateTime dateTime){
    return InkWell(
      onTap: (){
        setState(() {
          taskSelect = task;
        });
        value.showTask(AnimationController(vsync: this, duration: const Duration(milliseconds: 300),),
            ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.black26
                              ),
                              child: Center(
                                child: Icon(Icons.close,color: value.textColor(),size: 17,),
                              ),
                            ),
                          ),
                          Text('مهام اليوم',textAlign: TextAlign.right,
                            style: GoogleFonts.almarai(fontSize: 17,color: value.textColor(),fontWeight: FontWeight.bold),),
                          InkWell(
                              onTap: (){
                                Get.back();
                                value.showTask(AnimationController(vsync: this, duration: const Duration(milliseconds: 300),),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('هل ترغب بالحذف .. ؟',textAlign: TextAlign.center,
                                          style: GoogleFonts.almarai(fontSize: 14,color: value.textColor()),),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (){Get.back();},
                                              child: Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.green,
                                                ),
                                                child: Center(
                                                  child: Text('الغاء',textAlign: TextAlign.center,
                                                    style: GoogleFonts.almarai(fontSize: 14,color: Colors.white),),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            InkWell(
                                              onTap: ()async{
                                                await value.sql.deleteDataSql('taskTable', 'id = ?', task.id);
                                                value.getNoteFromSql();
                                                Get.back();
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.red,
                                                ),
                                                child: Center(
                                                  child: Text('حذف',textAlign: TextAlign.center,
                                                    style: GoogleFonts.almarai(fontSize: 14,color: Colors.white),),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                      ],
                                    ));
                              },
                              child: Center(
                                child: Icon(Icons.delete,color: value.textColor(),size: 25,),
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                      width: Get.width,
                      height: 1,
                      color: value.textColor(),
                    ),
                    task.images == null || task.images == '' ? const SizedBox() : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(Uint8List.fromList(task.images.toString()
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .split(', ').map((e) => int.parse(e)).toList()),
                        width: 100,height: 100,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: value.widgetColor(),
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: value.widgetColor(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(task.notification == 1 ? Icons.notifications_on_outlined : Icons.notifications_off_outlined,color: value.primaryColor,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.7,
                                    child: Text(task.name ?? '',textAlign: TextAlign.right,
                                      style: GoogleFonts.almarai(fontSize: 15,color: value.textColor(),fontWeight: FontWeight.bold,decoration: task.done == 0 ? TextDecoration.none : TextDecoration.lineThrough),),
                                  ),
                                  const SizedBox(height: 5,),
                                  SizedBox(
                                    width: Get.width * 0.7,
                                    child: Text(task.des ?? '',textAlign: TextAlign.right,
                                      style: GoogleFonts.almarai(fontSize: 12,color: value.textColor(),decoration: task.done == 0 ? TextDecoration.none : TextDecoration.lineThrough),),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(task.create.toString().split(' ').first ?? '',textAlign: TextAlign.right,
                                    style: GoogleFonts.almarai(fontSize: 10,color: value.textColor()),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70,),
              ],
            ));
      },
      child: Card(
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          )
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 5),
          width: MediaQuery.of(context).size.width / 6.8,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            color: taskSelect == null ? value.widgetColor() : (taskSelect!.id == task.id ? value.primaryColor : value.widgetColor())
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(task.done == 0 ? Icons.not_interested_sharp : Icons.done_outline_rounded,color: task.done == 0 ? (taskSelect == null ? Colors.red : (taskSelect!.id == task.id ? Colors.white : Colors.red)) : (taskSelect == null ? Colors.green : (taskSelect!.id == task.id ? Colors.white : Colors.green)),size: 30,),
              Column(
                children: [
                  Text('يوم',textAlign: TextAlign.center,
                    style: GoogleFonts.almarai(fontSize: 16,color: taskSelect == null ? value.textColor() : (taskSelect!.id == task.id ? Colors.white : value.textColor()),fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text(DateTime.parse(task.date.toString()).day.toString(),textAlign: TextAlign.center,
                    style: GoogleFonts.almarai(fontSize: 15,color: taskSelect == null ? value.textColor() : (taskSelect!.id == task.id ? Colors.white : value.textColor())),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
