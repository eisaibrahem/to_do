import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:to_do/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload ;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.primaryColor,
        title: Text(widget.payload.toString().split("|")[0]),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed:(){
            Get.back();
            },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
               children:[
                  Text('Hello Eisa',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                  ),
                  ),
                  const SizedBox(height: 10,),
                   Text('you have a new message',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                    ),
                  ),

               ],
            ),
            const SizedBox(height: 10,),
            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: primaryClr,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.text_format,size: 35,color: Colors.white,),
                        SizedBox(width: 20,),
                        Text("Title",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        ),
                        ],
                    ),
                    const SizedBox(height: 20,),
                    Text(widget.payload.toString().split("|")[1],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: const [
                        Icon(Icons.description,size: 35,color: Colors.white,),
                        SizedBox(width: 20,),
                        Text("Description",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Text(widget.payload.toString().split("|")[1],
                      style:  const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: const [
                        Icon(Icons.calendar_month,size: 35,color: Colors.white,),
                        SizedBox(width: 20,),
                        Text("Date",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Text(widget.payload.toString().split("|")[2],
                      style:  const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      )
                    ),
                  ],
                ),
              ),
            ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
