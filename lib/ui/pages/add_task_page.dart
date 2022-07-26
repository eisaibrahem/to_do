import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do/controllers/task_controller.dart';
import 'package:to_do/ui/theme.dart';
import 'package:to_do/ui/widgets/button.dart';
import '../../models/task.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'enter title',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'enter note',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDate();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTime(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.watch_later_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTime(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.watch_later_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      items: remindList
                          .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem(
                              value: value.toString(),
                              child: Text('$value'),
                            ),
                          )
                          .toList(),
                      icon: const Icon(Icons.keyboard_arrow_down_sharp,
                      color: Colors.grey,
                      size: 30),
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      onChanged: (String? newValue) {
                        setState((){
                          _selectedRemind=int.parse(newValue!);
                        });
                      },
                    ),
                    const SizedBox(width: 6,)
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      items: repeatList
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      icon: const Icon(Icons.keyboard_arrow_down_sharp,
                      color: Colors.grey,
                      size: 30),
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      onChanged: (String? newValue) {
                        setState((){
                          _selectedRepeat=newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 6,)
                  ],
                ),
              ),
              const SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    MyButton(
                      label: 'Create Task',
                        onTap: (){
                          _validData();
                    },
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Text('Color',style: titleStyle,),
        const SizedBox(height: 8,),
        Wrap(
          children:
            List<Widget>.generate(3, (index) =>
                GestureDetector(
                  onTap: (){
                    setState(
                      () {
                        _selectedColor=index;
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor:(index==0)?
                      primaryClr:
                          (index==1)?
                              pinkClr:orangeClr,
                      child:_selectedColor==index? const Icon(
                        Icons.done,
                        size: 16,
                        color: Colors.white,
                      ):null,
                    ),
                  ),
                ),
            ),

        )
      ],
    );
  }
  _appBar() {
    return AppBar(
    leading: IconButton(
      onPressed: (){
       Get.back();
      },
      icon: const Icon(
        Icons.arrow_back,size: 24,color: primaryClr,
      ),
    ),
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      actions: const [
        CircleAvatar(
          backgroundImage:AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(width: 20,)
      ],
    );
 }
 _addTaskToDb() async {
    int idValue = await _taskController.addTask(
     Task(
        title: _titleController.text,
        note: _noteController.text,
        startTime: _startTime,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
      ),
    );
    _taskController.getTasks();
    print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
    print('idValue: $idValue');
    print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
 }
  _validData(){
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();
  }else if(_titleController.text.isEmpty||_noteController.text.isEmpty){
    Get.snackbar(
        'Error', 'Please enter title and note',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white.withOpacity(0.9),
        colorText: pinkClr,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
        icon: Icon(
          Icons.warning_amber_outlined,
          color: pinkClr,
        ),
      animationDuration: Duration(milliseconds: 500),

        );
    }else{

    }
    }

  void _getDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    ).then((DateTime? date) {
      if (date != null) {
        setState(() {
          _selectedDate = date;
        });
      }
    });
  }

  void _getTime({required bool isStartTime}) async {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((TimeOfDay? time) {
      String _formattedTime = time!.format(context);
      setState(() {
        if (isStartTime) {
          _startTime = _formattedTime;
        } else {
          _endTime = _formattedTime;
        }
      });
    });
  }

}
