import 'package:admincontrol/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../services/utils.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key,
    required this.heading,
    required this.deadLine,
    required this.subHeading,}) : super(key: key);
  final String heading, deadLine, subHeading;

  @override
  _TasksWidgetState createState() => _TasksWidgetState();

}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget(text: widget.heading, color: color, textSize: 16, isTitle: true,),
                        const SizedBox(height: 5,),
                        TextWidget(text: widget.subHeading, color: color, textSize: 14, isTitle: false),
                        const SizedBox(height: 10,),
                        TextWidget(text:'DeadLine:- ${widget.deadLine}', color: Colors.red, textSize: 12, isTitle: true),
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}