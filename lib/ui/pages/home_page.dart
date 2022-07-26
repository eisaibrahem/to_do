import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do/db/db_helper.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/services/notification_services.dart';
import 'package:to_do/services/theme_services.dart';
import 'package:to_do/ui/pages/add_task_page.dart';
import 'package:to_do/ui/pages/notification_screen.dart';
import 'package:to_do/ui/size_config.dart';
import 'package:to_do/ui/theme.dart';
import 'package:to_do/ui/widgets/button.dart';
import 'package:to_do/ui/widgets/task_tile.dart';

import '../../controllers/task_controller.dart';
import '../widgets/components/components.dart';
import '../widgets/input_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  initState(){
    super.initState();
    notifyHelper =NotifyHelper();
    notifyHelper.flutterLocalNotificationsPlugin;
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }
   DateTime _selectedDate =DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDataBar(),
          const SizedBox(height: 6,),
          _showTasks(),
        ],
      ),
    );
  }


  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      title: Text('Home',
        style: titleStyle,
      ),
      leading: IconButton(
        icon: Icon(
          (Get.isDarkMode) ?
          Icons.wb_sunny_outlined:Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
        onPressed:()async{
          ThemeServices().switchTheme();
          //notifyHelper.displayNotification(title: 'theme Changed',body: 'thanks man ');
          showToast(text:'theme Changed', state:ToastStates.SUCCESS);

        },
      ),
      actions: [
        IconButton(
          icon:const Icon(Icons.delete_sweep_outlined),
          onPressed:(){
            _taskController.deleteAllTasks();
            notifyHelper.deleteAllNotification();

          },
        ),
        IconButton(
          icon:const Icon(Icons.notifications_sharp),
          onPressed:(){
            Get.to(() =>const NotificationScreen(payload:'notificationScreen|description|10/20/2002'));
          },
        ),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only( left: 20,right: 10,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${DateFormat('MMMM d, y').format(DateTime.now())} ',
              style: subTitleStyle,
              ),
              Text('Today',
              style: titleStyle,
              ),
            ],
          ),
          MyButton(
              label: '+ Add Task',
              onTap: ()async{
                  await Get.to(() =>const AddTaskPage());
                  _taskController.getTasks();
              },
          ),
        ],
      ),
    );
  }

  _addDataBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6,left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 70,
        dateTextStyle: subHeadingStyle.copyWith(
            color: Colors.grey,
           fontWeight: FontWeight.w600
        ),
        monthTextStyle: subTitleStyle.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w600
        ),
        dayTextStyle:subTitleStyle.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w600
        ),
        initialSelectedDate: DateTime.now(),
        selectedTextColor:Colors.white ,
        selectionColor: primaryClr,
        onDateChange: (newDate){
          setState(
              (){
                _selectedDate=newDate;
              }
          );
        },

      ),
    );
  }
