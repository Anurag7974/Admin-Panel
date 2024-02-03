import 'package:admincontrol/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/utils.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key,
    required this.heading,
    required this.newsImages,
    required this.subHeading,
    required this.dateTime}) : super(key: key);
  final String heading, newsImages, subHeading;
  final Timestamp dateTime;

  @override
  _NewsWidgetState createState() => _NewsWidgetState();

}

class _NewsWidgetState extends State<NewsWidget> {
  late String orderDateStr;
  @override
  void initState(){
    var postDate = widget.dateTime.toDate();
    orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
    super.initState();
  }

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
                Flexible(
                  flex: size.width < 650 ? 3 : 1,
                  child: Image.network( widget.newsImages,
                    // 'https://www.freepnglogos.com/uploads/bitcoin-png/bitcoin-all-about-bitcoins-9.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget(text: widget.heading, color: color, textSize: 16, isTitle: true,),
                        TextWidget(text: widget.subHeading, color: color, textSize: 14, isTitle: false),
                        Text(orderDateStr),
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