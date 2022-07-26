import 'package:flutter/material.dart';
import 'package:to_do/ui/size_config.dart';
import 'package:to_do/ui/theme.dart';
import '../../models/task.dart';

class TaskTile extends StatelessWidget {
  TaskTile({Key? key, this.task}) : super(key: key);

  final Task? task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(
              (SizeConfig.orientation == Orientation.landscape) ? 4 : 20)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(
          bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _getBGClr(task!.color),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task!.title!,
                    style: subTitleStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('${task!.startTime} - ${task!.endTime}',
                    style: subTitleStyle.copyWith(
                      color: Colors.grey[100],
                      fontSize: 13,
                    ),
                    ),
                  ],),
                 const SizedBox(height: 12,),
                  Text(task!.note!,
                  style: subTitleStyle.copyWith(
                      color: Colors.grey[100],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
            ),
  //divider
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10)),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
                quarterTurns: 5,
                child: Text(
                  task!.isCompleted == 0 ? 'TO DO' : 'Completed',
                  style: subTitleStyle.copyWith(
                    color:
                        task!.isCompleted == 0 ? Colors.grey[300] : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color)
  {
    switch(color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