Future<void>_onRefresh()async{
    await _taskController.getTasks();
  }

 Widget _showTasks() {
    return Expanded(
      child: Obx(
        () {
          if(_taskController.taskList.isEmpty){
            return _noTaskMsg();
          }else{
            return RefreshIndicator(
              onRefresh:_onRefresh,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: SizeConfig.orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
                itemBuilder: (BuildContext context, index) {
                  var task = _taskController.taskList[index];
                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(_selectedDate)||
                      (task.repeat == 'Weekly' &&_selectedDate.difference(DateFormat.yMd().parse(task.date)).inDays%7==0)||
                      (task.repeat == 'Monthly' && DateFormat.yMd().parse(task.date!).day==_selectedDate.day)

                          
                  ){
                    var hour=task.startTime.toString().split(':')[0];
                    var minute=task.startTime.toString().split(':')[1];

                    var date=DateFormat.jm().parse(task.startTime!);
                    var myTime=DateFormat('HH:mm').format(date);
                    notifyHelper.scheduledNotification(
                        int.parse(myTime.toString().split(':')[0]),
                        int.parse(myTime.toString().split(':')[1]),
                        task);
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: ()=> _showBottomSheet(context, task,),
                            child: TaskTile(
                              task: task,
                            ),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }
                },
                itemCount:_taskController.taskList.length,


              ),
            );
          }

        },
      ),
    );

    // return GestureDetector(
    //   onTap: (){
    //     _showBottomSheet(context,Task(
    //       title: 'No Task',
    //       note: 'No Task',
    //       isCompleted: 0,
    //       date: 'No Task',
    //       startTime: 'No Task',
    //       endTime: 'No Task',
    //       color: 0,
    //       remind: 0,
    //       repeat: 'No Task',
    //     ));
    //   },
    //   child: Container(
    //       child:(_taskController.taskList.isEmpty)? TaskTile(
    //         task: Task(
    //           title: 'No Task',
    //           note: 'No Task',
    //           isCompleted: 0,
    //           date: 'No Task',
    //           startTime: 'No Task',
    //           endTime: 'No Task',
    //           color: 0,
    //           remind: 0,
    //           repeat: 'No Task',
    //         ),
    //       ) : Container()
    //   ),
    // );
  }

  _noTaskMsg() {
    return Stack(
      children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            child: RefreshIndicator(
              onRefresh:_onRefresh,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction:(SizeConfig.orientation == Orientation.landscape)? Axis.horizontal:Axis.vertical,
                  children:  [
                    (SizeConfig.orientation == Orientation.landscape)?
                    const SizedBox(height: 6,):const SizedBox(height: 220),
                  SvgPicture.asset(
                      'images/task.svg',
                    height: 90,
                    color: primaryClr.withOpacity(0.5),
                  ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:30.0),
                      child: Text('you do not have any tasks yet \n add a new task to make your day perfect ',
                      style: subTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    (SizeConfig.orientation == Orientation.landscape)?
                    const SizedBox(height: 120,):const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }


  _bulildBottomSheet({
    required String label,
    required Function() onTap,
     bool isClose=false,
    required Color clr,
}){
return GestureDetector(
  onTap: onTap,
  child:   Container(
     margin: const EdgeInsets.symmetric(vertical: 4),
     height: 65,
      width: SizeConfig.screenWidth*0.9,

    decoration: BoxDecoration(

      color:isClose? Colors.transparent:clr,

      borderRadius: BorderRadius.circular(20),

      border: Border.all(

          width: 2,

          color: (isClose) ?( (Get.isDarkMode) ? Colors.grey[600]! : Colors.grey[300]! ) :clr,

      ),

    ),

    child: Center(
      child: Text('$label',
        style:isClose? titleStyle:titleStyle.copyWith(
          color: Colors.white,
        ),
      ),
    ),

  ),
);


  }

  _showBottomSheet(BuildContext context , Task task)async{
    await Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding:const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ?(task.isCompleted==1)
          ?SizeConfig.screenHeight*0.6:SizeConfig.screenHeight*0.8:(task.isCompleted==1)
              ?SizeConfig.screenHeight*0.3:SizeConfig.screenHeight*0.4,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                  child: Container(
                height: 6,
                width: 120,
                    decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.grey[600] :  Colors.grey[300] ,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              ),
           const SizedBox(height: 20,),
              task.isCompleted==1?
                  Container():_bulildBottomSheet(
                label: 'Task Completed',
                  onTap: (){
                    _taskController.updateISCompletedMark(task.id!);
                    Get.back();
                  },
                  clr: primaryClr,
              ),
              _bulildBottomSheet(
                label: 'Delete Task',
                onTap: (){
                  _taskController.deleteTask(task.id!).then((value){
                  });
                  notifyHelper.deleteNotification(task.id!);
                  Get.back();
                },
                clr: Colors.red,
              ),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
                thickness: 1,
              ),
              _bulildBottomSheet(
                label: 'Close',
                onTap: (){
                  Get.back();
                },
                clr: primaryClr,
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      )
    );
  }


}
