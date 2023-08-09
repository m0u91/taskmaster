import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taskmaster/getController/mainController.dart';
import 'package:url_launcher/url_launcher.dart';


class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {


  List<Color> colors = [Colors.red,Colors.blue,Colors.deepOrange,Colors.green,Colors.purple,Colors.indigo,Colors.orange,Colors.pink,Colors.teal];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<mainControoler>(
      builder: (value){
        return WillPopScope(
          onWillPop: () async {
            // Disable the back button by returning false
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 2,
              title: Text('الاعدادات',textAlign: TextAlign.center,
                style: GoogleFonts.almarai(fontSize: 16,color: value.textColor()),),
              backgroundColor: value.widgetColor(),
              leading: IconButton(
                onPressed: (){Get.back();},
                icon: Icon(Icons.keyboard_arrow_left,color: value.textColor(),),
              ),
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                  gradient: value.backgroundColor()
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: (){
                          value.returnMessgae('عذرا', 'التطبيق في وضع التطوير حاليا');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('imgs/logo.png',height: 65,width: 65,),
                                const SizedBox(width: 10,),
                                Container(
                                  height: 40,
                                  width: 3,
                                  color: value.primaryColor,
                                ),
                                const SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('محمد اسماعيل الجاف',textAlign: TextAlign.right,
                                      style: GoogleFonts.almarai(fontSize: 17,color: value.textColor(),fontWeight: FontWeight.bold),),
                                    Text('07719019877',textAlign: TextAlign.right,
                                      style: GoogleFonts.almarai(fontSize: 15,color: value.textColor()),),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.edit,color: value.textColor() ,size: 20,),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
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
                                Text('الوضع الليلي',textAlign: TextAlign.right,
                                  style: GoogleFonts.almarai(fontSize: 15,color: value.textColor()),),
                                Switch(
                                  value: value.isDarkMode,
                                  onChanged: (v){
                                    HapticFeedback.mediumImpact();
                                    value.changeTheme(v);
                                  },
                                  activeColor: value.primaryColor,
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('اختر لون للتطبيق مناسب لك',textAlign: TextAlign.right,
                                  style: GoogleFonts.almarai(fontSize: 15,color: value.textColor()),),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: Get.width,
                                  height: 45,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: colors.length,
                                    itemBuilder: (context,index){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                        child: InkWell(
                                          onTap: ()async{
                                            HapticFeedback.mediumImpact();
                                            await value.changeColor(colors[index]);
                                            setState(() {

                                            });
                                          },
                                          child: Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: Container(
                                              width: 37,
                                              height: 37,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: colors[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('اعمالنا ..',textAlign: TextAlign.right,
                        style: GoogleFonts.almarai(fontSize: 15,color: value.textColor()),),
                    ),
                    const SizedBox(height: 10,),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: apps.length,
                      itemBuilder: (context,index){
                        return box(value, apps[index]['name'], apps[index]['img'], apps[index]['link']);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }





  Widget box(mainControoler value,name,img,android){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: (){
          _launchUrl(android);
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: value.widgetColor()
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(img,fit: BoxFit.cover,width: 55,height: 55,),
                    ),
                    const SizedBox(width: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name,textAlign: TextAlign.right,
                          style: GoogleFonts.almarai(fontSize: 14,color: value.textColor(),fontWeight: FontWeight.bold),),
                        const SizedBox(height: 5,),
                        Text(img == 'imgs/logo.png' ? 'على Google play & App store' : 'متوفر على كل من :  Google play & App store',textAlign: TextAlign.right,
                          style: GoogleFonts.almarai(fontSize: 11,color: value.textColor()),),
                      ],
                    ),
                    const SizedBox(width: 5,),
                  ],
                ),
                Icon(Icons.subdirectory_arrow_left_rounded,color: value.textColor(),)
              ],
            ),
          ),
        ),
      ),
    );
  }
  List apps = [
    {'name': 'الاجراس للعقارات و المقاولات','img': 'imgs/ajras.png','link': 'https://play.google.com/store/apps/details?id=futuremohammed.ajras.untitled'},
    {'name': 'المستقبل لادارة الوصولات','img': 'imgs/future.png','link': 'https://play.google.com/store/apps/details?id=jaf.free.tlal'},
    {'name': 'سهله','img': 'imgs/sahla.png','link': 'https://play.google.com/store/apps/details?id=jaf.free.sahla'},
    {'name': 'Fly Box','img': 'imgs/fly.png','link': 'https://play.google.com/store/apps/details?id=mohammed.jaf.flybox'},
    {'name': '7 Days','img': 'imgs/days.png','link': 'https://play.google.com/store/apps/details?id=jaf.free.dropshiping'},
    {'name': 'ماسة الشفاء البيطريه','img': 'imgs/nimal.png','link': 'https://play.google.com/store/apps/details?id=jaf.free.animalshop'},
    {'name': 'المزيد من التطبيق','img': 'imgs/logo.png','link': 'https://play.google.com/store/apps/dev?id=8494833807445194279'},

  ];
  void _launchUrl(String Url) async {
    if (await canLaunch(Url)) {
      await launch(Url);
    } else {
      throw 'Could not launch url';
    }
  }

}





