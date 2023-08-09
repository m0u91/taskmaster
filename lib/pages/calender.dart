import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmaster/getController/mainController.dart';
import 'package:taskmaster/sqlLiteModels/tasksModel.dart';


class calender extends StatefulWidget {
  @override
  _calenderState createState() => _calenderState();
}

class _calenderState extends State<calender> with TickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final firstDay = DateTime(DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final lastDay = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<mainControoler>(
      builder: (value){
        return TableCalendar(
          firstDay: firstDay,
          lastDay: lastDay,
          calendarStyle: CalendarStyle(
            rangeEndTextStyle: TextStyle(color: value.textColor()),
            defaultTextStyle: TextStyle(color: value.textColor()),
            disabledTextStyle: TextStyle(color: value.textColor()),
            rangeStartTextStyle: TextStyle(color: value.textColor()),
            outsideTextStyle: TextStyle(color: value.textColor()),
            weekendTextStyle: TextStyle(color: value.textColor()),
            selectedTextStyle: TextStyle(color: value.textColor()),
            holidayTextStyle: TextStyle(color: value.textColor()),
            weekNumberTextStyle: TextStyle(color: value.textColor()),
            withinRangeTextStyle: TextStyle(color: value.textColor()),
            todayTextStyle: TextStyle(color: value.textColor()),

          ),
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(color: value.textColor()),
            formatButtonTextStyle: TextStyle(color: value.textColor()),
            leftChevronIcon: Icon(Icons.chevron_left_outlined,color: value.primaryColor,),
            rightChevronIcon: Icon(Icons.chevron_right_outlined,color: value.primaryColor,)
          ),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              if(value.tasks.any((item) => item.date.toString().split(' ').first == selectedDay.toString().split(' ').first)){
                int? index = value.tasks.indexWhere((item) => item.date.toString().split(' ').first == selectedDay.toString().split(' ').first);
                if(index != null){
                  TasksModel? task = value.tasks[index];
                  if(task != null){
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
                  }
                }
              }else{
                value.showTask(AnimationController(vsync: this, duration: const Duration(milliseconds: 300),),
                    ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset('imgs/empty.json',),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: InkWell(
                                onTap: () async {Get.back();},
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  child: Container(
                                    width: Get.width,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: value.primaryColor
                                    ),
                                    child: Center(
                                      child: Text('ليس لديك اي مهام لهذا اليوم',textAlign: TextAlign.center,
                                        style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 70,),
                      ],
                    ));
              }
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        );
      },
    );
  }
}