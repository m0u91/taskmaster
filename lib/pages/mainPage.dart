import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../getController/mainController.dart';
import '../sqlLiteModels/tasksModel.dart';

class mainPage extends StatefulWidget {

  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> with TickerProviderStateMixin {
  TextEditingController search = TextEditingController();
  List<TasksModel> searchResult = [];
  int done = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<mainControoler>(
      builder: (value){
        return Column(
          children: [
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.right,
                controller: search,
                onChanged: (v){
                  setState(() {
                    searchResult = value.tasks.where((element)=> element.name.toString().toLowerCase().contains(v.toLowerCase())).toList();
                  });
                },
                style: GoogleFonts.almarai(fontSize: 14,color: value.textColor(),),
                decoration: InputDecoration(
                  hintText: 'البحث',
                  filled: true,
                  fillColor: value.isDarkMode ? value.widgetColor() : const Color(0xffa2b5cc).withOpacity(0.5),
                  prefixIcon: Icon(Icons.search,color: value.primaryColor,),
                  suffixIcon: icon(value),
                  hintStyle: GoogleFonts.almarai(fontSize: 14,color: value.textColor(),),
                  counterStyle: TextStyle(color: value.primaryColor),
                  labelStyle: TextStyle(color: value.primaryColor),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          done = 0;
                        });
                      },
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: done == 0 ? value.primaryColor : value.widgetColor()
                          ),
                          child: Center(
                            child: Text('غير مكتمله',textAlign: TextAlign.center,
                            style: GoogleFonts.almarai(fontSize: 13,color: done == 0 ? Colors.white : value.textColor()),),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          done = 1;
                        });
                      },
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: done == 1 ? value.primaryColor : value.widgetColor()
                          ),
                          child: Center(
                            child: Text('مكتمله',textAlign: TextAlign.center,
                              style: GoogleFonts.almarai(fontSize: 13,color: done == 1 ? Colors.white : value.textColor()),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5,),
            Expanded(
              child: (value.tasks.where((element) => element.done == done)).isEmpty
                  ? Center(
                child: Text('لا توجد مهام حاليا',textAlign: TextAlign.center,
                style: GoogleFonts.almarai(fontSize: 13,color: value.textColor()),),
              )
                  :  ListView(
                children: (searchResult.isEmpty ? (value.tasks.where((element) => element.done == done)) : searchResult).map((TasksModel task){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                    child: InkWell(
                      onTap: ()async{
                        value.showTask(AnimationController(vsync: this, duration: const Duration(milliseconds: 300),),
                            ListView(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: value.widgetColor(),
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: value.widgetColor()
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: task.done == 0 ? false : true,
                                    activeColor: value.primaryColor,
                                    checkColor: Colors.white,
                                    onChanged: (v) async {
                                      HapticFeedback.mediumImpact();
                                      TasksModel newTask = TasksModel(date: task.date,notification: task.notification,done: task.done == 0 ? 1 : 0,create: task.create,name: task.name,des: task.des,images: task.images,id: task.id);
                                      await value.sql.updateDataSql('taskTable', newTask, 'id = ?', task.id, 'taskTable');
                                      value.getNoteFromSql();
                                      //var response = await value.sql.insertDataSql('taskTable',newTask.toMap(),'taskTable');
                                    },
                                  ),
                                  Text(task.done == 0 ? 'غير مكتمله' : 'مكتمله',textAlign: TextAlign.right,
                                    style: GoogleFonts.almarai(fontSize: 10,color: value.textColor()),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 50,),
          ],
        );
      },
    );
  }
  icon(mainControoler value){
    if(search.text != ''){
      return InkWell(
        onTap: (){
          setState(() {
            search.clear();
            searchResult.clear();
          });
        },
          child: Icon(Icons.close,color: value.textColor(),));
    }else{
      return const SizedBox();
    }
  }
}

