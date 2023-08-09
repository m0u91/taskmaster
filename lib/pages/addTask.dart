import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:taskmaster/getController/mainController.dart';
import 'package:taskmaster/sqlLiteModels/tasksModel.dart';
import 'package:uuid/uuid.dart';

import '../getController/loading.dart';

class addTask extends StatefulWidget {
  const addTask({Key? key}) : super(key: key);

  @override
  State<addTask> createState() => _addTaskState();
}

class _addTaskState extends State<addTask> {

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  bool _notification = true;
  DateTime? date;
  bool load = false;

  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<mainControoler>(
      builder: (value){
        return InkWell(
          onTap: (){
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: ()async{
                    final img = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
                    List<int> bytes = File(img!.path).readAsBytesSync();
                    setState(() {
                      image = Uint8List.fromList(bytes);
                    });
                  },
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: value.widgetColor(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Lottie.asset('imgs/background.json',fit: BoxFit.fill)),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  color: value.widgetColor(),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: value.widgetColor()
                                    ),
                                    child: image == null ?
                                    Center(child: Icon(Icons.add,color: value.textColor(),),) :
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(image!,fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2,),
                                Text('اختيار صوره للمهام',textAlign: TextAlign.center,
                                style: GoogleFonts.almarai(fontSize: 14,color: value.textColor()),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.right,
                    controller: title,

                    style: GoogleFonts.almarai(fontSize: 14,color: value.textColor(),),
                    decoration: InputDecoration(
                      hintText: 'العنوان',
                      filled: true,
                      fillColor: value.isDarkMode ? value.widgetColor() : const Color(0xffa2b5cc).withOpacity(0.5),
                      prefixIcon: Icon(Icons.edit,color: value.primaryColor,),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.right,
                    controller: description,
                    style: GoogleFonts.almarai(fontSize: 14,color: value.textColor(),),
                    decoration: InputDecoration(
                      hintText: 'المهام المراد اضافتها',
                      filled: true,
                      fillColor: value.isDarkMode ? value.widgetColor() : const Color(0xffa2b5cc).withOpacity(0.5),
                      prefixIcon: Icon(Icons.edit,color: value.primaryColor,),
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
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: value.widgetColor()
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('تشغيل اشعار التذكير',textAlign: TextAlign.right,
                            style: GoogleFonts.almarai(fontSize: 14,color: value.textColor()),),
                          Switch(
                            value: _notification,
                            onChanged: (v){
                              setState(() {
                                _notification = v;
                              });
                            },
                            activeColor: value.primaryColor,
                          ),
                        ],
                      )
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: InkWell(
                  onTap: (){selectDateTime(context);},
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: Get.width,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: date == null ? value.widgetColor() : value.primaryColor
                      ),
                      child: Center(
                        child: Text(date == null ? 'حدد تاريخ و وقت التذكيز' : 'تم التحديد',textAlign: TextAlign.center,
                          style: GoogleFonts.almarai(fontSize: 16,color: date == null ? value.textColor() : Colors.white),),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: load ? const loading() : InkWell(
                  onTap: () async {
                    if(title.text == '' || description.text == '' || date == null){
                      value.returnMessgae('تنبيه', 'عليك كتابه عنوان و وصف المهام');
                    }else{
                      await addToSql(value);
                    }
                  },
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
                        child: Text('انشاء',textAlign: TextAlign.center,
                          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the selected date and time into a single DateTime object
        setState(() {
          date = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  addToSql(mainControoler value)async{
    setState(() {
      load = true;
    });
    TasksModel newTask = TasksModel(date: date == null ? '' : date.toString(),des: description.text,notification: _notification ? 1 : 0,done: 0,create: DateTime.now().toString(),name: title.text,images: image == null ? '' : image.toString());
    var response = await value.sql.insertDataSql('taskTable',newTask.toMap(),'taskTable');
    if(_notification){
      if(response != 0){
        await value.scheduleNotifications(date!.hour,date!.minute,title.text,description.text);
        title.clear();
        date = null;
        image = null;
        description.clear();
        setState(() {
          load = false;
        });
        value.returnMessgae('ممتاز', 'تمت الاضافه الى المهام');
      }else{
        setState(() {
          load = false;
        });
        value.returnMessgae('تنبيه', 'حدث خطا ما');
      }
    }else{
      if(response != 0){
        title.clear();
        image = null;
        description.clear();
        date = null;
        setState(() {
          load = false;
        });
        value.returnMessgae('ممتاز', 'تمت الاضافه الى المهام');
      }else{
        setState(() {
          load = false;
        });
        value.returnMessgae('تنبيه', 'حدث خطا ما');
      }
    }
    await value.getNoteFromSql();
  }
}